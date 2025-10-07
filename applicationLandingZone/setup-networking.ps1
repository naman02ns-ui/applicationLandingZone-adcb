# Azure Networking Setup Script
# Creates VNet, Subnets, and Private DNS Zones for AI Apps Infrastructure

param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "rg-dev-uan-aiapps",

    [Parameter(Mandatory = $false)]
    [string]$Location = "uaenorth",

    [Parameter(Mandatory = $false)]
    [string]$VNetName = "vnet-aiapps-dev-uan",

    [Parameter(Mandatory = $false)]
    [string]$AddressSpace = "10.114.164.0/22"
)

Write-Host "=== Azure Networking Setup Script ===" -ForegroundColor Green
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Yellow
Write-Host "Location: $Location" -ForegroundColor Yellow
Write-Host "VNet: $VNetName" -ForegroundColor Yellow
Write-Host "Address Space: $AddressSpace" -ForegroundColor Yellow
Write-Host ""

# Step 1: Create VNet
Write-Host "Step 1: Creating VNet..." -ForegroundColor Cyan
try {
    $vnet = az network vnet create `
        --resource-group $ResourceGroupName `
        --name $VNetName `
        --address-prefix $AddressSpace `
        --location $Location `
        --tags "Application=AIApps" "Environment=Development" "CreatedBy=PowerShell" "Project=ApplicationLandingZone" | ConvertFrom-Json

    Write-Host "✅ VNet created successfully: $($vnet.newVNet.name)" -ForegroundColor Green
}
catch {
    Write-Host "❌ Failed to create VNet: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Create Subnets with proper addressing and delegations
Write-Host ""
Write-Host "Step 2: Creating Subnets..." -ForegroundColor Cyan

$subnets = @(
    @{
        Name = "snet-container-apps"
        AddressPrefix = "10.114.164.0/23"
        Delegation = "Microsoft.App/environments"
        Description = "Container Apps Environment"
    },
    @{
        Name = "snet-function-apps-inbound"
        AddressPrefix = "10.114.166.0/25"
        Delegation = $null
        Description = "Function Apps Inbound"
    },
    @{
        Name = "snet-function-apps-outbound"
        AddressPrefix = "10.114.166.128/25"
        Delegation = "Microsoft.Web/serverFarms"
        Description = "Function Apps Outbound"
    },
    @{
        Name = "snet-privatelink"
        AddressPrefix = "10.114.167.0/26"
        Delegation = $null
        Description = "Private Endpoints"
    },
    @{
        Name = "snet-app-service"
        AddressPrefix = "10.114.167.64/26"
        Delegation = $null
        Description = "App Service Plans"
    },
    @{
        Name = "snet-logic-apps"
        AddressPrefix = "10.114.167.128/25"
        Delegation = $null
        Description = "Logic Apps"
    }
)

foreach ($subnet in $subnets) {
    Write-Host "Creating subnet: $($subnet.Name) ($($subnet.AddressPrefix))" -ForegroundColor Yellow

    try {
        if ($subnet.Delegation) {
            $result = az network vnet subnet create `
                --resource-group $ResourceGroupName `
                --vnet-name $VNetName `
                --name $subnet.Name `
                --address-prefix $subnet.AddressPrefix `
                --delegations $subnet.Delegation | ConvertFrom-Json

            Write-Host "✅ Subnet created with delegation: $($subnet.Delegation)" -ForegroundColor Green
        }
        else {
            $result = az network vnet subnet create `
                --resource-group $ResourceGroupName `
                --vnet-name $VNetName `
                --name $subnet.Name `
                --address-prefix $subnet.AddressPrefix | ConvertFrom-Json

            Write-Host "✅ Subnet created (no delegation)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "❌ Failed to create subnet $($subnet.Name): $_" -ForegroundColor Red
    }
}

# Step 3: Create Private DNS Zones
Write-Host ""
Write-Host "Step 3: Creating Private DNS Zones..." -ForegroundColor Cyan

$privateDnsZones = @(
    "privatelink.vaultcore.azure.net",          # Key Vault
    "privatelink.azurecr.io",                   # Container Registry
    "privatelink.blob.core.windows.net",       # Storage Account Blob
    "privatelink.file.core.windows.net",       # Storage Account Files
    "privatelink.queue.core.windows.net",      # Storage Account Queue
    "privatelink.table.core.windows.net",      # Storage Account Table
    "privatelink.azurewebsites.net"            # Function Apps
)

foreach ($dnsZone in $privateDnsZones) {
    Write-Host "Creating Private DNS Zone: $dnsZone" -ForegroundColor Yellow

    try {
        # Create Private DNS Zone
        $zone = az network private-dns zone create `
            --resource-group $ResourceGroupName `
            --name $dnsZone `
            --tags "Application=AIApps" "Environment=Development" "CreatedBy=PowerShell" | ConvertFrom-Json

        # Link to VNet
        $linkName = "$VNetName-$($dnsZone.Replace('.', '-'))-link"
        $link = az network private-dns link vnet create `
            --resource-group $ResourceGroupName `
            --zone-name $dnsZone `
            --name $linkName `
            --virtual-network $VNetName `
            --registration-enabled false | ConvertFrom-Json

        Write-Host "✅ Private DNS Zone created and linked to VNet" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to create Private DNS Zone $dnsZone : $_" -ForegroundColor Red
    }
}

# Step 4: Summary
Write-Host ""
Write-Host "=== NETWORKING SETUP COMPLETE ===" -ForegroundColor Green
Write-Host "✅ Resource Group: $ResourceGroupName" -ForegroundColor White
Write-Host "✅ VNet: $VNetName ($AddressSpace)" -ForegroundColor White
Write-Host "✅ Subnets: $($subnets.Count) subnets created" -ForegroundColor White
Write-Host "✅ Private DNS Zones: $($privateDnsZones.Count) zones created and linked" -ForegroundColor White
Write-Host ""
Write-Host "Network infrastructure is ready for Terraform deployment!" -ForegroundColor Yellow

# Display subnet summary
Write-Host ""
Write-Host "=== SUBNET SUMMARY ===" -ForegroundColor Cyan
foreach ($subnet in $subnets) {
    $delegation = if ($subnet.Delegation) { " (Delegated: $($subnet.Delegation))" } else { "" }
    Write-Host "$($subnet.Name): $($subnet.AddressPrefix)$delegation" -ForegroundColor White
}
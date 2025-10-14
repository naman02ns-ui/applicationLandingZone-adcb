## AI services NonProd##

environment = "nonprod"
application_name = "aiservices"
ainonprod_sub_id = "65ccdd9b-60c6-4688-90f6-01cbc0a039c4"  #- This is sub ID for AI-Services non-prod

#--------------Network--------------------#
vnet_address_spaces = ["10.114.168.0/24"]
subnets = {

open-ai-subnet1 = {
  subnet_name = "snet-ai-agents-uaenorth-001"
  subnet_address_prefix = ["10.114.168.0/27"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "ai-agents"
    service_delegation = {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
aihub-pe-subnet2 = {
  subnet_name = "snet-ai-hub-private-endpoint-uaenorth-001"
  subnet_address_prefix = ["10.114.168.224/27"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]
}

ai-hub-eventhub-subnet3 = {
  subnet_name = "snet-ai-hub-eventhub-uaenorth-001"
  subnet_address_prefix = ["10.114.168.192/27"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]
}

snet-aihub-apim-subnet4 = {
  subnet_name = "snet-ai-hub-apim-uaenorth-001"
  subnet_address_prefix = ["10.114.168.160/27"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "delegation"
    service_delegation = {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

aiservices-pe-subnet5 = {
  subnet_name = "snet-aiservices-pe-uaenorth-001"
  subnet_address_prefix = ["10.114.168.128/27"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]
}

}
#--------------Network--------------------#

#--------------Cosmos--------------------# 

selected_subnet = "snet-aiservices-pe-uaenorth-001"  

entity_name = "aiservices"

# Cosmos DB - Mongo
databases = {
  ailighthouse-prod-platform-db = {
    description    = "Mongo Database"
    max_throughput = 10000
    collections = [{ name = "application", shard_key = "key1" },
      { name = "payment", shard_key = "key2" },
    { name = "refdata", shard_key = "key3" }]
  }
}

#--------------storage--------------------# 

containername = "aifoundry"

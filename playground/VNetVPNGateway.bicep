param location string {
  default: resourceGroup().location
  metadata: {
    description: 'Specifies the Azure location where the resource should be created.'
  }
}
param vpngwpipname string {
  metadata: {
    description: 'Specifies the name to use for the VM resource.'
  }
}
param vpngwname string {
  metadata: {
    description: 'Specifies the name to use for the VM resource.'
  }
}
param subnetref string {
  metadata: {
    description: 'Specifies the resource id of the subnet to connect the VM to.'
  }
}

resource vpngwpip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: vpngwpipname
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'    
  }
}

resource vpngw 'Microsoft.Network/virtualNetworkGateways@2020-06-01' = {
  name: vpngwname
  location: location    
  properties: {
      gatewayType: 'Vpn'
      ipConfigurations: [
          {
              name: 'default'
              properties: {
                  privateIPAllocationMethod: 'Dynamic'
                  subnet: {
                      id: subnetref
                  }
                  publicIPAddress: {
                      id: vpngwpip.id
                  }
              }
          }
      ]
      activeActive: false
      enableBgp: true
      bgpSettings: {
          asn: 65010
      }
      vpnType: 'RouteBased'
      vpnGatewayGeneration: 'Generation1'
      sku: {
          name: 'VpnGw1AZ'
          tier: 'VpnGw1AZ'
      }
  }
}

output id string = vpngw.id
output ip string = vpngwpip.properties.ipAddress
output bgpaddress string = vpngw.properties.bgpSettings.bgpPeeringAddress
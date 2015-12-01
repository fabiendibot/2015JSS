# Demo03-DSC.ps1
# Création configuration pour une configuration SNMP
Configuration Test2 {
 
    Node localhost {
 
        WindowsFeature SNMPService {
    
            Name = 'SNMP-Service'
            Ensure = 'Present'
 
        }
 
        WindowsFeature SNMPRSAT {
 
            Name = 'RSAT-SNMP'
            Ensure = 'Present'
 
        } 
     
    }
}

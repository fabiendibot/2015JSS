# Se connecter à Azure grace à un certificat
Get-AzurePublishSettingsFile
Import-AzurePublishSettingsFile -PublishSettingsFile D:\JSS2015\Work\JSS1015.publishsettings

# Configurer son abonnement par défaut
Set-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN'
Select-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN'

# Création d'un compte de stockage
New-AzureStorageAccount -StorageAccountName 'jss15015' -Description "Paris c'est bien, Rennes c'est mieux!" `
                        -Label "Bzh" -Location "North Europe"

# Assigner le compte de stockage à l'abonnement
Set-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN' `                -CurrentStorageAccountName 'jss15015'

# Création de l'affinity group
New-AzureAffinityGroup -Name jss15015 -Description "Demo Affinity group" -Label "Amsterdam Datacenter" -Location "North Europe"

# Configuration de la VM
$VM = New-AzureVMConfig -Name "jss15015" -InstanceSize Small `
     -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20150825-en.us-127GB.vhd"
$VM = Add-AzureProvisioningConfig -VM $VM -Windows -AdminUsername "Administrateur" -Password "Th1sIs@P4ss"

# Création de la VM
New-AzureVM -VM $VM -ServiceName jss15015 -WaitForBoot -AffinityGroup jss15015 -verbose
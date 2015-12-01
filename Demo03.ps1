# ASM
# Trouver un module dans PSGallery
#Find-Module Azure

# Installer le module
#Install-Module Azure -RequiredVersion 0.9.11 -Scope AllUsers

# Se connecter à Azure
Import-AzurePublishSettingsFile -PublishSettingsFile D:\JSS2015\Work\AzureAccount.publishsettings

# Configurer son abonnement par défaut
Set-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN'
Select-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN'

# Création d'un compte de stockage
New-AzureStorageAccount -StorageAccountName 'jss15004' -Description "Dark Vador n'est pas ton père !" `
                        -Label "Bzh" -Location "North Europe"

# Assigner le compte de stockage à l'abonnement
Set-AzureSubscription -SubscriptionName 'Visual Studio Ultimate avec MSDN' -CurrentStorageAccountName 'jss15004'

# Création de l'affinity group
New-AzureAffinityGroup -Name jss15004 -Description "Demo Affinity group" `
                        -Label "Amsterdam Datacenter" -Location "North Europe"

# Création du contexte de stockage
$Key = Get-AzureStoragekey -StorageAccountName 'jss15004'
$Context = New-AzureStorageContext -StorageAccountName 'jss15004' -StorageAccountKey $Key.Primary

# Création d'un container de stockage
New-AzureStorageContainer -Name demojss15004 -Context $Context

# Publication de la configuration DSC
Publish-AzureVMDscConfiguration -ConfigurationPath D:\JSS2015\Demos\Demo03-DSC.ps1 `
                               -StorageContext $Context -ContainerName demojss15004

# Configuration de la VM
$VM = New-AzureVMConfig -Name "jss15004" -InstanceSize Small `
      -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20150825-en.us-127GB.vhd"
$VM = Add-AzureProvisioningConfig -VM $VM -Windows -AdminUsername "Administrateur" -Password "Th1sIs@P4ss"

# Affectation de la configurationsur la VM
$VM = Set-AzureVMDSCExtension -VM $VM -StorageContext $Context -ContainerName demojss15004 `
      -ConfigurationArchive "Demo03-DSC.ps1.zip" -ConfigurationName "Test"

# Création de la VM
New-AzureVM -VM $VM -ServiceName jss15004 -WaitForBoot -AffinityGroup jss15004 -verbose
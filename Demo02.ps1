
# login
#Add-AzureRmAccount -Credential (Get-Credential) #Marche pas avec un compte MSDN :)
Add-AzureRmAccount

# Choix de l'abonnement
Get-AzureRmSubscription
Get-AzureRmSubscription –SubscriptionName 'Visual Studio Ultimate avec MSDN' | Select-AzureRmSubscription

# Création d'un resource group
New-AzureRmResourceGroup -Name "jss15004RG" -Location "West Europe" -Tag @{Name="Demo"}

# Création du stockage
$Storage = New-AzureRmStorageAccount -Name "jss15004stockagelive" -ResourceGroupName "jss15004RG" `
            –Type Standard_GRS -Location "West Europe"

# Assignation comme stockage par défaut pour les actions suivantes.
Set-AzureRmCurrentStorageAccount –ResourceGroupName "jss15004RG" –StorageAccountName "jss15004stockagelive"

# Création du réseau/sous-réseau
$Subnet  = New-AzureRmVirtualNetworkSubnetConfig –Name "jss15004France" –addressPrefix "10.0.1.0/24"
$Network = New-AzureRmVirtualNetwork –Name "jss15004Europe" –ResourceGroupName "jss15004RG" –Location "West Europe" `
            –Addressprefix "10.0.0.0/16" –Subnet $Subnet

# Création de la VM
# Début de la configuration de la VM
$VM = New-AzureRMVMConfig –VMName "jss15004" –Vmsize 'Standard_A1'

# Choix du systèmes d'exploitation
$VM = Set-AzureRmVMOperatingSystem -VM $VM -Windows -ComputerName "jss15004" –credential (get-credential)

# Choix de la version de l'OS
$VM = Set-AzureRmVMSourceImage -VM $VM -PublisherName MicrosoftWindowsServer –Offer WindowsServer  `      –skus 2012-R2-Datacenter -Version "latest"

# Création du disque système
$Disk = $Storage.PrimaryEndpoints.Blob.ToString() + "vhds/jss15004.vhd"
$VM = Set-AzureRmVMOSDisk -VM $VM  -Name "SystemOS" -VhdUri $Disk -CreateOption FromImage

# Création de l'interface réseau 
$Nic = New-AzureRmNetworkInterface -Name 'jss15004Nic' -ResourceGroupName "jss15004RG"  `       –Location 'West Europe' -SubnetId $Network.Subnets[0].Id 
$VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $Nic.Id


# Démarage de la création
New-AzureRmVM -ResourceGroupName "jss15004RG" -Location "West Europe" -VM $VM -Verbose

# Azure Automation DSC

Add-AzureRmAccount

# Choix de l'abonnement
Get-AzureRmSubscription –SubscriptionName 'Visual Studio Ultimate avec MSDN' | Select-AzureRmSubscription

# Assignation comme stockage par défaut pour les actions suivantes.
Get-AzureRmAutomationDscOnboardingMetaconfig -ResourceGroupName JSS15001RG -AutomationAccountName jss15001AA

# Enregistrement du Node DSC dans Azure automation
Set-DscLocalConfigurationManager -path C:\Users\Administrateur\DscMetaConfigs

# et TADAAAH !

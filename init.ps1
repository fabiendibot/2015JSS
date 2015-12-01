# Initialisation de l'environnement avec Powershell Package Manager

# ASM
# Trouver un module dans PSGallery
Find-Module Azure

# Installer le module ASM
Install-Module Azure -Force

# ARM
# Installer le module
Install-Module AzureRM

# Installation des modules enfants
Install-AzureRM
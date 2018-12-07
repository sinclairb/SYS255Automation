#Installing AD Role and Features
Install-WindowsFeature AD-Domain-Services,RSAT-ADDS

#Importing Modules 
Import-Module ADDSDeployment

# Making it a DC
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainMode “7” -DomainName “ben.local” -DomainNetbiosName “ben” -ForestMode “7” -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$true -SysvolPath “C:\Windows\SYSVOL” -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "Hamburger69" -AsPlainText -Force)


# Restarting Computer
Restart-Computer -Force

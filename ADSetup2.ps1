# Making Users
New-ADUser -Name "Ben Sinclair" -DisplayName "Ben Sinclair (ADM)" -SamAccountName "ben.sinclair-adm" -UserPrincipalName "ben.sinclair-adm@ben.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "Hamburger69" -Force) -Enabled $true
New-ADUser -Name "Ben Sinclair" -DisplayName "Ben Sinclair" -SamAccountName "ben.sinclair" -UserPrincipalName "ben.sinclair@ben.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "Hamburger69" -Force) -Enabled $true

# Making Users Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "ben.sinclair-adm"

# Making Reverse Lookup Zone 
Add-DnsServerPrimaryZone -NetworkID "10.0.5.0/24" -ReplicationScope "Forest" 

# Making DNS and PTR Records
Add-DnsServerResourceRecordA -Name "blog01-ben" -IPv4Address "10.0.5.20" -ZoneName "ben.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fw01-ben" -IPv4Address "10.0.5.2" -ZoneName "ben.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fs01-ben" -IPv4Address "10.0.5.8" -ZoneName "ben.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "dhcp01-ben" -IPv4Address "10.0.5.33" -ZoneName "ben.local" -CreatePtr

# Renaming Computer 
Rename-Computer -NewName ad01-ben

# Restarting Computer
Restart-Computer -Force

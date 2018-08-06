# Mimecast-API
Houses scripts that I have had to hack togeather to access parts of the Mimecast-API.  Not everything required is here because it was hacked togeather using both python and powershell symotaniously.  All scripts are based off of the examples provided by Mimecast that have been modified to be more user friendly/understandable.


#Powershell Scripts
The Powershell scripts don't play nice with the output returned by the API but will upload information
without issue.

##addGroupMember.ps1
	Will add member to a specified group.  Must supply an email or domain and then a Group ID, Group ID is optional, default is the id for Blocked Senders.
	
##blockSenders.ps1
	Will block a senders address but only on a by recipient basis.  Must supply a sender, recipient, and the action to preform.
	
##getAccessandSecret.ps1
	Prompts you to login to Mimecast and generates the access and secret keys necessary to have other scripts work autonomously.
	
##searchGroups.ps1
	Will search for a group with the supplied value in its name and return information on it.  Without return output this is fairly useless in powershell.
	
#Python Scripts(Linux)
The pythons scripts where written in Linux.  The only thing that would stop them from working in Windows is some hard coded directory paths.
The python scripts will return input in a readable format, unlike Powershell.

##mimecast-AddGroupMember.py
	Will add a member to a group based on id.  Requires email or domain and the Id of the group to add that member to.
	
##mimecast-GroupSearch.py
	Will search for a group with the supplied value in its name and return information on it.

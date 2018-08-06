# Mimecast-API
Houses scripts that I have had to hack togeather to access parts of the Mimecast-API.  Not everything required is here because it was hacked togeather using both python and powershell symotaniously.  All scripts are based off of the examples provided by Mimecast that have been modified to be more user friendly/understandable. All in all it should provide some usefull examples of code that works correctly with the api.


# Powershell Scripts
The Powershell scripts don't play nice with the output returned by the API. They will upload information
without issue, however getting error messages back is difficult to impossible.

## addGroupMember.ps1
Will add member to a specified group.  Must supply an email or domain and then a Group ID.  The Group ID can be found by searching for a child of the group in question.  The group ID is the parent ID returned from the group search.
	
## blockSenders.ps1
Will block a senders address but only on a by recipient basis.  Must supply a sender, recipient, and the action to preform.
	
## getAccessandSecret.ps1
Prompts you to login to Mimecast and generates the access and secret keys necessary to have other scripts work autonomously.
	
## searchGroups.ps1
Will search for a group with the supplied value in its name and return information on it.  Without return output this is fairly useless in powershell.
	
# Python Scripts(Linux)
The pythons scripts where written in Linux.  The only thing that would stop them from working in Windows is some hard coded directory paths.
The python scripts will return input in a readable format, unlike Powershell.

## mimecast-AddGroupMember.py
Will add member to a specified group.  Must supply an email or domain and then a Group ID.  The Group ID can be found by searching for a child of the group in question.  The group ID is the parent ID returned from the group search.
	
## mimecast-GroupSearch.py
Will search for a group with the supplied value in its name and return information on it.

<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.179
	 Created on:   	9/22/2020 5:35 PM
	 Created by:   	andrew.fermier
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#pull my encrypted password and log into azure with it
$password = Get-Content C:\Passwords\password.txt | ConvertTo-SecureString -Key (Get-Content C:\Passwords\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("andrew.fermier@fairwaymc.com", $password)
Connect-AzureAD -Credential $credential

#get the total machines in phase 1 and 2
$devicelist = Get-AzureADDevice -top 900
#set machiens for phase 2
$firstgroup = 300
#set the groups for phase 1 and phase 2
$Phase1GroupID = ""
$Phase2GroupID = ""

<#
#This stuff didnt work right doing it this way but i don't wanna delete it yet don't judge me
$phase1 = @{}
$phase2 = @{}


for ($x = 0; $x -lt $devicelist.count; $x++)
{
	if ($x -lt $firstgroup)
	{
		$phase1[$x] = $devicelist[$x].objectid
	}
	if ($x -ge $firstgroup)
	{
		$phase2[$x] = $devicelist[$x].objectID
	}
	
}

$phase1 | ForEach { add-azureadgroupmember -ObjectID "" -RefObjectID $_.value}
$phase2 | ForEach { add-azureadgroupmember -ObjectID "" -RefObjectID $_.value}
#end of weird stuff i don't wanna delete yet
#>

#go through the pulled devices and assign them to groups
for ($x = 0; $x -lt $devicelist.count; $x++)
{
	#put them in group 1 until it meets its quota
	if ($x -lt $firstgroup)
	{
		add-azureadgroupmember -ObjectID $Phase1GroupID -RefObjectID $devicelist[$x].objectID
	}
	#put the rest in group 2
	if ($x -ge $firstgroup)
	{
		add-azureadgroupmember -ObjectID $Phase2GroupID -RefObjectID $devicelist[$x].objectID
	}
	
}
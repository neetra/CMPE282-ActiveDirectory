# This Script populate active directory from user in CSV file : Bulk Import

$path = $PSScriptRoot + "/employees.csv"
$userObjects = import-csv -Path $path
$currentUserCount  =(Get-ADUser -Filter * -SearchBase "OU=Users,OU=ronins,DC=ronins,DC=com").count
$passwordString  = ConvertTo-SecureString "Temp@1234" -AsPlainText -Force
Write-Output "Current number of Users Are "+ $currentUserCount  
for ($i=0;$i -lt $userObjects.Count;$i++){
	$userObject =  $userObjects[$i]
	$department = $userObject.Department.Trim()
	# This is user identity
	$userName = ($userObject.FirstName + "." + $userObject.LastName).Trim()
	$msg  =  $i.ToString() + ") Creating user "  + $userName
	Write-Output $msg
	New-ADUser $userName -GivenName $userObject.FirstName -Surname $userObject.LastName -Department $department -AccountPassword $passwordString -Enabled $true
}
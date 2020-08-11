$Users = Import-Csv C:\temp\input.csv
foreach($user in $Users) 
{
    Write-Host "Setting Home Folder for  ->" $user
    $userid = $user.username
    $fullPath = "\\mem1\HomeShare01\$userid"
    Set-ADUser -Identity $user.username -HomeDirectory $fullpath -HomeDrive "U:"
    $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop

    $acl = Get-Acl $homeShare
 
    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
    $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
 
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($userid, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
    $acl.AddAccessRule($AccessRule)
 
    Set-Acl -Path $homeShare -AclObject $acl -ea Stop
 
    Write-Host "HomeDirectory created for $userid at  $fullPath"

}
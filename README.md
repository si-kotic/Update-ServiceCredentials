# Update-ServiceCredentials
This function will update the user credentials under which a service runs.  The most useful reason for this script is that it allows you to perform the same action against list of remote servers, which I will cover in this documentation.

## Usage
### Parameters
#### ServiceName
Specify the name of the service for which you wish to update the 'Log on' credentials.

Argument | Value
--- | ---
Type | String
Position | Named
Default value | None
Accept pipeline input | False
Accept wildcard characters | False
Mandatory | True
#### Username
Specify the Username under which you wish the service to run.  If you omit this parameter then you can update the password without changing the user.

Regex Validation is performed on this parameter and it only accepts usernames in the format `username@domain.local` or `user.name@domain.local`.

Argument | Value
--- | ---
Type | String
Position | Named
Default value | None
Accept pipeline input | False
Accept wildcard characters | False
Mandatory | True
#### Password
This is a hidden parameter, but also mandatory.  You are unable to supply the parameter in the command but, when you run the command, you will be prompted to provide the password.  The value you type will be masked.

Argument | Value
--- | ---
Type | String
Position | Hidden
Default value | None
Accept pipeline input | False
Accept wildcard characters | False
Mandatory | True
#### ComputerName
An optional parameter which specifies the remote computer on which the service you wish to configure is running.  This allows you to execute the command against a remote server or, more powerfully, many remote servers (see Example section below).

Argument | Value
--- | ---
Type | String
Position | Named
Default value | None
Accept pipeline input | False
Accept wildcard characters | False
Mandatory | True
### Syntax
```powershell
Update-ServiceCredentials -ServiceName PRTGProbeService
```
```powershell
Update-ServiceCredentials -ServiceName PRTGProbeService -username "prtg.service@domain.local"
```
```powershell
Update-ServiceCredentials -ServiceName PRTGProbeService -ComputerName "PrtgServer"
```
### Example
```
C:\>Update-ServiceCredentials -ServiceName PRTGProbeService
Supply values for the following parameters:
Password: *******

Name             StartMode State   Status PSComputerName
----             --------- -----   ------ --------------
PRTGProbeService Automatic Running OK     PrtgServer
```
```
$prtgProbes = "Server1","Server2","Server3","Server4"
$prtgProbes | Foreach-Object {
    Update-ServiceCredentials -ServiceName PRTGProbeService -ComputerName $_
}
Supply values for the following parameters:
Password: *******

Name             StartMode State   Status PSComputerName
----             --------- -----   ------ --------------
PRTGProbeService Automatic Running OK     Server1

Get-Service : Cannot find any service with service name 'PRTGProbeService'.
At line:10 char:13
+         IF (Get-Service $ServiceName) {
+             ~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (PRTGProbeService:String) [Get-Service], ServiceCommandException
    + FullyQualifiedErrorId : NoServiceFoundForGivenName,Microsoft.PowerShell.Commands.GetServiceCommand

Name             StartMode State   Status PSComputerName
----             --------- -----   ------ --------------
PRTGProbeService Automatic Running OK     Server3

Name             StartMode State   Status PSComputerName
----             --------- -----   ------ --------------
PRTGProbeService Automatic Running OK     Server4
```
```
C:\>Update-ServiceCredentials -ServiceName "PRTGProbeService" -WhatIf

cmdlet Update-ServiceCredentials at command pipeline position 1
Supply values for the following parameters:
Password: ******
What if: Performing the operation "Update-ServiceCredentials" on target "PRTGProbeService".
```
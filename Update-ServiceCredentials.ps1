Function Update-ServiceCredentials {
    <#
    .LINK
    https://github.com/si-kotic/Update-ServiceCredentials
    #>
    Param (
    [Parameter(Mandatory)][String]$ServiceName,
    [ValidateScript({$_ -match "[\w\.]+@[\w\.]+"})][String]$Username, # Validate against regex for User@Domain.  Can we validate username?
    [Parameter(Mandatory,DontShow)][SecureString]$Password,
    $ComputerName
    )
    $UnsecurePassword = (New-Object PSCredential "user",$Password).GetNetworkCredential().Password
    Function UpServCred {
        IF (Get-Service $ServiceName) {
            $service = Get-WmiObject -Class Win32_Service -Filter "name='$ServiceName'"
            $updateResult = $service.change($null,$null,$null,$null,$null,$null,$Username,$UnsecurePassword) # If ReturnValue is 0 then success!
            IF ($updateResult.ReturnValue -eq 0) {
                Write-Verbose -Message "CREDENTIALS SUCCESSFULL UPDATED"
                Write-Verbose -Message "RESTARTING SERVICE: $ServiceName"
                Restart-Service $ServiceName
            } ELSE {
                Write-Verbose -Message "FAILED TO UPDATE CREDENTIALS"
                Break;
            }
            $service = Get-WmiObject -Class Win32_Service -Filter "name='$ServiceName'"
            $service | Format-Table Name,StartMode,State,Status,PSComputerName
        }
    }
    IF ($ComputerName) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            UpServCred
        }
    } ELSE {
        UpServCred
    }
}
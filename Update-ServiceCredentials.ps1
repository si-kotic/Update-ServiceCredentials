$prtgProbes = "Server1","Server2","Server3"
Update-ServiceCredentials {
    Param (
        $ServiceName,
        $Username, # Validate against regex for User@Domain.  Can we validate username?
        $Password, # Make SecureString and Hidden
        $ComputerName
    )
    $prtgProbes | Foreach-Object {
        Invoke-Command -ComputerName $_ -ScriptBlock {
            $service = Get-WmiObject -Class Win32_Service -Filter "name='PRTGProbeService'"
            $service.change($null,$null,$null,$null,$null,$null,$null,"lost-wmcXPQs") # If ReturnValue is 0 then success!
            Restart-Service PRTGProbeService
            $service = Get-WmiObject -Class Win32_Service -Filter "name='PRTGProbeService'"
            $service | Format-Table Name,StartMode,State,Status,PSComputerName
        }
    }
}
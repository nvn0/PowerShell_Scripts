$lolbas_api_url = "https://lolbas-project.github.io/api/lolbas.json"
$lolbas_data = Invoke-RestMethod $lolbas_api_url

Foreach ($entry in $lolbas_data.PSObject.Properties.Value){
    $name = $entry.name
    #Write-Host $entry
    if($entry.Full_Path) {
        foreach ($path in $entry.Full_Path){
            if (Test-Path $path.Path -ErrorAction SilentContinue){
                $pathToBlock[$path.Path] = $name
                }
            }
           #Write-Host $path.path
        }
}

$jobs = @()
$masConcurrentJobs = 15

foreach ($kvp in $pathToBlock.GetEnumerator(){
    While ( @(Get-Job -State Running).Count -ge $masConcurrentJobs){
        Start Sleep 1
    }

    $path = $kvp.Key
    $name = $kvp.Value
    $displayName = "Block LOL BINS - $name"

    $jobs += Start-Job -ScriptBlock{
        param($displayName, $path)

        $exists = Get-NetFirewallRule -DisplayName $displayName -ErrorAction SilentlyContinue

        if (-not $exists){
            New-NetFirewallRule -DisplayName $displayName `
                                -Direction Outbound `
                                -Action Block `
                                -Program $path `
                                -Profile Any `
                                -Enabled True
            Write-Host "[+] Blocker $path"
                
        }else{
            Write-Host "[-] Already exists: $path"
        }
    } -ArgumentList $displayName
}

Write-Host "[+] Waiting for all jobs to run.."
$jobs | Wait-Job | Out-Null

$jobs | Receive-Job
$jobs | Remove-Job

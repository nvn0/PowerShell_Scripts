$lolbas_api_url = "https://lolbas-project.github.io/api/lolbas.json"
$lolbas_data = Invoke-RestMethod $lolbas_api_url

Foreach ($entry in $lolbas_data.PSObject.Properties.Value){
    $name = $entry.name
    #Write-Host $entry
    if($entry.Full_Path) {
        foreach ($path in $entry.Full_Path){
            if (Test-Path $path.Path -ErrorAction SilentlyContinue){
                #$displayName = "Block LOLBAS - $name"
                #Write-Host $displayName
                Write-Host $path.path
            }
           
        }
    }
}
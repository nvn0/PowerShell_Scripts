Clear-Host
Write-Host "=== Escolher Servidor DNS ===`n"
Write-Host "1) Quad9"
Write-Host "2) Cloudflare"
Write-Host "3) DNS0 ZERO"
Write-Host "4) Next DNS"
Write-Host "5) Automático (DHCP)`n"

$opcao = Read-Host "Escolhe uma opção (1-4)"


switch ($opcao) {
    "1" { $dns = "9.9.9.9","149.112.112.112" }
    "2" { $dns = "1.1.1.1","1.0.0.1" }
    "3" { $dns = "193.110.81.9","185.253.5.9" }
    "4" { $dns = "45.90.28.167","45.90.30.167" }
    "5" { 
        Set-DnsClientServerAddress -InterfaceAlias $adaptador -ResetServerAddresses
        Write-Host "DNS reposto para automático (DHCP) no adaptador $adaptador"
        exit
    }
    default { Write-Host "Opção inválida"; exit }
}


Write-Host "=== Escolher o adaptador ===`n"
Write-Host "1) Ethernet"
Write-Host "2) Wi-Fi"

$opc = Read-Host "Nome do adaptador (1-2)"

switch ($opc) {
    "1" { $adaptador = "Ethernet" }
    "2" { $adaptador = "Wi-Fi" }
    
    default { Write-Host "Opção inválida"; exit }
}



Set-DnsClientServerAddress -InterfaceAlias $adaptador -ServerAddresses $dns
Write-Host "DNS configurado para $dns no adaptador $adaptador"

Clear-DnsClientCache

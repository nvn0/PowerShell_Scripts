# Verificar se o script está sendo executado com privilégios de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Este script precisa ser executado com privilégios de administrador."
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}


# Listar todas as interfaces de rede
#Get-NetAdapter | Format-Table -Property Name, InterfaceDescription, Status


Get-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6


# Nome da interface de rede onde o IPv6 será desativado
$interfaceName = "Ethernet"

# Verificar o estado atual do IPv6 na interface de rede
$binding = Get-NetAdapterBinding -Name $interfaceName -ComponentID ms_tcpip6


if ($binding.Enabled) {
    # Se o IPv6 estiver ativado, desativa-o
    Disable-NetAdapterBinding -Name $interfaceName -ComponentID ms_tcpip6
    Write-Output "IPv6 foi desativado na interface $interfaceName."
	
} else {
    # Se o IPv6 estiver desativado, ativa-o
    Enable-NetAdapterBinding -Name $interfaceName -ComponentID ms_tcpip6
    Write-Output "IPv6 foi ativado na interface $interfaceName."
}






# Ativar o IPv6 em uma interface de rede
#Enable-NetAdapterBinding -Name $interfaceName -ComponentID ms_tcpip6


# Desativar o IPv6 na interface de rede especificada
#Disable-NetAdapterBinding -Name $interfaceName -ComponentID ms_tcpip6


Get-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6







#Para desativar
$listaDeServicos= @("LGHUBUpdaterService", "ClickToRunSvc", "SSDPSRV", "upnphost")



#Para por em manual
$listaDeServicos2= @("LGHUBUpdaterService", "ClickToRunSvc", "SSDPSRV", "upnphost")


# Nome do serviço
#$serviceName = "Spooler"

# Parar o serviço
#Stop-Service -Name $serviceName

# Definir tipo de inicialização para manual
#Set-Service -Name $serviceName -StartupType Manual

# Verificar o status do serviço e o tipo de inicialização
#Get-Service -Name $serviceName | Select-Object Name, Status, StartType


########################################################################################


function Desativar {
	
	# Desativar
	foreach ($servico in $listaDeServicos) {
		Stop-Service -Name $servico
		Set-Service -Name $servico -StartupType Disabled
		
	}
}


function PorManual {

	# Por em Manual
	foreach ($servico in $listaDeServicos2) {
		Stop-Service -Name $servico
		Set-Service -Name $servico -StartupType Manual
		
	}
}

Desativar
#PorManual








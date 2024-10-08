

#Para desativar
$listaDeServicos= @("LGHUBUpdaterService", "ClickToRunSvc", "SSDPSRV", "upnphost", "DiagTrack", "shpamsvc", "RemoteRegistry", "Fax")



#Para por em manual
$listaDeServicos2= @("LGHUBUpdaterService", "ClickToRunSvc", "SSDPSRV")


# Lista de pacotes a serem verificados e removidos
$appsToRemove = @(
    "Candy Crush Saga",
    "Candy Crush Soda Saga",
    "FarmVille 2: Country Escape",
    "Microsoft Solitaire Collection",
    "March of Empires",
    "Asphalt 8: Airborne",
    "Disney Magic Kingdoms",
    "Bubble Witch 3 Saga",
    "Microsoft News",
    "Skype",
    "Instagram",
    "TikTok",
    "Mixed Reality Portal",
	"Microsoft.XboxApp"
)



# others that you may want to add to the list: "Roblox", "3D Viewer", "Paint 3D"

# Nome do serviço
#$serviceName = "Spooler"

# Parar o serviço
#Stop-Service -Name $serviceName

# Definir tipo de inicialização para manual
#Set-Service -Name $serviceName -StartupType Manual

# Verificar o status do serviço e o tipo de inicialização
#Get-Service -Name $serviceName | Select-Object Name, Status, StartType


##################################### Servicos ###################################################


function Desativar {
	
	Write-Host "A desativar servicos inuteis"
	
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


################## Resgistry ##################



function desativar_reg {
	
	# Desabilitar a coleta de dados de diagnóstico e feedback
	Write-Host "A desativar coleta de dados de diagnóstico e feedback..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0


	Write-Host "A desativar a Cortana..."
    # Desativar a Cortana via registro
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
	
	# Finalizar o processo da Cortana (caso esteja em execução)
    $cortanaProcess = Get-Process -Name "SearchUI" -ErrorAction SilentlyContinue
    if ($cortanaProcess) {
        Write-Host "Finalizando o processo da Cortana..."
        Stop-Process -Name "SearchUI" -Force
    } else {
        Write-Host "Cortana não está em execução."
    }
	
	
}

function Disable-FastStartup {
    Write-Host "Desativando o Fast Startup..."

    # Desabilita o Fast Startup via registro
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0

    Write-Host "Fast Startup foi desativado com sucesso."
}




#########################################################

############## Uninstall programs and games ############

# Função para verificar e remover os pacotes
function desinstalar_bloat {
	
	foreach ($app in $appsToRemove) {
		$package = Get-AppxPackage | Where-Object { $_.Name -like "*$app*" }

		if ($package) {
			Write-Host "Removendo $app..."
			Remove-AppxPackage -Package $package.PackageFullName
		} else {
			Write-Host "$app não está instalado."
		}
	}

	Write-Host "Verificação e remoção concluída."
}


# Script para desinstalar programs com winget
function desinstalar_bloat_winget {
	if (Get-Command winget -ErrorAction SilentlyContinue) {
		
		Write-Host "Desinstalando o OneDrive..."
		winget uninstall Microsoft.OneDrive
		Write-Host "OneDrive desinstalado com sucesso."
		
		
	} else {
		Write-Host "O winget não está disponível no sistema."
	}
}
#########################################################










# chamar funções
desinstalar_bloat


Desativar
#PorManual


desativar_reg

Disable-FastStartup






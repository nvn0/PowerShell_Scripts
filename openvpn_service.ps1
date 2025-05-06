
$serviceName1 = "agent_ovpnconnect"
$serviceName2 = "ovpnhelper_service"


# Obtém o status do servico.
$service1 = Get-Service -Name $serviceName1 -ErrorAction SilentlyContinue

if ($null -eq $service1) {
    Write-Host "O servico $serviceName1 nao foi encontrado. Verifique se o nome esta correto."
    exit
}

if ($service1.Status -eq 'Running') {
    #Write-Host "O servico $serviceName1 já esta em execucao. Parando o servico..."
    try {
        Stop-Service -Name $serviceName1 -Force -ErrorAction Stop
        Write-Host "O servico $serviceName1 foi parado com sucesso."
    } catch {
        Write-Host "Falha ao parar o servico $serviceName. Erro: $($_.Exception.Message)"
    }
} else {
    #Write-Host "O servico $serviceName1 nao esta em execucao. Iniciando o servico..."
    try {
        Start-Service -Name $serviceName1 -ErrorAction Stop
        Write-Host "O servico $serviceName1 foi iniciado com sucesso."
    } catch {
        Write-Host "Falha ao iniciar o servico $serviceName1. Erro: $($_.Exception.Message)"
    }
}



# Obtém o status do servico.
$service2 = Get-Service -Name $serviceName2 -ErrorAction SilentlyContinue

if ($null -eq $service2) {
    Write-Host "O servico $serviceName2 nao foi encontrado. Verifique se o nome esta correto."
    exit
}

if ($service2.Status -eq 'Running') {
    #Write-Host "O servico $serviceName2 já esta em execucao. Parando o servico..."
    try {
        Stop-Service -Name $serviceName2 -Force -ErrorAction Stop
        Write-Host "O servico $serviceName2 foi parado com sucesso."
    } catch {
        Write-Host "Falha ao parar o servico $serviceName. Erro: $($_.Exception.Message)"
    }
} else {
    #Write-Host "O servico $serviceName2 nao esta em execucao. Iniciando o servico..."
    try {
        Start-Service -Name $serviceName2 -ErrorAction Stop
        Write-Host "O servico $serviceName2 foi iniciado com sucesso."
    } catch {
        Write-Host "Falha ao iniciar o servico $serviceName2. Erro: $($_.Exception.Message)"
    }
}





Pause

# Define uma ação a ser tomada quando um novo processo for criado
$action = {
    $process = $event.SourceEventArgs.NewEvent
    Write-Host "Novo processo criado:"
    Write-Host "Nome do Processo: $($process.TargetInstance.Name)"
    Write-Host "ID do Processo: $($process.TargetInstance.ProcessId)"
    Write-Host "User: $($process.TargetInstance.UserName)"
    Write-Host "--------------------------"
}

# Configura a consulta WMI para monitorar a criação de novos processos
$query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"

# Registra o evento
Register-WmiEvent -Query $query -SourceIdentifier "ProcessCreationWatcher" -Action $action

# Mantém o script em execução para que ele continue monitorando os processos
Write-Host "Monitorando a criação de novos processos. Pressione Ctrl+C para sair."
while ($true) {
    Start-Sleep -Seconds 5
}

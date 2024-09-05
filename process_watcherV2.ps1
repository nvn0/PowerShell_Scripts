# Define a lista de processos não permitidos
$processosNaoPermitidos = @("notepad", 'notepad', "notepad.exe", 'notepad.exe', "calc", "KeePassXC.exe")

# Define uma ação a ser tomada quando um novo processo for criado
$action = {
    $process = $event.SourceEventArgs.NewEvent
    $nomeProcesso = $process.TargetInstance.Name

    # Log para depuração: mostrar o nome completo do processo detectado
    Write-Host "Evento detectado: $nomeProcesso"


    # Verifica se o nome do processo está na lista de processos não permitidos
    if ($processosNaoPermitidos -contains $nomeProcesso) {
        Write-Host "Processo não permitido detectado: $nomeProcesso. Tentando parar o processo..."
        try {
            Stop-Process -Name $nomeProcesso -Force
            Write-Host "Processo $nomeProcesso parado com sucesso."
        } catch {
            Write-Host "Falha ao parar o processo $nomeProcesso. Erro: $_"
        }
    } else {
        Write-Host -ForegroundColor Green "Processo permitido detectado: $nomeProcesso."
    }
}

# Identificador de fonte para o evento
$sourceIdentifier = "ProcessCreationWatcher"

# Remove o evento existente se já estiver registrado
if (Get-EventSubscriber -SourceIdentifier $sourceIdentifier -ErrorAction SilentlyContinue) {
    Unregister-Event -SourceIdentifier $sourceIdentifier
}

# Configura a consulta WMI para monitorar a criação de novos processos
$query = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process'"

# Registra o evento
Register-WmiEvent -Query $query -SourceIdentifier $sourceIdentifier -Action $action

# Mensagem indicando que o monitoramento está ativo
Write-Host "Monitorando a criação de novos processos. Pressione Ctrl+C para sair."

# Loop infinito para manter o script ativo
while ($true) {
    Start-Sleep -Seconds 5
}

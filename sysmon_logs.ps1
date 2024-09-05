param (
    [int]$MaxLogs = 10  # Número máximo de logs a serem exibidos
)

# Definir o caminho para o log do Sysmon
$logName = 'Microsoft-Windows-Sysmon/Operational'

Write-Host "Iniciando a exibição do log '$logName'."

# Verificar se o log existe
try {
    $log = Get-WinEvent -ListLog $logName -ErrorAction Stop
    if (-not $log) {
        Write-Error "O log '$logName' não foi encontrado. Verifique se o Sysmon está instalado e configurado."
        exit
    }
} catch {
    Write-Error "Erro ao verificar o log: $_"
    exit
}

# Obter eventos do log do Sysmon com limite
try {
    $events = Get-WinEvent -LogName $logName -MaxEvents $MaxLogs -ErrorAction Stop
    Write-Host "Total de eventos obtidos: $($events.Count)"
    
    # Exibir eventos
    Write-Host "Mostrando eventos obtidos (limitado a $MaxLogs):"
    foreach ($event in $events) {
        $timeCreated = $event.TimeCreated
        $id = $event.Id
        $message = if ($event.Message.Length -gt 1000) { $event.Message.Substring(0, 1000) } else { $event.Message }
        
        [PSCustomObject]@{
            TimeCreated = $timeCreated
            Id = $id
            Message = $message
        } | Format-Table -AutoSize
    }
} catch {
    Write-Error "Erro ao processar eventos: $_"
}

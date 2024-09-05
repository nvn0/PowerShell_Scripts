# Definir o caminho do log do Sysmon
$logName = "Microsoft-Windows-Sysmon/Operational"

# Definir a quantidade de eventos que você quer buscar (opcional)
$eventLimit = 100

# Buscar os eventos do Sysmon
$sysmonEvents = Get-WinEvent -LogName $logName -MaxEvents $eventLimit

# Exibir as informações de cada evento
foreach ($event in $sysmonEvents) {
    Write-Output "ID do Evento: $($event.Id)"
    Write-Output "Hora: $($event.TimeCreated)"
    Write-Output "Fonte: $($event.ProviderName)"
    Write-Output "Mensagem: $($event.Message)"
    Write-Output "--------------------------------------------"
}

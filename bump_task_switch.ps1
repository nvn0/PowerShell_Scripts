# Nome da tarefa (ajusta conforme necessário)
$taskPath = "\"
$taskName = "bump no server"

# Obter tarefa
$task = Get-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction Stop

# Verificar estado
if ($task.State -eq 'Ready' -or $task.State -eq 'Running') {
    Write-Host "A tarefa esta activa. Sera desactivada..."
    Disable-ScheduledTask -TaskName $taskName -TaskPath $taskPath
    Write-Host -ForegroundColor Red "Tarefa desactivada com sucesso."
}
elseif ($task.State -eq 'Disabled') {
    Write-Host "A tarefa esta desactivada. Sera activada..."
    Enable-ScheduledTask -TaskName $taskName -TaskPath $taskPath
    Write-Host -ForegroundColor Green "Tarefa activada com sucesso."
}
else {
    Write-Host "Estado da tarefa desconhecido ou nao aplicavel: $($task.State)"
}

Pause
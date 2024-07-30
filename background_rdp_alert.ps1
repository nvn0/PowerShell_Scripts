# Função para verificar eventos e enviar notificações
function Check-LogonEvents {
    while ($true) {
        # Obter logs de eventos de segurança a partir do início do dia atual
        $events = Get-EventLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0) | 
            Where-Object { (4624, 4778) -contains $_.EventID -and $_.Message -match 'logon type:\s+(10|3)\s' } | 
            ForEach-Object {
                [PSCustomObject]@{
                    TimeGenerated = $_.TimeGenerated
                    ClientIP      = ($_ | Select-String -Pattern 'Source Network Address:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                    UserName      = ($_ | Select-String -Pattern '\sAccount Name:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                    UserDomain    = ($_ | Select-String -Pattern '\sAccount Domain:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                    LogonType     = ($_ | Select-String -Pattern 'Logon Type:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                }
            }

        # Verificar se existem eventos
        if ($events) {
            # Separar eventos por tipo de logon
            $logonType10 = $events | Where-Object { $_.LogonType -eq '10' }
            $logonType3  = $events | Where-Object { $_.LogonType -eq '3' }

            # Função para enviar notificações
            function Send-Notification {
                param ($events, $logonTypeDescription)
                if ($events) {
                    foreach ($event in $events) {
                        $message = "Logon type $logonTypeDescription detected.`nTime: $($event.TimeGenerated)`nUser: $($event.UserDomain)\$($event.UserName)`nIP: $($event.ClientIP)"
                        # Usar Write-Host para notificação simples
                        Write-Host "Logon Alert: $message"
                        # Alternativamente, registrar no log de eventos do Windows
                        # Write-EventLog -LogName Application -Source "LogonChecker" -EventId 1000 -EntryType Information -Message $message
                    }
                }
            }

            # Enviar notificações para eventos por tipo de logon
            Send-Notification $logonType10 '10 (RDP)'
            Send-Notification $logonType3 '3 (Network connection to shared folder)'
        }

        # Esperar por um intervalo antes de verificar novamente (15 minutos)
        Start-Sleep -Seconds 900
    }
}

# Executar a função em segundo plano
Start-Job -ScriptBlock {
    function Check-LogonEvents {
        while ($true) {
            # Obter logs de eventos de segurança a partir do início do dia atual
            $events = Get-EventLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0) | 
                Where-Object { (4624, 4778) -contains $_.EventID -and $_.Message -match 'logon type:\s+(10|3)\s' } | 
                ForEach-Object {
                    [PSCustomObject]@{
                        TimeGenerated = $_.TimeGenerated
                        ClientIP      = ($_ | Select-String -Pattern 'Source Network Address:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                        UserName      = ($_ | Select-String -Pattern '\sAccount Name:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                        UserDomain    = ($_ | Select-String -Pattern '\sAccount Domain:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                        LogonType     = ($_ | Select-String -Pattern 'Logon Type:\s+([^\s]+)\s+' -AllMatches).Matches[0].Groups[1].Value
                    }
                }

            # Verificar se existem eventos
            if ($events) {
                # Separar eventos por tipo de logon
                $logonType10 = $events | Where-Object { $_.LogonType -eq '10' }
                $logonType3  = $events | Where-Object { $_.LogonType -eq '3' }

                # Função para enviar notificações
                function Send-Notification {
                    param ($events, $logonTypeDescription)
                    if ($events) {
                        foreach ($event in $events) {
                            $message = "Logon type $logonTypeDescription detected.`nTime: $($event.TimeGenerated)`nUser: $($event.UserDomain)\$($event.UserName)`nIP: $($event.ClientIP)"
                            # Usar Write-Host para notificação simples
                            Write-Host "Logon Alert: $message"
                            # Alternativamente, registrar no log de eventos do Windows
                            # Write-EventLog -LogName Application -Source "LogonChecker" -EventId 1000 -EntryType Information -Message $message
                        }
                    }
                }

                # Enviar notificações para eventos por tipo de logon
                Send-Notification $logonType10 '10 (RDP)'
                Send-Notification $logonType3 '3 (Network connection to shared folder)'
            }

            # Esperar por um intervalo antes de verificar novamente (15 minutos)
            Start-Sleep -Seconds 900
        }
    }
    Check-LogonEvents
}



#Get-EventLog security | 
#    Where-Object {
#        $_.eventid -eq 4624 -and 
#        ($_.Message -match 'logon type:\s+(10)\s' -or $_.Message -match 'logon type:\s+(3)\s' -or $_.Message -match 'logon type:\s+(5)\s')
#    } | 
#    Out-GridView


#Get-EventLog security | 
#    Where-Object {
#        $_.eventid -eq 4624 -and 
#        $_.Message -match 'logon type:\s+(10|3|5|7)\s'
#    } | 
#    Format-Table -Property TimeGenerated, EventID, InstanceId, EntryType, Source, Message -AutoSize




#Get-WinEvent -FilterXml $filterXML | 
#   Format-Table -Property TimeCreated, Id, ProviderName, Message -AutoSize

#Get-EventLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0)| ?{(4624,4778) -contains $_.EventID -and $_.Message -match 'logon type:\s+(10)\s'}| %{
#(new-object -Type PSObject -Property @{
#TimeGenerated = $_.TimeGenerated
#ClientIP = $_.Message -replace '(?smi).*Source Network Address:\s+([^\s]+)\s+.*','$1'
#UserName = $_.Message -replace '(?smi).*\s\sAccount Name:\s+([^\s]+)\s+.*','$1'
#UserDomain = $_.Message -replace '(?smi).*\s\sAccount Domain:\s+([^\s]+)\s+.*','$1'
#LogonType = $_.Message -replace '(?smi).*Logon Type:\s+([^\s]+)\s+.*','$1'
#})
#} | sort TimeGenerated -Descending | Select TimeGenerated, ClientIP `
#, @{N='Username';E={'{0}\{1}' -f $_.UserDomain,$_.UserName}} `
#, @{N='LogType';E={
#switch ($_.LogonType) {
#2 {'Interactive - local logon'}
#3 {'Network connection to shared folder)'}
#4 {'Batch'}
#5 {'Service'}
#7 {'Unlock (after screensaver)'}
#8 {'NetworkCleartext'}
#9 {'NewCredentials (local impersonation process under existing connection)'}
#10 {'RDP'}
#11 {'CachedInteractive'}
#default {"LogType Not Recognised: $($_.LogonType)"}
#}
#}}





## Obter logs de eventos de segurança a partir do início do dia atual
#$events = Get-EventLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0) | 
#    ?{ (4624, 4778) -contains $_.EventID -and $_.Message -match 'logon type:\s+(10|3|5|7)\s' } | 
#    %{
#        new-object -Type PSObject -Property @{
#            TimeGenerated = $_.TimeGenerated
#            ClientIP = $_.Message -replace '(?smi).*Source Network Address:\s+([^\s]+)\s+.*','$1'
#            UserName = $_.Message -replace '(?smi).*\s\sAccount Name:\s+([^\s]+)\s+.*','$1'
#            UserDomain = $_.Message -replace '(?smi).*\s\sAccount Domain:\s+([^\s]+)\s+.*','$1'
#            LogonType = $_.Message -replace '(?smi).*Logon Type:\s+([^\s]+)\s+.*','$1'
#        }
#    }
#
## Verificar se existem eventos
#if ($events) {
#    # Ordenar e selecionar as propriedades desejadas
#    $events | sort TimeGenerated -Descending | 
#        Select TimeGenerated, ClientIP,
#        @{N='Username';E={'{0}\{1}' -f $_.UserDomain,$_.UserName}},
#        @{N='LogType';E={
#            switch ($_.LogonType) {
#                2 {'Interactive - local logon'}
#                3 {'Network connection to shared folder'}
#                4 {'Batch'}
#                5 {'Service'}
#                7 {'Unlock (after screensaver)'}
#                8 {'NetworkCleartext'}
#                9 {'NewCredentials (local impersonation process under existing connection)'}
#                10 {'RDP'}
#                11 {'CachedInteractive'}
#                default {"LogType Not Recognised: $($_.LogonType)"}
#            }
#        }}
#} else {
#    Write-Host -ForegroundColor Green "Nenhum log de evento encontrado para os critérios especificados."
#}





# Obter logs de eventos de segurança a partir do início do dia atual
$events = Get-EventLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0) | 
    ?{ (4624, 4778) -contains $_.EventID -and $_.Message -match 'logon type:\s+(10|3|7|5)\s' } | 
    %{
        new-object -Type PSObject -Property @{
            TimeGenerated = $_.TimeGenerated
            ClientIP = $_.Message -replace '(?smi).*Source Network Address:\s+([^\s]+)\s+.*','$1'
            UserName = $_.Message -replace '(?smi).*\s\sAccount Name:\s+([^\s]+)\s+.*','$1'
            UserDomain = $_.Message -replace '(?smi).*\s\sAccount Domain:\s+([^\s]+)\s+.*','$1'
            LogonType = $_.Message -replace '(?smi).*Logon Type:\s+([^\s]+)\s+.*','$1'
        }
    }

# Verificar se existem eventos
if ($events) {
    # Separar eventos por tipo de logon
    $logonType10 = $events | ? { $_.LogonType -eq '10' }
    $logonType3 = $events | ? { $_.LogonType -eq '3' }
    $logonType7 = $events | ? { $_.LogonType -eq '7' }
    $logonType5 = $events | ? { $_.LogonType -eq '5' }

    # Função para exibir eventos
    function Show-Events ($events, $logonTypeDescription) {
        if ($events) {
            Write-Output "Eventos de logon tipo ${logonTypeDescription}:"
            $events | sort TimeGenerated -Descending | 
                Select TimeGenerated, ClientIP,
                @{N='Username';E={'{0}\{1}' -f $_.UserDomain,$_.UserName}},
                @{N='LogType';E={
                    switch ($_.LogonType) {
                        2 {'Interactive - local logon'}
                        3 {'Network connection to shared folder'}
                        4 {'Batch'}
                        5 {'Service'}
                        7 {'Unlock (after screensaver)'}
                        8 {'NetworkCleartext'}
                        9 {'NewCredentials (local impersonation process under existing connection)'}
                        10 {'RDP'}
                        11 {'CachedInteractive'}
                        default {"LogType Not Recognised: $($_.LogonType)"}
                    }
                }}
        } else {
            Write-Host -ForegroundColor Green "Nenhum evento de logon tipo ${logonTypeDescription} encontrado."
        }
    }

    # Exibir eventos por tipo de logon
    Show-Events $logonType10 '10 (RDP)'
    Show-Events $logonType3 '3 (Network connection)'
    Show-Events $logonType7 '7 (Unlock - reconnect)'
    Show-Events $logonType5 '5 (Service)'

} else {
    Write-Host -ForegroundColor Green "Nenhum log de evento encontrado para os critérios especificados."
}


















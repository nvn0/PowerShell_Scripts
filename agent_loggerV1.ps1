

#Definir a class de evento do sysmon
#class SysmonEvent {
#    [int]$Id
#    [datetime]$TimeCreated
#    [string]$ProviderName
#    [string]$Message
#
#    SysmonEvent([int]$id, [datetime]$timeCreated, [string]$providerName, [string]$message) {
#        $this.Id = $id
#        $this.TimeCreated = $timeCreated
#        $this.ProviderName = $providerName
#        $this.Message = $message
#    }
#}

# Loop infinito para buscar e enviar eventos a cada 15 segundos
while ($true) {
    try {

		#------------------------- Ler os Eventos -----------------------------------------------------------

		# Definir o caminho do log do Sysmon
		$logName = "Microsoft-Windows-Sysmon/Operational"

		# Definir a quantidade de eventos que você quer buscar
		$eventLimit = 50

		# Buscar os eventos do Sysmon
		$sysmonEvents = Get-WinEvent -LogName $logName -MaxEvents $eventLimit

		# Criar uma lista para armazenar os objetos SysmonEvent
		$eventObjects = @()
		
		# Preencher a lista com objetos personalizados
        foreach ($event in $sysmonEvents) {
            $entry = @{
                "Id"           = "$($event.Id)"
                "TimeCreated"  = "$($event.TimeCreated)"
                "ProviderName" = "$($event.ProviderName)"
                "Message"      = "$($event.Message)"
            } | ConvertTo-Json -Depth 3
            $eventObjects += New-Object -TypeName PSObject -Property $entry
        }




		#----------------------- Enviar via http POST ------------------------------------------- 

		# Definir a URL do endpoint para onde os dados serão enviados
		$uri = "http://127.0.0.1:5000/receberdados"

		# Converter os objetos SysmonEvent para JSON
		$jsonBody = $eventObjects

		# Definir os cabeçalhos da requisição
		$headers = @{
			"Content-Type" = "application/json"
			"Authorization" = "Bearer seu_token_aqui"
		}

		# Enviar os dados via HTTP POST
		$response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $jsonBody

		# Exibir a resposta do servidor
		$response.Content
		Write-Host "Dados enviados com sucesso. Resposta: $($response.StatusCode)"
		
		
		} catch {
				Write-Host "Erro ao enviar dados: $_"
		}
			
		# Limpar a lista de eventos após o envio
		$eventObjects = $null

		# Pausar a execução por 15 segundos antes da próxima iteração
		Start-Sleep -Seconds 15
}
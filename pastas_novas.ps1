
$WhiteList = @("C:\Users\$env:USERNAME\Info Tecnica\", "C:\Program Files\BraveSoftware")


# Data e hora para comparação (por exemplo, 23 de dezembro de 2023 às 10:00)
$dataHoraComparacao = Get-Date "2024-09-5T10:00:00"

Write-Host
write-Host "Data especificada:" $dataHoraComparacao
Write-Host




function Ver_pastas_novas {
	param (
		[string]$pasta_inicial,
		[bool]$justFolders
	)

	foreach ($item in $pasta_inicial) {
		if (Test-Path $item -PathType Container) {
			# Obtém a lista de arquivos na pasta
			$arquivos = Get-ChildItem -Path $item

			#Write-Host -ForegroundColor Yellow "Ficheiros na pasta" $item":"
			#Write-Host "Nome:                                Estado:"

			foreach ($arquivo in $arquivos) {
				# Verifica se é um ficheiro
				if (($arquivo.PSIsContainer -eq $false) -and ($justFolders -eq $false)) {
				   #$caminhoArquivo = $arquivo.FullName

					$dataCriacao = $arquivo.CreationTime
					

					if ($dataCriacao -gt $dataHoraComparacao) {
						$fstring = "{0}   ->   {1}" -f $arquivo.FullName, "Novo"
						Write-Host -ForegroundColor Red $fstring 
						
						
						
					}
				}
				if ($arquivo.PSIsContainer -eq $true) {
					#$arquivo.Name + " (Pasta)"
					
					$dataCriacao = $arquivo.CreationTime
					
					
					if ($dataCriacao -gt $dataHoraComparacao) {
						$fstring = "{0}   ->   {1}" -f $arquivo.FullName, "Novo"
						Write-Host -ForegroundColor Red $fstring 
						
					}
					
					foreach ($pasta in $WhiteList) {
						if (-not ($arquivo.FullName.Contains($pasta))) {
							Ver_pastas_novas -pasta_inicial $arquivo.FullName
						}
					}
				}
			}

			#Write-Host "------------------------"
		} else {
			Write-Host "A pasta" $pasta "não foi encontrada."
		}
	}
}


#$pasta_inicial = "C:\"
$pasta_inicial = "C:\Users\$env:USERNAME"


$justFolders = $true

Ver_pastas_novas -pasta_inicial $pasta_inicial -justFolders $justFolders



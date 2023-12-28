# Lista de pastas a serem verificadas
$listaDePastas = @("C:\Users\$env:USERNAME\AppData\Local\Temp", "C:\Windows\Temp")




foreach ($pasta in $listaDePastas) {
    if (Test-Path $pasta -PathType Container) {
        # Obtém a lista de arquivos na pasta
        $arquivos = Get-ChildItem -Path $pasta

        #Write-Host -ForegroundColor Yellow "Arquivos na pasta" $pasta":"
		

        foreach ($arquivo in $arquivos) {
            # Verifica se é um arquivo
            if ($arquivo.PSIsContainer -eq $false) {
				Try {
					
					Remove-Item -Path $arquivo.FullName
					
					$arquivo.Name + " Apagado"
					
				}
				Catch {
					Write-Host -ForegroundColor Yellow "Não foi possivel apagar " $arquivo.Name
				}

            }
			if ($arquivo.PSIsContainer -eq $true) {
				Try {
					Remove-Item -Path $arquivo.FullName -Recurse
					
					"Pasta " + $arquivo.Name + " Apagada"
					
				}
				Catch {
					Write-Host -ForegroundColor Yellow "Não foi possivel apagar a pasta " $arquivo.Name
				}
				
				
			}
        }

       
    } else {
        Write-Host "A pasta" $pasta "não foi encontrada."
    }
}









# Lista de pastas a serem verificadas
$listaDePastas = @("C:\Users\$env:USERNAME\meus docs\ficheiros html\listas", "C:\Users\$env:USERNAME\meus docs\ficheiros html", "C:\Users\$env:USERNAME\meus docs\meus scripts agendados")


# ficheiros independentes:
$file1_path = "C:\Users\$env:USERNAME\meus docs\varios dbs\varios\varios volume.txt"
$file1_hash = "2162e71bc74905aba208c8a5d26dec6df13faf21428df9f1485f4c06e67d0c6a"

# Data e hora para comparação (por exemplo, 23 de dezembro de 2023 às 10:00)
$dataHoraComparacao = Get-Date "2023-12-23T10:00:00"

Write-Host
write-Host "Data especificada:" $dataHoraComparacao
Write-Host

foreach ($pasta in $listaDePastas) {
    if (Test-Path $pasta -PathType Container) {
        # Obtém a lista de arquivos na pasta
        $arquivos = Get-ChildItem -Path $pasta

        Write-Host -ForegroundColor Yellow "Arquivos na pasta" $pasta":"
		#Write-Host "Nome:                                Estado:"

        foreach ($arquivo in $arquivos) {
            # Verifica se é um arquivo
            if ($arquivo.PSIsContainer -eq $false) {
               #$caminhoArquivo = $arquivo.FullName

                $dataModificacao = $arquivo.LastWriteTime

                if ($dataModificacao -gt $dataHoraComparacao) {
					$fstring = "{0}   ->     {1}" -f $arquivo.Name, "Modificado"
                    Write-Host -ForegroundColor Red $fstring 
                } else {
					$fstring = "{0}   ->     {1}" -f $arquivo.Name, "Inalterado"
                    Write-Host -ForegroundColor Green $fstring 
                }
            }
			if ($arquivo.PSIsContainer -eq $true) {
				$arquivo.Name + " (Pasta)"
			}
        }

        Write-Host "------------------------"
    } else {
        Write-Host "A pasta" $pasta "não foi encontrada."
    }
}


function verificar_hash {
	param (
		[string]$file_path,
		[string]$original_hash
	)


	Write-Host "Ficheiro:" $file_path

	write-Host -ForegroundColor Green "Hash Registada:" $original_hash

	$hashatual = Get-FileHash -Path $file_path -Algorithm SHA256


	if ($original_hash -eq $hashatual.Hash.ToLower()) 
	{
		Write-Host -ForegroundColor Green "Hash atual:    " $hashatual.Hash.ToLower()
		Write-Host
		Write-Host -ForegroundColor Green "São iguais, nao houve altercao do ficheiro."
	}
	else {
		Write-Host -ForegroundColor Red "Hash atual:    " $hashatual.Hash.ToLower()
		Write-Host
		Write-Host -ForegroundColor Red "São Diferentes, houve altercao do ficheiro."
	}
	Write-Host "---------------------------------------------------------------------------"
}

# chamar funções
Write-Host -ForegroundColor Yellow "Verificação de hash de ficheiros:"

verificar_hash -file_path $file1_path -original_hash $file1_hash






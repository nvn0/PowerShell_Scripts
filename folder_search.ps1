$listaDeDiretorios = @("C:\Users\$env:USERNAME\meus docs")

$listaPastasEncontradas = @()

$nome = Read-Host "Insira o nome da pasta que procura no diretorio(s) " $listaDeDiretorios[0]



foreach ($pasta in $listaDeDiretorios) {
    if (Test-Path $pasta -PathType Container) {
        # Obtém a lista de arquivos na pasta
        $pastas = Get-ChildItem -Path $pasta -Directory | Where-Object { $_.Name -match $nome}

        Write-Host -ForegroundColor Yellow "Pastas no diretorio" $pasta":"
		
		
		if ($pastas.Count -gt 0) {
			Write-Host -ForegroundColor Yellow "Pastas encontradas com a palavra-chave '$nome':"
			foreach ($pasta in $pastas) {
				Write-Host -ForegroundColor Green $pasta.FullName
				#$listaPastasEncontradas.Add($pasta.FullName)
				$listaPastasEncontradas += $pasta.FullName
				
			}
		} else {
			Write-Host "Nenhuma pasta encontrada com a palavra-chave '$nome'."
			Exit
		}
	}
}

$count = 0

#$listaPastasEncontradas

Write-Host "Escolha uma pasta:"

foreach ($pasta in $listaPastasEncontradas) {
	#$fstring = "{0}   -   {1}" -f $count + 1, $pasta
    #Write-Host $fstring 
	Write-Host "'$count' - '$pasta'"
	$count += 1
   
}

#Write-Host $listaPastasEncontradas.Length

do {
	$numero = Read-Host "Digite o numero "
	
	 if ($numero -lt 0 -or $numero -ge $listaPastasEncontradas.Length) {
        Write-Host "Entrada invalida. Por favor, insira um numero dentro do intervalo permitido."
    }
} while($numero -lt 0 -or $numero -ge $listaPastasEncontradas.Length)



Write-Host -ForegroundColor Green "Pasta selecionada:" $listaPastasEncontradas[$numero]


Write-Host "Opcoes:"
Write-Host "1 - Mover para outro diretorio"
Write-Host "2 - Copiar para outro diretorio"
Write-Host "3 - Apagar"


do {
	$opcao = Read-Host "Digite o numero "
	
	 if ($opcao -lt 1 -or $opcao -gt 3) {
        Write-Host "Entrada invalida. Por favor, insira um numero dentro do intervalo permitido."
    }
} while($opcao -lt 1 -or $opcao -gt 3)


switch ($opcao) {
    "1" {
        Write-Host -ForegroundColor Yellow "Voce escolheu a opção 1 (Mover para outro diretorio)."
    }
    "2" {
        Write-Host -ForegroundColor Yellow "Voce escolheu a opçao 2 (Copiar para outro diretorio)."
    }
    "3" {
        Write-Host -ForegroundColor Red "Voce escolheu a opçao 3 (Apagar)."
    }
    default {
        Write-Host -ForegroundColor Red "Opçao não reconhecida."
    }
}

    #    foreach ($arquivo in $arquivos) {
    #       # Verifica se é um arquivo
    #       if ($arquivo.PSIsContainer -eq $true -and $arquivo.Name -eq $nome) {
	#			
    #           Write-Host -ForegroundColor Red $arquivo.Name 
	#		}
	#	}
	

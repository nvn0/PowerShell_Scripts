
# Define o caminho direto para o executável do Firefox e os argumentos desejados
$firefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$firefoxArgs = "-p Work"

# URL para abrir
$url = "https://outlook.live.com/mail/0/"
$url2 = "https://mail.proton.me/u/0/inbox"
$url3 = "https://app.tuta.com/mail/MTcQYa5-0N-2"
$url4 = "https://www.linkedin.com/feed/"


Start-Process -FilePath $firefoxPath -ArgumentList $firefoxArgs, "-new-tab $url"
Start-Process -FilePath $firefoxPath -ArgumentList $firefoxArgs, "-new-tab $url2"
Start-Process -FilePath $firefoxPath -ArgumentList $firefoxArgs, "-new-tab $url3"
Start-Process -FilePath $firefoxPath -ArgumentList $firefoxArgs, "-new-tab $url4"


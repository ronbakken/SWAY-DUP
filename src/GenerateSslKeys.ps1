Write-Host "Generating SSL keys for client/server communications..."
Write-Host

$OpenSslDir = "C:\Software\openssl"
# $OpenSslDir = "C:\Program Files\Git\mingw64\"
$OpenSsl = $OpenSslDir + "\bin\openssl"
$Days = 10000

$CAKeyPath = "ca.key"
$CACertPath = "ca.crt"
$CAPassword = 123456
$LocalConfig = "local.cnf"

If (!(Test-Path ca.crt) -and !(Test-Path ca.key)) {
    $CASubject = "/C=US/ST=California/O=INF Marketplace LLC/OU=www.swaymarketplace.com/CN=Sway Marketplace Root CA"

    Write-Warning "Certificate authority crt and key files not found - regenerating!"

    Write-Host
    Write-Host "Generating CA key..."
    & $OpenSsl genrsa -passout pass:$CAPassword -des3 -out $CAKeyPath 2048

    Write-Host
    Write-Host "Generating CA certificate..."
    & $OpenSsl req -config $LocalConfig -extensions ca_ext -passin pass:$CAPassword -new -x509 -days $Days -sha256 -key $CAKeyPath -out $CACertPath -subj $CASubject
}

function Generate-ServerKey {
    Param([String]$Environment, [String]$CommonName)

    $Subject = "/C=US/ST=California/O=INF Marketplace LLC/OU=Sway Marketplace/CN=$CommonName"

    Write-Host
    Write-Host "Generating server key for $Environment..."
    & $OpenSsl genrsa -out server_$Environment.key 2048

    # Generate server signing request
    & $OpenSsl req -config $LocalConfig -new -key server_$Environment.key -out server_$Environment.csr -subj $Subject

    # Self-sign server certificate
    & $OpenSsl x509 -extfile $LocalConfig -extensions server_ext -req -passin pass:$CAPassword -days $Days -in server_$Environment.csr -CA $CACertPath -CAkey $CAKeyPath -set_serial 01 -out server_$Environment.crt
}

Generate-ServerKey -Environment local -CommonName localhost
Generate-ServerKey -Environment dev -CommonName api.dev.swaymarketplace.com
Generate-ServerKey -Environment alpha -CommonName api.alpha.swaymarketplace.com
Generate-ServerKey -Environment prod -CommonName api.swaymarketplace.com

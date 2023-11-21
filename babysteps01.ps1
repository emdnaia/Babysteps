# First upload here: https://pastebin.com/pNrNapb8
$command=Read-Host 'Enter command'
$aesManaged=New-Object System.Security.Cryptography.AesManaged
$aesManaged.Mode=[System.Security.Cryptography.CipherMode]::CBC
$aesManaged.Padding=[System.Security.Cryptography.PaddingMode]::PKCS7
$aesManaged.GenerateKey()
$aesManaged.GenerateIV()
$key=[Convert]::ToBase64String($aesManaged.Key)
$iv=[Convert]::ToBase64String($aesManaged.IV)
$encryptor=$aesManaged.CreateEncryptor($aesManaged.Key,$aesManaged.IV)
$encryptedBytes=$encryptor.TransformFinalBlock([System.Text.Encoding]::UTF8.GetBytes($command),0,$command.Length)
$encryptedCommand=[Convert]::ToBase64String($encryptedBytes)
$obfuscatedCommand=''
foreach($char in $encryptedCommand.ToCharArray()) { $obfuscatedCommand = $char + $obfuscatedCommand }
 
# Generate the command for decryption and execution
$execStr="function Decrypt-Command{param([string]`$eCmd,[string]`$k,[string]`$i)`$am=New-Object System.Security.Cryptography.AesManaged;`$am.Mode='CBC';`$am.Padding='PKCS7';`$am.Key=[Convert]::FromBase64String(`$k);`$am.IV=[Convert]::FromBase64String(`$i);`$d=`$am.CreateDecryptor();`$eB=[Convert]::FromBase64String(`$eCmd);`$dB=`$d.TransformFinalBlock(`$eB,0,`$eB.Length);return [System.Text.Encoding]::UTF8.GetString(`$dB)};`$deobfCmd='';foreach(`$char in '$obfuscatedCommand'.ToCharArray()){`$deobfCmd=`$char+`$deobfCmd};Invoke-Expression (Decrypt-Command `$deobfCmd '$key' '$iv')"
 
# Output the command for copying
Write-Host $execStr

# Original upload: https://pastebin.com/Qhrbmy8R
# v6.6
# Prompt for user input with split strings
$promptPart1 = 'Enter '
$promptPart2 = 'command'
$cmd = Read-Host ($promptPart1 + $promptPart2)
 
# Initialize and configure AES encryption with dynamically generated object name
$encryptObjName = -join ('AesManaged' | Get-Random -Count 10)
$encryptionObject = New-Object Security.Cryptography.$encryptObjName 
$encryptionObject.GenerateKey() 
$encryptionObject.GenerateIV() 
$encryptor = $encryptionObject.CreateEncryptor()
 
# Encrypt the command with dynamic alias substitution
$aliasConvertToBase64 = 'ToBase64String'
$encryptedBytes = $encryptor.TransformFinalBlock([Text.Encoding]::UTF8.GetBytes($cmd), 0, $cmd.Length)
$encryptedCmd = [Convert]::$aliasConvertToBase64($encryptedBytes)
 
# Ensure correct key length for AES encryption
$Key = [Convert]::ToBase64String($encryptionObject.Key)
$IV = [Convert]::ToBase64String($encryptionObject.IV)
$keyLength = 32 # Length for AES-256
$ivLength = 16 # Standard IV length for AES
 
# Store IV as Base64 with dynamic variable names
$Base64IVVarName = -join ('IV' | Get-Random -Count 10)
$Base64IV = [Convert]::ToBase64String($encryptionObject.IV)
 
# Decryption command with adjusted key and IV handling
$decryptFuncName = -join ('DecryptCmd' | Get-Random -Count 10)
$decryptCmd = "function $decryptFuncName{param(`$eCmd, `$key, `$iv)`$AES=New-Object Security.Cryptography.AesManaged;`$AES.Key=[Convert]::FromBase64String(`$key);`$AES.IV=[Convert]::FromBase64String(`$iv);`$decryptor=`$AES.CreateDecryptor();`$eBytes=[Convert]::FromBase64String(`$eCmd);`$dBytes=`$decryptor.TransformFinalBlock(`$eBytes,0,`$eBytes.Length);return [Text.Encoding]::UTF8.GetString(`$dBytes)}; iex ($decryptFuncName '$encryptedCmd' '$Key' '$IV')"
 
# Output with No-Op commands and dynamic behavior
$nullVar = Get-Random
$nullVar++
$nullVar--
Write-Host "To execute your command, copy and paste the following line:" 
Write-Host $decryptCmd

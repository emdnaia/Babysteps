# v6.6.2 - with key splitting and string reversal

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

# Reverse the encrypted command
$reversedEncryptedCmd = -join ($encryptedCmd[-1..-($encryptedCmd.Length)])

# Split the key into multiple parts with random case
$Key = [Convert]::ToBase64String($encryptionObject.Key)
$keyPart1 = $Key.Substring(0, 8)
$keyPart2 = $Key.Substring(8, 8)
$keyPart3 = $Key.Substring(16)

# Store IV as Base64 with dynamic variable names
$Base64IVVarName = -join ('IV' | Get-Random -Count 10)
$Base64IV = [Convert]::ToBase64String($encryptionObject.IV)

# Constructing a single-line decryption command
$decryptFuncName = -join ('DecryptCmd' | Get-Random -Count 10)
$decryptCmd = "function $decryptFuncName{param(`$eCmd,`$k1,`$k2,`$k3,`$iv)`$AES=New-Object Security.Cryptography.AesManaged;`$keyBytesList=New-Object System.Collections.ArrayList;`$keyBytesList.AddRange([Convert]::FromBase64String(`$k1));`$keyBytesList.AddRange([Convert]::FromBase64String(`$k2));`$keyBytesList.AddRange([Convert]::FromBase64String(`$k3));`$keyBytes=`$keyBytesList.ToArray();`$AES.IV=[Convert]::FromBase64String(`$iv);`$decryptor=`$AES.CreateDecryptor(`$keyBytes,`$AES.IV);`$reversedEBytes=-join(`$eCmd[-1..-(`$eCmd.Length)]);`$eBytes=[Convert]::FromBase64String(`$reversedEBytes);`$dBytes=`$decryptor.TransformFinalBlock(`$eBytes,0,`$eBytes.Length);return [Text.Encoding]::UTF8.GetString(`$dBytes)};iex ($decryptFuncName '$reversedEncryptedCmd' '$keyPart1' '$keyPart2' '$keyPart3' '$Base64IV')"

# Output the command as a single line
Write-Host "To execute your command, copy and paste the following line:"
Write-Host $decryptCmd

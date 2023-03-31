
# Verificar si el usuario es administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "No eres administrador. Por favor ejecuta este script como administrador."
    exit
}

# Listar interfaces de red
Write-Host "Interfaces de red disponibles:"
$interfaces = Get-NetAdapter | Sort-Object ifIndex | Select-Object @{Name="Interfaz"; Expression={$_.ifIndex}}, @{Name="Nombre de la interfaz"; Expression={$_.Name}}, @{Name="Descripción de la interfaz"; Expression={$_.InterfaceDescription}}
$interfaces | Format-Table

# Preguntar al usuario qué interfaz quiere configurar
$ifIndex = Read-Host -Prompt "Ingresa el número de la interfaz que quieres configurar"

# Preguntar al usuario si quiere una IP dinámica o fija
$ipType = Read-Host -Prompt "¿Quieres una IP dinámica o fija? (Ingresa '1' para dinámica o '2' para fija)"

if ($ipType -eq "2") {
    # Preguntar al usuario por la IP, máscara de red, gateway y DNS
    $ipAddress = Read-Host -Prompt "Ingresa la dirección IP"
    $subnetMask = Read-Host -Prompt "Ingresa la máscara de red (en formato /24, /23, etc.)"
    $gateway = Read-Host -Prompt "Ingresa la dirección del gateway"
    $dns = Read-Host -Prompt "¿Quieres especificar los servidores DNS? (Ingresa '1' para sí o '2' para no)"

    if ($dns -eq "1") {
        $dns1 = Read-Host -Prompt "Ingresa el primer servidor DNS"
        $dns2 = Read-Host -Prompt "Ingresa el segundo servidor DNS"
        Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses ($dns1,$dns2)
    } else {
        # Usar los servidores DNS de Google por defecto
        Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses ("8.8.8.8","8.8.4.4")
    }

    # Configurar la IP fija
    New-NetIPAddress -InterfaceIndex $ifIndex -IPAddress $ipAddress -PrefixLength $subnetMask.Substring(1) -DefaultGateway $gateway
} else {
    # Configurar la IP dinámica
    Set-NetIPInterface -InterfaceIndex $ifIndex -Dhcp Enabled
}

# Imprimir la configuración de la interfaz
Write-Host "Configuración de la interfaz:"
Get-NetIPConfiguration -InterfaceIndex $ifIndex | Format-List

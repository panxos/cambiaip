# CambiaIP

Este script de PowerShell permite verificar si el usuario es administrador y si no lo es, indica que debe ejecutarse como tal. Luego lista las interfaces de red disponibles ordenadas por índice y con las columnas renombradas como Interfaz, Nombre de la interfaz y Descripción de la interfaz. Después pregunta al usuario qué interfaz quiere configurar y si quiere una IP dinámica o fija (con elección de número). Si el usuario elige una IP fija (ingresando '2'), se le pide que ingrese la dirección IP, máscara de red, gateway y si quiere especificar los servidores DNS (ingresando '1' para sí o '2' para no). Si no se especifican los servidores DNS (ingresando '2'), se usan los de Google por defecto (8.8.8.8 y 8.8.4.4). Finalmente, se imprime la configuración de la interfaz seleccionada.

## Instalación

Para agregar este script como una variable de entorno global permanente y poder llamarlo desde cualquier parte y por cualquier usuario con el comando "cambiaip", sigue estos pasos:

1. Guarda el script en un archivo con el nombre "cambiaip.ps1" en una ubicación accesible por todos los usuarios, por ejemplo "C:\Scripts".
2. Abre una ventana de PowerShell como administrador.
3. Ejecuta el siguiente comando para agregar la ubicación del script a la variable de entorno "Path":
```PowerShell
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
$newPath = $oldPath + ";C:\Scripts"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
```
4. Cierra y vuelve a abrir todas las ventanas de PowerShell para que los cambios tengan efecto.
5. Ahora puedes ejecutar el script desde cualquier ubicación y por cualquier usuario con el comando "cambiaip".

## Uso

Para usar el script, simplemente ejecuta el comando "cambiaip" en una ventana de PowerShell. El script te guiará a través del proceso de configuración de la interfaz de red seleccionada.

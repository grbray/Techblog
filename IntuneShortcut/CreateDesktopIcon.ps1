[CmdletBinding()]
Param (
   [Parameter(Mandatory=$true)]
   [String]$ShortcutTargetPath,

   [Parameter(Mandatory=$true)]
   [String]$ShortcutDisplayName,

   [Parameter(Mandatory=$false)]
   [Switch]$PinToStart=$false,

   [Parameter(Mandatory=$false)]
   [String]$IconFile=$null,

   [Parameter(Mandatory=$false)]
   [String]$ShortcutArguments=$null
)

#helper function to avoid uneccessary code
function Add-Shortcut {
    param (
        [Parameter(Mandatory=$true)]
        [String] $destinationPath
    )

    process{

        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($destinationPath)
        $Shortcut.TargetPath = $ShortcutTargetPath
        $Shortcut.Arguments = $ShortcutArguments
    
        if ($IconFile){
    
            $Shortcut.IconLocation = $IconFile
        }
    
        $Shortcut.Save()
    
        #cleanup
        [Runtime.InteropServices.Marshal]::ReleaseComObject($WshShell) | Out-Null
    }
}

### Desktop shortcut
$desktopDir=$([Environment]::GetFolderPath("Desktop"))

$destinationPath= Join-Path -Path $desktopDir -ChildPath "$shortcutDisplayName.lnk"

Add-Shortcut -destinationPath $destinationPath

#### Start menu entry
if ($PinToStart.IsPresent -eq $true){

    $startMenuDir=$([Environment]::GetFolderPath("StartMenu"))

    $destinationPath = Join-Path -Path $startMenuDir -ChildPath $fullShortcutName

    Add-Shortcut -destinationPath $destinationPath
}
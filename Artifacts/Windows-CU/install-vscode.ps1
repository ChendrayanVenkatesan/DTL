###################################################################################################
#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

# Hide any progress bars, due to downloads and installs of remote components.
$ProgressPreference = "SilentlyContinue"

# Ensure we force use of TLS 1.2 for all downloads.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Discard any collected errors from a previous execution.
$Error.Clear()

# Allow certian operations, like downloading files, to execute.
Set-ExecutionPolicy Bypass -Scope Process -Force

###################################################################################################
#
# Handle all errors in this script.
#

trap {
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    $message = $Error[0].Exception.Message
    if ($message) {
        Write-Host -Object "`nERROR: $message" -ForegroundColor Red
    }

    Write-Host "`nThe artifact failed to apply.`n"

    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}

###################################################################################################
#
# Functions used in this script.
#

###################################################################################################
#
# Main execution block.
#
try {
    Push-Location $PSScriptRoot
    # Write-Host "Installing KB5004945..."
    # $arglist = '.\windows10.0-kb5004945-x64_db8eafe34a43930a0d7c54d6464ff78dad605fb7.msu', '/quiet'
    # Get-Item ".\windows10.0-kb5004945-x64_db8eafe34a43930a0d7c54d6464ff78dad605fb7.msu"
    # Start-Process -FilePath 'c:\windows\system32\wusa.exe' -ArgumentList $arglist -NoNewWindow -Wait -Verbose
    Get-WmiObject -class win32_ReliabilityRecords | Select ProductName , SourceName , User , Message
}
finally {
    Pop-Location
}
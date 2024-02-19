#
# Validates whether a file is a valid certificate using CertUtil.
# This needs to be done before calling Get-PfxCertificate on the file, otherwise
# the user will get a cryptic "Password: " prompt for invalid certs.
#
function ValidateCertificateFormat($FilePath)
{
    # certutil -verify prints a lot of text that we don't need, so it's redirected to $null here
    certutil.exe -verify $FilePath > $null
    if ($LastExitCode -lt 0)
    {
		Write-Host ("Bad certificate" -f $FilePath, $LastExitCode)
		exit 1
    }
    
    # Check if certificate is expired
    $cert = Get-PfxCertificate $FilePath
    if (($cert.NotBefore -gt (Get-Date)) -or ($cert.NotAfter -lt (Get-Date)))
    {
        Write-Host ("Expired certificate" -f $FilePath)
		exit 1
    }
}

function InstallPackageWithDependencies
{
    $DependencyPackages = @()
    if (Test-Path $DependencyPackagesDir)
    {
        # Get architecture-neutral dependencies
        $DependencyPackages += Get-ChildItem (Join-Path $DependencyPackagesDir "*.appx") | Where-Object { $_.Mode -NotMatch "d" }
    }
    
    $AddPackageSucceeded = $False
    try
    {
        if ($DependencyPackages.FullName.Count -gt 0)
        {
            Write-Host "Dependencies Found"
            $DependencyPackages.FullName
            Add-AppxPackage -Path $PackagePath -DependencyPath $DependencyPackages.FullName -ForceApplicationShutdown
        }
        else
        {
			Write-Host "Dependencies not Found"
            Add-AppxPackage -Path $PackagePath -ForceApplicationShutdown
        }
        $AddPackageSucceeded = $?
    }
    catch
    {
        $Error[0] # Dump details about the last error
	exit 1
    }
}

try{
$ErrorActionPreference = "Stop"; #Make all errors terminating
#Start-Transcript -path TBT_Install.log -append -force
$ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path
$ScriptDir = Split-Path -Parent $ScriptPath
$PackagePath = Split-Path -Parent $ScriptDir
#$PackagePath = Join-Path $PackagePath -ChildPath "*_x64" | Resolve-Path
$CertPath = Join-Path $PackagePath ControlCenter\ThunderboltControlApp
$DependencyPackagesDir = (Join-Path $PackagePath "ControlCenter\ThunderboltControlApp\Dependencies")
$DependencyPackagesDir = (Join-Path $DependencyPackagesDir "x64")
$PackagePath = Get-ChildItem (Join-Path $PackagePath\ControlCenter\ThunderboltControlApp "*.appx") | Where-Object { $_.Mode -NotMatch "d" } 

# The package must be signed
$PackageSignature = Get-AuthenticodeSignature $PackagePath
$PackageCertificate = $PackageSignature.SignerCertificate
if (!$PackageCertificate)
{
	Write-Host "Error, Package unsigned"
	exit 1
}

# Test if the package signature is trusted.  If not, the corresponding certificate
# needs to be present in the current directory and needs to be installed.
$NeedInstallCertificate = ($PackageSignature.Status -ne "Valid")

if ($NeedInstallCertificate)
{
	# List all .cer files in the script directory
	$DeveloperCertificatePath = Get-ChildItem (Join-Path $CertPath "*.cer") | Where-Object { $_.Mode -NotMatch "d" }
	$DeveloperCertificateCount = ($DeveloperCertificatePath | Measure-Object).Count

	# There must be exactly 1 certificate
	if ($DeveloperCertificateCount -lt 1)
	{
		Write-Host "Certificate not Found"
		exit 1
	}
	elseif ($DeveloperCertificateCount -gt 1)
	{
		Write-Host "More than one certificate Found"
		exit 1
	}

	Write-Host "Certificate file found"

	# The .cer file must have the format of a valid certificate
	ValidateCertificateFormat $DeveloperCertificatePath

	# The package signature must match the certificate file
	if ($PackageCertificate -ne (Get-PfxCertificate $DeveloperCertificatePath))
	{
		Write-Host "Error certificate mismatch"
		exit 1
	}
	
    try
    {
		# Add cert to store
		certutil.exe -addstore TrustedPeople $DeveloperCertificatePath.FullName
		if ($LastExitCode -lt 0)
		{
			Write-Host ("certification install failed" -f $LastExitCode) 
			exit 1
		}
    }
    catch
    {
        $Error[0] # Dump details about the last error
        Write-Host "Error, certification install failed"
		exit 1
    }

    # Check if operation was successful
    if ($NeedInstallCertificate)
    {
        $Signature = Get-AuthenticodeSignature $PackagePath -Verbose
        if ($Signature.Status -ne "Valid")
        {
            Write-Host ("Error install certificate failed" -f $Signature.Status)
			exit 1
        }
        else
        {
            Write-Host "Install Certificate Successful"
        }
    }
}

InstallPackageWithDependencies
#Stop-Transcript
} catch {
exit 1
}
exit 0
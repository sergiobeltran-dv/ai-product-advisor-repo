# Terraform Validation Script
# This script validates the Terraform configuration for both dev and prod environments

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev","prod","both")]
    [string]$Environment = "both"
)

$ErrorActionPreference = "Continue"

function Test-TerraformEnvironment {
    param(
        [string]$EnvPath,
        [string]$EnvName
    )

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Validating $EnvName Environment" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    if (!(Test-Path $EnvPath)) {
        Write-Host "Error: Environment path not found: $EnvPath" -ForegroundColor Red
        return $false
    }

    Push-Location $EnvPath

    try {
        # Check if terraform is installed
        Write-Host "Checking Terraform installation..." -ForegroundColor Yellow
        $tfVersion = terraform version
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Terraform is not installed or not in PATH" -ForegroundColor Red
            return $false
        }
        Write-Host "Terraform version: $($tfVersion[0])" -ForegroundColor Green

        # Check if terraform.tfvars exists
        if (!(Test-Path "terraform.tfvars")) {
            Write-Host "Warning: terraform.tfvars not found. Using example file for validation." -ForegroundColor Yellow
            if (Test-Path "terraform.tfvars.example") {
                Copy-Item "terraform.tfvars.example" "terraform.tfvars.temp" -Force
                $tempFile = $true
            }
        }

        # Format check
        Write-Host "`nChecking Terraform formatting..." -ForegroundColor Yellow
        terraform fmt -check -recursive
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Warning: Some files are not properly formatted. Run 'terraform fmt' to fix." -ForegroundColor Yellow
        } else {
            Write-Host "Formatting check passed!" -ForegroundColor Green
        }

        # Initialize
        Write-Host "`nInitializing Terraform..." -ForegroundColor Yellow
        # Comment out backend for validation
        if (Test-Path "backend.tf") {
            Rename-Item "backend.tf" "backend.tf.disabled" -Force
            $backupBackend = $true
        }
        
        terraform init -backend=false
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Terraform initialization failed" -ForegroundColor Red
            return $false
        }
        Write-Host "Initialization successful!" -ForegroundColor Green

        # Validate
        Write-Host "`nValidating Terraform configuration..." -ForegroundColor Yellow
        terraform validate
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Terraform validation failed" -ForegroundColor Red
            return $false
        }
        Write-Host "Validation successful!" -ForegroundColor Green

        Write-Host "`nAll checks passed for $EnvName environment!" -ForegroundColor Green
        return $true

    }
    finally {
        # Cleanup
        if ($tempFile) {
            Remove-Item "terraform.tfvars.temp" -Force -ErrorAction SilentlyContinue
        }
        if ($backupBackend) {
            Rename-Item "backend.tf.disabled" "backend.tf" -Force
        }
        Pop-Location
    }
}

# Main execution
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$terraformRoot = Split-Path -Parent $scriptPath

$results = @{}

if ($Environment -eq "dev" -or $Environment -eq "both") {
    $devPath = Join-Path $terraformRoot "environments\dev"
    $results["dev"] = Test-TerraformEnvironment -EnvPath $devPath -EnvName "Development"
}

if ($Environment -eq "prod" -or $Environment -eq "both") {
    $prodPath = Join-Path $terraformRoot "environments\prod"
    $results["prod"] = Test-TerraformEnvironment -EnvPath $prodPath -EnvName "Production"
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Validation Summary" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$allPassed = $true
foreach ($env in $results.Keys) {
    $status = if ($results[$env]) { "PASSED" } else { "FAILED" }
    $color = if ($results[$env]) { "Green" } else { "Red" }
    Write-Host "$env Environment: $status" -ForegroundColor $color
    
    if (!$results[$env]) {
        $allPassed = $false
    }
}

Write-Host ""
if ($allPassed) {
    Write-Host "All validations passed successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some validations failed. Please review the errors above." -ForegroundColor Red
    exit 1
}


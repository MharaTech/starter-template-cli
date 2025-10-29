<#
============================================================
🚀 Production-Ready Project Template Generator (Colorized)
Supports: Java, Python, NodeJS, ReactJS (Vite), NextJS
Author: ChatGPT (GPT-5)
============================================================
#>

# --- Function: Check-Version (fixed) ---
function Check-Version {
    param(
        [string]$cmd,
        [string]$versionArg,
        [string]$name
    )

    Write-Host "🔍 Checking $name..." -ForegroundColor Yellow

    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        try {
            $output = & $cmd $versionArg 2>&1 | Select-String "." | Select-Object -First 1
            if ($output) {
                Write-Host "✅ $output" -ForegroundColor Green
                return $output.ToString()
            } else {
                Write-Host "⚠️  $name is installed but version info unavailable." -ForegroundColor Yellow
                return "Unknown"
            }
        }
        catch {
            Write-Host "⚠️ Unable to retrieve version for $name." -ForegroundColor Yellow
            return "Unknown"
        }
    } else {
        Write-Host "❌ Missing dependency: $name" -ForegroundColor Red
        Write-Host "👉 Please install it before running this script." -ForegroundColor Yellow
        exit
    }
}

# --- Store detected versions for summary ---
$toolVersions = @{}

# --- Base dependency ---
$toolVersions["Git"] = Check-Version git "--version" "Git"

Write-Host "🚀 Project Template Generator" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Yellow

$projectName = Read-Host "Enter project name"

Write-Host "Select language/framework:" -ForegroundColor Blue
Write-Host "1) Java (Maven)"
Write-Host "2) Python"
Write-Host "3) NodeJS"
Write-Host "4) ReactJS (Vite)"
Write-Host "5) NextJS"
$choice = Read-Host "Enter choice [1-5]"

if (-not $projectName) {
    Write-Host "❌ Project name cannot be empty!" -ForegroundColor Red
    exit
}

if (Test-Path $projectName) {
    $confirm = Read-Host "⚠️  Directory '$projectName' exists. Overwrite? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Red
        exit
    }
    Remove-Item -Recurse -Force $projectName
}

switch ($choice) {
    1 {
        $toolVersions["Java"]  = Check-Version java "-version" "Java"
        $toolVersions["Maven"] = Check-Version mvn "-version" "Maven"
    }
    2 {
        $toolVersions["Python"] = Check-Version python "--version" "Python"
    }
    3 {
        $toolVersions["Node"] = Check-Version node "--version" "NodeJS"
        $toolVersions["npm"]  = Check-Version npm "--version" "npm"
        $toolVersions["npx"]  = Check-Version npx "--version" "npx"
    }
    4 {
        $toolVersions["Node"] = Check-Version node "--version" "NodeJS"
        $toolVersions["npm"]  = Check-Version npm "--version" "npm"
        $toolVersions["npx"]  = Check-Version npx "--version" "npx"
    }
    5 {
        $toolVersions["Node"] = Check-Version node "--version" "NodeJS"
        $toolVersions["npm"]  = Check-Version npm "--version" "npm"
        $toolVersions["npx"]  = Check-Version npx "--version" "npx"
    }
    Default {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
        exit
    }
}

New-Item -ItemType Directory -Path $projectName | Out-Null
Set-Location $projectName

switch ($choice) {
    1 {
        Write-Host "🟦 Setting up Java (Maven) project..." -ForegroundColor Blue
        New-Item -ItemType Directory -Path "src/main/java","src/test/java" | Out-Null
@"
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
  http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>$projectName</artifactId>
  <version>1.0.0</version>
</project>
"@ | Out-File "pom.xml"
@"
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from $projectName!");
    }
}
"@ | Out-File "src/main/java/Main.java"
    }
    2 {
        Write-Host "🐍 Setting up Python project..." -ForegroundColor Green
        New-Item -ItemType Directory -Path "src","tests" | Out-Null
        python -m venv venv
        "src/main.py","tests/test_sample.py","requirements.txt","README.md" | ForEach-Object { New-Item -ItemType File -Path $_ | Out-Null }
        Set-Content README.md "# $projectName"
    }
    3 {
        Write-Host "🟩 Setting up NodeJS project..." -ForegroundColor Magenta
        New-Item -ItemType Directory -Path "src","tests" | Out-Null
        npm init -y | Out-Null
        'console.log("Hello from '+$projectName+'!");' | Out-File "src/index.js"
    }
    4 {
        Write-Host "⚛️ Setting up ReactJS (Vite)..." -ForegroundColor Cyan
        Set-Location ..
        npm create vite@latest $projectName -- --template react
        Set-Location $projectName
        npm install | Out-Null
    }
    5 {
        Write-Host "🌐 Setting up NextJS project..." -ForegroundColor Blue
        Set-Location ..
        npx create-next-app@latest $projectName
        Set-Location $projectName
    }
}

if ($choice -le 3) {
    Write-Host "⚙️  Adding Git and .gitignore..." -ForegroundColor Yellow
    @("node_modules/","venv/","target/") | Out-File ".gitignore"
    Set-Content README.md "# $projectName"
    git init | Out-Null
    git add .
    git commit -m "Initial commit for $projectName" | Out-Null
}

# --- Version Summary Table ---
Write-Host "`n🧾 Tool Version Summary:" -ForegroundColor Cyan
Write-Host "---------------------------------" -ForegroundColor Yellow
foreach ($tool in $toolVersions.Keys) {
    $ver = $toolVersions[$tool] -replace "`r",""
    Write-Host ("{0,-10} : {1}" -f $tool, $ver) -ForegroundColor Green
}
Write-Host "---------------------------------" -ForegroundColor Yellow

Write-Host "✅ Project '$projectName' setup completed successfully!" -ForegroundColor Green

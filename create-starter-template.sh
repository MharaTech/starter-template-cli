#!/bin/bash
# ============================================================
# 🚀 Production-Ready Project Template Generator (Colorized)
# Supports: Java, Python, NodeJS, ReactJS (Vite), NextJS
# Author: ChatGPT (GPT-5)
# ============================================================

set -e

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Detect and validate OS ---
OS_TYPE="$(uname -s)"

case "$OS_TYPE" in
  Linux*)
    PLATFORM="Linux"
    ;;
  Darwin*)
    PLATFORM="macOS"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    if grep -qi "microsoft" /proc/version 2>/dev/null; then
      PLATFORM="WSL"
    else
      PLATFORM="Windows"
    fi
    ;;
  *)
    PLATFORM="Unknown"
    ;;
esac

echo -e "${CYAN}🧠 Detected OS:${RESET} ${BOLD}${PLATFORM}${RESET}"

# ✅ Allow only Linux, macOS, or WSL
if [[ "$PLATFORM" != "Linux" && "$PLATFORM" != "macOS" && "$PLATFORM" != "WSL" ]]; then
  echo -e "${RED}❌ Unsupported OS detected: $PLATFORM${RESET}"
  echo -e "${YELLOW}This script can only run on Linux, macOS, or WSL.${RESET}"
  exit 1
fi

declare -A TOOL_VERSIONS

# --- Function: Dependency + Version Check ---
check_version() {
  local cmd=$1
  local version_flag=$2
  local name=$3

  echo -e "${YELLOW}🔍 Checking $name...${RESET}"
  if command -v "$cmd" >/dev/null 2>&1; then
    local version_output
    version_output=$($cmd $version_flag 2>&1 | grep -m1 . || echo "Unknown")
    echo -e "${GREEN}✅ $version_output${RESET}"
    TOOL_VERSIONS[$name]="$version_output"
  else
    echo -e "${RED}❌ Missing dependency: $name${RESET}"
    echo -e "${YELLOW}👉 Please install it before running this script.${RESET}"
    exit 1
  fi
}

# --- Base dependency ---
check_version git --version "Git"

echo -e "${BOLD}${CYAN}🚀 Project Template Generator${RESET}"
echo -e "${YELLOW}==============================${RESET}"

# ✅ FIXED: quoting issues
echo -ne "${BOLD}Enter project name:${RESET} "
read project_name

echo -e "${BOLD}${BLUE}Select language/framework:${RESET}"
echo "1) Java (Maven)"
echo "2) Python"
echo "3) NodeJS"
echo "4) ReactJS (Vite)"
echo "5) NextJS"
echo -ne "${BOLD}Enter choice [1-5]:${RESET} "
read choice

if [ -z "$project_name" ]; then
  echo -e "${RED}❌ Project name cannot be empty!${RESET}"
  exit 1
fi

if [ -d "$project_name" ]; then
  echo -e "${YELLOW}⚠️  Directory '${project_name}' already exists.${RESET}"
  echo -ne "${BOLD}Do you want to overwrite it? (y/N):${RESET} "
  read confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted.${RESET}"
    exit 1
  fi
  rm -rf "$project_name"
fi

# --- Language-specific Dependency Checks ---
case $choice in
  1)
    check_version java -version "Java"
    check_version mvn -version "Maven"
    ;;
  2)
    check_version python3 --version "Python3"
    ;;
  3|4|5)
    check_version node --version "NodeJS"
    check_version npm --version "npm"
    check_version npx --version "npx"
    ;;
  *)
    echo -e "${RED}❌ Invalid choice${RESET}"
    exit 1
    ;;
esac

mkdir "$project_name"
cd "$project_name"

# --- Create Template ---
case $choice in
  1)
    echo -e "${BLUE}🟦 Setting up Java (Maven) project...${RESET}"
    mkdir -p src/main/java src/test/java
    cat > pom.xml <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
  http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>${project_name}</artifactId>
  <version>1.0.0</version>
</project>
EOF
    cat > src/main/java/Main.java <<EOF
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from ${project_name}!");
    }
}
EOF
    ;;
  2)
    echo -e "${GREEN}🐍 Setting up Python project...${RESET}"
    mkdir -p src tests
    python3 -m venv venv
    touch src/main.py tests/test_sample.py requirements.txt README.md
    echo "# ${project_name}" > README.md
    ;;
  3)
    echo -e "${MAGENTA}🟩 Setting up NodeJS project...${RESET}"
    mkdir -p src tests
    npm init -y >/dev/null 2>&1
    echo "console.log('Hello from ${project_name}!');" > src/index.js
    ;;
  4)
    echo -e "${CYAN}⚛️ Setting up ReactJS (Vite)...${RESET}"
    cd ..
    npm create vite@latest "$project_name" -- --template react
    cd "$project_name"
    npm install >/dev/null 2>&1
    ;;
  5)
    echo -e "${BLUE}🌐 Setting up NextJS project...${RESET}"
    cd ..
    npx create-next-app@latest "$project_name"
    cd "$project_name"
    ;;
esac

# --- Git Setup ---
if [ "$choice" -le 3 ]; then
  echo -e "${YELLOW}⚙️  Initializing Git and adding .gitignore...${RESET}"
  cat > .gitignore <<EOF
node_modules/
venv/
target/
EOF
  echo "# ${project_name}" > README.md
  git init >/dev/null 2>&1
  git add .
  git commit -m "Initial commit for ${project_name}" >/dev/null 2>&1
fi

# --- Summary Table ---
echo -e "\n${CYAN}🧾 Tool Version Summary:${RESET}"
echo -e "${YELLOW}---------------------------------${RESET}"
for tool in "${!TOOL_VERSIONS[@]}"; do
  printf "${GREEN}%-10s${RESET} : %s\n" "$tool" "${TOOL_VERSIONS[$tool]}"
done
echo -e "${YELLOW}---------------------------------${RESET}"

echo -e "${GREEN}✅ Project '${project_name}' setup completed successfully!${RESET}"

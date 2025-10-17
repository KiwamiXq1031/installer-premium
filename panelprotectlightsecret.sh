#!/bin/bash

# Color definitions
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"
BOLD="\033[1m"
VERSION="1.3"

# Function to display header
display_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║                      __====-_  _-====__                      ║"
    echo "║                _--^^^#####//      \#####^^^--_               ║"
    echo "║             _-^##########// (    ) \##########^-_            ║"
    echo "║            -############//  |\^^/|  \############-            ║"
    echo "║          _/############//   (@::@)   \############\_          ║"
    echo "║         /#############((     \\//     ))#############\         ║"
    echo "║        -###############\\    (oo)    //###############-        ║"
    echo "║       -#################\\  / VV \  //#################-       ║"
    echo "║      -###################\\/      \//###################-      ║"
    echo "║     _#/|##########/\######(   /\   )######/\##########|\#_     ║"
    echo "║     |/ |#/\#/\#/\/  \#/\##\  |  |  /##/\#/  \/\#/\#/\#| \|     ║"
    echo "║     '  |/  V  V  '   V  \#\| |  | |/#/  V   '  V  V  \|  '     ║"
    echo "║        '   '  '      '   / | |  | | \   '      '  '   '        ║"
    echo "║                         (  | |  | |  )                         ║"
    echo "║                          \ | |  | | /                          ║"
    echo "║                           \| |  | |/                           ║"
    echo "║                            ' |  | '                            ║"
    echo "║                              \__/                              ║"
    echo "║                                                              ║"
    echo "║    🦅  PTERODACTYL PANEL - Powered by ZERO PROTECT  🛡️      ║"
    echo "║                    Version $VERSION                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Function to display menu
display_menu() {
    echo ""
    echo -e "${CYAN}${BOLD}    ┌────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}${BOLD}    │             🚀 MAIN MENU                  │${RESET}"
    echo -e "${CYAN}${BOLD}    └────────────────────────────────────────────┘${RESET}"
    echo ""
    echo -e "${YELLOW}${BOLD}    [1]${RESET} ${GREEN}🚀 Deploy Full Protection + Panel${RESET}"
    echo -e "${YELLOW}${BOLD}    [2]${RESET} ${GREEN}📦 Restore Backup & Build Panel${RESET}"
    echo -e "${YELLOW}${BOLD}    [3]${RESET} ${GREEN}👑 Admin Protection Setup${RESET}"
    echo ""
    echo -e "${CYAN}${BOLD}    ┌────────────────────────────────────────────┐${RESET}"
    echo -n -e "${CYAN}${BOLD}    │ 🎯 Select: ${RESET}"
}

# Function to deploy protection
deploy_protection() {
    local ADMIN_ID="$1"
    local CONTROLLER_USER="/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"
    local SERVICE_SERVER="/var/www/pterodactyl/app/Services/Servers/ServerDeletionService.php"

    # Validate admin ID
    if [[ ! "$ADMIN_ID" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ User ID harus berupa angka.${RESET}"
        return 1
    fi

    echo -e "${YELLOW}➤ Menambahkan Protect Delete User...${RESET}"
    
    # Check if file exists
    if [ ! -f "$CONTROLLER_USER" ]; then
        echo -e "${RED}❌ File UserController tidak ditemukan.${RESET}"
        echo -e "${YELLOW}➤ Pastikan Pterodactyl sudah terinstall dengan benar.${RESET}"
        return 1
    fi
    
    # Create backup
    cp "$CONTROLLER_USER" "${CONTROLLER_USER}.bak"
    
    # Apply protection to UserController
    awk -v admin_id="$ADMIN_ID" -v version="$VERSION" '
    /public function delete\(Request \$request, User \$user\): RedirectResponse/ {
        print; in_func = 1; next;
    }
    in_func == 1 && /^\s*{/ {
        print;
        print "        if (\$request->user()->id !== " admin_id ") {";
        print "            throw new DisplayException(\"Lu Siapa Mau Delete User Lain Tolol? Izin Dulu Sama Id 1 Kalo Mau Delete©Protect By Zero - Protect V" version "\");";
        print "        }";
        in_func = 0; next;
    }
    { print }
    ' "${CONTROLLER_USER}.bak" > "$CONTROLLER_USER"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✔ Protect UserController selesai.${RESET}"
    else
        echo -e "${RED}❌ Gagal memproteksi UserController.${RESET}"
        return 1
    fi

    echo -e "${YELLOW}➤ Menambahkan Protect Delete Server...${RESET}"
    
    # Check if file exists
    if [ ! -f "$SERVICE_SERVER" ]; then
        echo -e "${RED}❌ File ServerDeletionService tidak ditemukan.${RESET}"
        echo -e "${YELLOW}➤ Pastikan Pterodactyl sudah terinstall dengan benar.${RESET}"
        return 1
    fi
    
    # Create backup
    cp "$SERVICE_SERVER" "${SERVICE_SERVER}.bak"
    
    # Add necessary imports if not already present
    if ! grep -q "use Illuminate\\Support\\Facades\\Auth;" "$SERVICE_SERVER"; then
        awk '
        BEGIN {
            added = 0
        }
        {
            print
            if (!added && $0 ~ /^namespace Pterodactyl\\Services\\Servers;/) {
                print "use Illuminate\\Support\\Facades\\Auth;"
                print "use Pterodactyl\\Exceptions\\DisplayException;"
                added = 1
            }
        }
        ' "$SERVICE_SERVER" > "$SERVICE_SERVER.tmp" && mv "$SERVICE_SERVER.tmp" "$SERVICE_SERVER"
    fi

    # Apply protection to ServerDeletionService
    awk -v admin_id="$ADMIN_ID" -v version="$VERSION" '
    /public function handle\(Server \$server\): void/ {
        print; in_func = 1; next;
    }
    in_func == 1 && /^\s*{/ {
        print;
        print "        \$user = Auth::user();";
        print "        if (\$user && \$user->id !== " admin_id ") {";
        print "            throw new DisplayException(\"Lu Siapa Mau Delete Server Lain Tolol? Izin Dulu Sama Id 1 Kalo Mau Delete©Protect By Zero - Protect V" version "\");";
        print "        }";
        in_func = 0; next;
    }
    { print }
    ' "$SERVICE_SERVER" > "${SERVICE_SERVER}.patched" && mv "${SERVICE_SERVER}.patched" "$SERVICE_SERVER"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✔ Protect ServerDeletionService selesai.${RESET}"
    else
        echo -e "${RED}❌ Gagal memproteksi ServerDeletionService.${RESET}"
        return 1
    fi

    echo -e "${YELLOW}➤ Install Node.js 20 dan build frontend panel...${RESET}"
    
    # Install Node.js 20
    echo -e "${YELLOW}➤ Update package manager...${RESET}"
    sudo apt-get update -y >/dev/null 2>&1
    
    echo -e "${YELLOW}➤ Remove existing Node.js...${RESET}"
    sudo apt-get remove nodejs -y >/dev/null 2>&1
    
    echo -e "${YELLOW}➤ Install Node.js 20...${RESET}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
    sudo apt-get install nodejs -y >/dev/null 2>&1

    # Build panel
    echo -e "${YELLOW}➤ Build panel...${RESET}"
    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; return 1; }

    npm i -g yarn >/dev/null 2>&1
    yarn add cross-env >/dev/null 2>&1
    yarn build:production --progress

    echo -e "${GREEN}🎉 Protect V$VERSION & Build Panel berhasil dipasang.${RESET}"
    echo -e "${YELLOW}➤ Protection telah aktif untuk User ID: $ADMIN_ID${RESET}"
    return 0
}

# Function to restore backup
restore_backup() {
    local CONTROLLER_USER="/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"
    local SERVICE_SERVER="/var/www/pterodactyl/app/Services/Servers/ServerDeletionService.php"

    echo -e "${YELLOW}♻ Memulihkan dari backup...${RESET}"
    
    # Restore UserController
    if [ -f "${CONTROLLER_USER}.bak" ]; then
        cp "${CONTROLLER_USER}.bak" "$CONTROLLER_USER"
        echo -e "${GREEN}✔ UserController dipulihkan.${RESET}"
    else
        echo -e "${RED}⚠ Backup UserController tidak ditemukan.${RESET}"
    fi

    # Restore ServerDeletionService
    if [ -f "${SERVICE_SERVER}.bak" ]; then
        cp "${SERVICE_SERVER}.bak" "$SERVICE_SERVER"
        echo -e "${GREEN}✔ ServerDeletionService dipulihkan.${RESET}"
    else
        echo -e "${RED}⚠ Backup ServerDeletionService tidak ditemukan.${RESET}"
    fi

    # Rebuild panel
    echo -e "${YELLOW}➤ Build ulang panel...${RESET}"
    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; return 1; }
    yarn build:production --progress

    echo -e "${GREEN}✅ Restore & build selesai.${RESET}"
    echo -e "${YELLOW}➤ Semua protection telah dihapus.${RESET}"
    return 0
}

# Function to run admin protection setup
admin_protection_setup() {
    echo -e "${YELLOW}➤ Menjalankan Admin Protection Setup...${RESET}"
    echo -e "${YELLOW}➤ Downloading script dari GitHub...${RESET}"
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}❌ curl tidak ditemukan. Install curl terlebih dahulu.${RESET}"
        echo -e "${YELLOW}➤ Jalankan: sudo apt-get install curl${RESET}"
        return 1
    fi
    
    # Download and execute the protection script
    bash <(curl -s https://raw.githubusercontent.com/KiwamiXq1031/installer-premium/main/protectadmin.sh)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Admin Protection Setup selesai.${RESET}"
    else
        echo -e "${RED}❌ Gagal menjalankan Admin Protection Setup.${RESET}"
    fi
}

# Function to handle option 1
handle_option1() {
    echo ""
    read -p "$(echo -e "${CYAN}Masukkan User ID Admin Utama (contoh: 1): ${RESET}")" ADMIN_ID
    
    # Validate input
    if [ -z "$ADMIN_ID" ]; then
        echo -e "${RED}❌ User ID tidak boleh kosong.${RESET}"
        return 1
    fi
    
    deploy_protection "$ADMIN_ID"
}

# Function to handle option 2
handle_option2() {
    echo -e "${YELLOW}⚠️  PERINGATAN: Ini akan menghapus semua protection dan mengembalikan ke state original.${RESET}"
    read -p "$(echo -e "${CYAN}Apakah Anda yakin ingin melanjutkan? (y/N): ${RESET}")" CONFIRM
    
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        restore_backup
    else
        echo -e "${YELLOW}➤ Restore dibatalkan.${RESET}"
    fi
}

# Function to handle option 3
handle_option3() {
    admin_protection_setup
}

# Main script execution
main() {
    display_header
    display_menu
    
    read -r OPSI
    
    case "$OPSI" in
        "1")
            handle_option1
            ;;
        "2")
            handle_option2
            ;;
        "3")
            handle_option3
            ;;
        *)
            echo -e "${RED}❌ Opsi tidak valid. Pilih 1, 2, atau 3.${RESET}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}${BOLD}    ┌────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}${BOLD}    │           🎉 SCRIPT SELESAI               │${RESET}"
    echo -e "${CYAN}${BOLD}    └────────────────────────────────────────────┘${RESET}"
    echo ""
}

# Run main function
main

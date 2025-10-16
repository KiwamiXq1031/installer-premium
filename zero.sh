#!/bin/bash

ADMIN_WHATSAPP_NUMBER="081997715124"

WHATSAPP_FILE="/var/whatsapp_number.txt"
LICENSE_FILE="/var/license.txt"
ERROR_FILE="/var/error_count.txt"

# Inisialisasi file kesalahan jika tidak ada
if [[ ! -f "$ERROR_FILE" ]]; then
    echo "0" > "$ERROR_FILE"
fi

# Definisi warna untuk tampilan teks
ORANGE='\033[33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
WHITE='\033[37m'
RESET='\033[0m'  # Reset warna teks ke default

save_config() {
    echo "DISABLE_ANIMATIONS=${DISABLE_ANIMATIONS}" > /var/www/pterodactyl/config/installer_config
}

load_config() {
    if [ -f /var/www/pterodactyl/config/installer_config ]; then
        source /var/www/pterodactyl/config/installer_config
    else
        DISABLE_ANIMATIONS=0
    fi
}

animate_text() {
    local text="$1"
    if [ "$DISABLE_ANIMATIONS" -eq 1 ]; then
        echo "$text"
    else
        for ((i=0; i<${#text}; i++)); do
            echo -en "${text:$i:1}"
        done
        echo ""
    fi
}

load_config

clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║                      __====-_  _-====__                           ║"
echo "║                _--^^^#####//      \#####^^^--_                    ║"
echo "║             _-^##########// (    ) \##########^-_                 ║"
echo "║            -############//  |\^^/|  \############-                ║"
echo "║          _/############//   (@::@)   \############\_              ║"
echo "║         /#############((     \\//     ))#############\             ║"
echo "║        -###############\\    (oo)    //###############-            ║"
echo "║       -#################\\  / VV \  //#################-           ║"
echo "║      -###################\\/      \//###################-          ║"
echo "║     _#/|##########/\######(   /\   )######/\##########|\#_         ║"
echo "║     |/ |#/\#/\#/\/  \#/\##\  |  |  /##/\#/  \/\#/\#/\#| \|         ║"
echo "║     '  |/  V  V  '   V  \#\| |  | |/#/  V   '  V  V  \|  '         ║"
echo "║        '   '  '      '   / | |  | | \   '      '  '   '            ║"
echo "║                         (  | |  | |  )                             ║"
echo "║                          \ | |  | | /                              ║"
echo "║                           \| |  | |/                               ║"
echo "║                            ' |  | '                                ║"
echo "║                              \__/                                  ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# Info Kontak
echo -e "${RED}${BOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║                    Developer Info                    ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${WHITE}OWNER  : ${ORANGE}ZERO-DEVELOPER"
echo -e "${WHITE}WHATSAPP: ${ORANGE}081997715124"
echo -e "${WHITE}TELEGRAM: ${ORANGE}t.me/ZerooHosting"
echo -e "${RED}© 2025 Zero Developer${RESET}"

# Tambahkan bagian lain dari skrip Anda di sini jika diperlukan
# Fungsi untuk menampilkan animasi loading
loading_animation() {
    local spinstr='|/-\'
    local loading_text="LOADING..."
    local i=0
    while [ $i -lt ${#loading_text} ]; do
        local temp=${spinstr#?}
        printf " [%c] %s" "$spinstr" "${loading_text:0:i+1}"
        local spinstr=$temp${spinstr%"$temp"}
        printf "\r"
        i=$((i + 1))
    done
    printf "\r\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}

# Fungsi untuk menampilkan teks animasi
animate_text() {
    local text=$1
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
    done
    echo ""
}

# Menampilkan teks dengan animasi
echo -e "${BLUE}(𝗔𝗨𝗧𝗢𝗠𝗔𝗧𝗜𝗖) 𝖫ICENSE ANDA BENAR, TERIMAKASIH TELAH MEMBELI LICENSE INI YA${RESET}"
animate_text "OPSI ADA DIBAWAH INI"
# Fungsi untuk menampilkan animasi loading
loading_animation() {
    local spinstr='|/-\'
    local loading_text="LOADING"
    local i=0
    while [ $i -lt ${#loading_text} ]; do
        local temp=${spinstr#?}
        printf " [%c] %s" "$spinstr" "${loading_text:0:i+1}"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
        i=$((i + 1))
    done
    printf "\r\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}

# Animasi loading dan menghapus
loading_animation
echo -ne "\033[K"  # Menghapus teks loading dari baris

clear
echo -e "${CYAN}${BOLD}"
echo "──────────────────────────────────────────────"
echo "         ⚙️  PTERODACTYL THEME INSTALLER"
echo "──────────────────────────────────────────────${RESET}"
echo
echo -e "${WHITE}${BOLD}THEME (FILES)${RESET}"
echo -e "${GREEN}1.${RESET} INSTALL THEME ELYSIUM PTERODACTYL"
echo -e "${GREEN}2. INSTALL THEME STELLAR"
echo -e "${GREEN}3. INSTALL THEME BILLING"
echo
echo -e "${WHITE}${BOLD}THEME (PLUGINS)${RESET}"
echo -e "${GREEN}4.${RESET} INSTALL NEBULA THEME PTERODACTYL"
echo -e "${GREEN}5.${RESET} ADMIN PANEL THEME PTERODACTYL"
echo
echo -e "${WHITE}${BOLD}ADDON (FILES)${RESET}"
echo -e "${GREEN}6.${RESET} INSTALL ADDON AUTO SUSPEND PTERODACTYL"
echo -e "${GREEN}7.${RESET} INSTALL GOOGLE ANALYTIC PTERODACTYL"
echo
echo -e "${WHITE}${BOLD}THEME (REMAKE)${RESET}"
echo -e "${GREEN}8.${RESET} ENIGMA PREMIUM PTERODACTYL REMAKE BY RAINSTOREID"
echo
echo -e "${WHITE}${BOLD}PTERODACTYL (EDIT)${RESET}"
echo -e "${GREEN}9.${RESET} UBAH BACKGROUND PTERODACTYL"
echo -e "${GREEN}10.${RESET} HAPUS BACKGROUND PTERODACTYL (RESET KE DEFAULT)"
echo -e "${GREEN}11.${RESET} HAPUS THEME / ADDON"
echo
echo -e "${WHITE}${BOLD}ADDON (PLUGINS)${RESET}"
echo -e "${GREEN}12.${RESET} COOKIES PTERODACTYL"
echo
echo -e "${WHITE}${BOLD}INSTALL DEPEND (PLUGINS)${RESET}"
echo -e "${GREEN}13.${RESET} INSTALL DEPEND ADDON / THEME PLUGINS"
echo
echo -e "${WHITE}${BOLD}INSTALLER${RESET}"
echo -e "${GREEN}14.${RESET} MATIKAN SEMUA ANIMASI INSTALLER"
echo -e "${GREEN}15.${RESET} KELUAR DARI INSTALLER"
echo
echo -e "${WHITE}${BOLD}DELETE THEME / ADDON (PLUGINS)${RESET}"
echo -e "${GREEN}16.${RESET} DELETE THEME NEBULA"
echo -e "${GREEN}17.${RESET} DELETE THEME SLATE"
echo -e "${GREEN}18.${RESET} DELETE THEME COOKIES"
echo
echo -e "${WHITE}${BOLD}PROTECT PTERODACTYL${RESET}"
echo -e "${GREEN}19.${RESET} PASANG PROTECT & BUILD PANEL"
echo -e "${GREEN}20.${RESET} RESTORE DARI BACKUP DAN BUILD"
echo -e "${GREEN}21.${RESET} INSTALL PROTECT"
echo -e "${GREEN}22.${RESET} RESTORE"
echo -e "${YELLOW}${BOLD}──────────────────────────────────────────────${RESET}"
read -p "$(echo -e "${CYAN}${BOLD}PILIH OPSI (1-20): ${RESET}")" OPTION
case "$OPTION" in
     1)
        GITHUB_TOKEN="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"
        REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
        TEMP_DIR="installer-premium"

        git clone "https://${GITHUB_TOKEN}@github.com/KiwamiXq1031/installer-premium.git" "$TEMP_DIR"

        sudo mv "$TEMP_DIR/ElysiumTheme.zip" /var/www/
        unzip -o /var/www/ElysiumTheme.zip -d /var/www/
        rm -rf "$TEMP_DIR"
        rm -f /var/www/ElysiumTheme.zip

        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null

        sudo apt update -y
        sudo apt install -y nodejs npm
        sudo npm install -g yarn

        cd /var/www/pterodactyl || exit
        yarn
        yarn build:production
        php artisan migrate --force
        php artisan view:clear
        animate_text "Tema Elysium berhasil diinstal."
        ;;
     2)
        clear
        echo -e "${BLUE}[+] =============================================== [+]${NC}"
        echo -e "${BLUE}[+]        INSTALL THEME PTERODACTYL - STELLAR      [+]${NC}"
        echo -e "${BLUE}[+] =============================================== [+]${NC}"

        THEME_NAME="stellar"
        THEME_URL="https://github.com/KiwamiXq1031/installer-premium/raw/main/${THEME_NAME}.zip"

        echo -e "${YELLOW}🔽 Mengunduh theme Stellar...${NC}"
        wget -q -O "/root/${THEME_NAME}.zip" "$THEME_URL" || { echo -e "${RED}❌ Gagal mengunduh theme.${NC}"; exit 1; }

        echo -e "${YELLOW}📦 Mengekstrak file...${NC}"
        unzip -oq "/root/${THEME_NAME}.zip" -d /root/pterodactyl

        echo -e "${YELLOW}📁 Menyalin file ke direktori Pterodactyl...${NC}"
        sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

        echo -e "${YELLOW}⚙️ Menginstal Node.js v20 & Yarn...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install -y nodejs
        sudo npm install -g yarn

        cd /var/www/pterodactyl || { echo -e "${RED}❌ Direktori tidak ditemukan!${NC}"; exit 1; }

        echo -e "${YELLOW}🔧 Menjalankan migrasi dan build...${NC}"
        yarn add react-feather
        php artisan migrate --force
        yarn build:production
        php artisan view:clear

        echo -e "${YELLOW}🧹 Membersihkan file sementara...${NC}"
        rm -f "/root/${THEME_NAME}.zip"
        rm -rf /root/pterodactyl

        echo -e "${GREEN}✅ Theme Stellar berhasil diinstall menggunakan Node.js v20!${NC}"
        ;;
     3)
        clear
        echo -e "${BLUE}[+] =============================================== [+]${NC}"
        echo -e "${BLUE}[+]            INSTALL THEME PTERODACTYL - BILLING  [+]${NC}"
        echo -e "${BLUE}[+] =============================================== [+]${NC}"

        THEME_NAME="billing"
        THEME_URL="https://github.com/KiwamiXq1031/installer-premium/raw/main/${THEME_NAME}.zip"

        echo -e "${YELLOW}🔽 Mengunduh theme Billing...${NC}"
        wget -q -O "/root/${THEME_NAME}.zip" "$THEME_URL" || { echo -e "${RED}❌ Gagal mengunduh theme.${NC}"; exit 1; }

        echo -e "${YELLOW}📦 Mengekstrak file...${NC}"
        unzip -oq "/root/${THEME_NAME}.zip" -d /root/pterodactyl

        echo -e "${YELLOW}📁 Menyalin file ke direktori Pterodactyl...${NC}"
        sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

        echo -e "${YELLOW}⚙️ Menginstal Node.js v20 & Yarn...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install -y nodejs
        sudo npm install -g yarn

        cd /var/www/pterodactyl || { echo -e "${RED}❌ Direktori tidak ditemukan!${NC}"; exit 1; }

        echo -e "${YELLOW}🔧 Menjalankan migrasi dan build...${NC}"
        yarn add react-feather
        php artisan migrate --force
        yarn build:production
        php artisan view:clear

        echo -e "${YELLOW}🧹 Membersihkan file sementara...${NC}"
        rm -f "/root/${THEME_NAME}.zip"
        rm -rf /root/pterodactyl

        echo -e "${GREEN}✅ Theme Billing berhasil diinstall menggunakan Node.js v20!${NC}"
        ;;
     4)
        cd /var/www
        BLUEPRINT_FILE="/var/www/pterodactyl/blueprint.sh"
        if [ ! -f "$BLUEPRINT_FILE" ]; then
            echo "𝗗𝗘𝗣𝗘𝗡𝗗 𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗕𝗘𝗟𝗨𝗠 𝗗𝗜𝗜𝗡𝗦𝗧𝗔𝗟 𝗦𝗜𝗟𝗔𝗛𝗞𝗔𝗡 𝗜𝗡𝗦𝗧𝗔𝗟𝗟 𝗧𝗘𝗥𝗟𝗘𝗕𝗜𝗛 𝗗𝗔𝗛𝗨𝗟𝗨 𝗗𝗘𝗡𝗚𝗔𝗡 𝗠𝗘𝗠𝗜𝗟𝗜𝗛 𝗢𝗣𝗦𝗜 𝗡𝗢 𝟭𝟭"
            exit 1
        fi

        GITHUB_TOKEN="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"
        REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
        TEMP_DIR="installer-premium"

        git clone "https://${GITHUB_TOKEN}@github.com/KiwamiXq1031/installer-premium.git" "$TEMP_DIR"

        sudo mv "$TEMP_DIR/nebulaptero.zip" /var/www/
        unzip -o /var/www/nebulaptero.zip -d /var/www/
        cd /var/www/pterodactyl || exit
        bash blueprint.sh -install nebula

        cd /var/www
        rm -rf "$TEMP_DIR"
        rm -f nebulaptero.zip
        cd /var/www/pterodactyl
        rm -f nebula.blueprint

        animate_text "NEBULA THEME BERHASIL DIINSTALL"
        ;;
     5)
        cd /var/www
        BLUEPRINT_FILE="/var/www/pterodactyl/blueprint.sh"
        if [ ! -f "$BLUEPRINT_FILE" ]; then
            echo "𝗗𝗘𝗣𝗘𝗡𝗗 𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗕𝗘𝗟𝗨𝗠 𝗗𝗜𝗜𝗡𝗦𝗧𝗔𝗟 𝗦𝗜𝗟𝗔𝗛𝗞𝗔𝗡 𝗜𝗡𝗦𝗧𝗔𝗟𝗟 𝗧𝗘𝗥𝗟𝗘𝗕𝗜𝗛 𝗗𝗔𝗛𝗨𝗟𝗨 𝗗𝗘𝗡𝗚𝗔𝗡 𝗠𝗘𝗠𝗜𝗟𝗜𝗛 𝗢𝗣𝗦𝗜 𝗡𝗢 𝟭𝟭"
            exit 1
        fi

        GITHUB_TOKEN="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"
        REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
        TEMP_DIR="installer-premium"

        git clone "https://${GITHUB_TOKEN}@github.com/KiwamiXq1031/installer-premium.git" "$TEMP_DIR"

        sudo mv "$TEMP_DIR/Slate-v1.0.zip" /var/www/
        unzip -o /var/www/Slate-v1.0.zip -d /var/www/
        cd /var/www/pterodactyl || exit
        bash blueprint.sh -install slate

        cd /var/www
        rm -rf "$TEMP_DIR"
        rm -f Slate-v1.0.zip

        FILE_URL="https://github.com/KiwamiXq1031/installer-premium/raw/main/Slate-v1.0.zip"
        DESTINATION="/var/www/pterodactyl/Slate-v1.0.zip"

        curl -H "Authorization: Bearer ${GITHUB_TOKEN}" -L -o "${DESTINATION}" "${FILE_URL}" > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            animate_text "File berhasil diunduh ke ${DESTINATION}"
        else
            animate_text "Gagal mengunduh file"
        fi

        animate_text "ADMIN PANEL THEME BERHASIL DIINSTALL"
        ;;
        
             6)
        GITHUB_TOKEN="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"
        REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
        TEMP_DIR="installer-premium"

        git clone "https://${GITHUB_TOKEN}@github.com/KiwamiXq1031/installer-premium.git" "$TEMP_DIR"

        sudo mv "$TEMP_DIR/autosuspens.zip" /var/www/
        unzip -o /var/www/autosuspens.zip -d /var/www/
        rm -rf "$TEMP_DIR"
        rm -f /var/www/autosuspens.zip
        
        cd /var/www/pterodactyl || exit
        bash installer.bash
        animate_text "AUTO SUSPEND BERHASIL DIINSTALL"

        FILE_URL="https://github.com/KiwamiXq1031/installer-premium/raw/main/autosuspens.zip"
        DESTINATION="/var/www/pterodactyl/autosuspens.zip"

        curl -H "Authorization: Bearer ${GITHUB_TOKEN}" -L -o "${DESTINATION}" "${FILE_URL}"

        if [ $? -eq 0 ]; then
            animate_text "File berhasil diunduh ke ${DESTINATION}"
        else
            animate_text "Gagal mengunduh file"
        fi
        ;;
     7)
    # Token GitHub pribadi (pastikan token valid dan punya akses repo)
    GITHUB_TOKEN="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"

    # URL repo dan folder sementara
    REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
    TEMP_DIR="installer-premium"

    echo -e "${BLUE}🔄 Mengunduh addon Google Analytics dari GitHub...${RESET}"
    git clone "$REPO_URL" "$TEMP_DIR" || {
        echo -e "${RED}❌ Gagal mengkloning repository.${RESET}"
        exit 1
    }

    # Pindahkan dan ekstrak file
    sudo mv "$TEMP_DIR/googleanalitic.zip" /var/www/
    unzip -o /var/www/googleanalitic.zip -d /var/www/ >/dev/null 2>&1
    rm -rf "$TEMP_DIR" /var/www/googleanalitic.zip

    # Setup Node.js dan Yarn
    echo -e "${BLUE}⚙️ Menginstal Node.js 20.x dan Yarn...${RESET}"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | \
        sudo tee /etc/apt/sources.list.d/nodesource.list

    sudo apt update -y
    sudo apt install -y nodejs npm
    npm install -g yarn

    # Build ulang panel
    cd /var/www/pterodactyl || exit
    yarn install
    yarn build:production

    echo -e "${BLUE}⚙️ Menjalankan Artisan Command...${RESET}"
    php artisan migrate --force
    php artisan view:clear

    echo -e "${GREEN}✅ Addon Google Analytics berhasil diinstal!${RESET}"

    # Unduh file tambahan dari GitHub pakai header Authorization Bearer
    FILE_URL="https://raw.githubusercontent.com/KiwamiXq1031/installer-premium/main/addons/googleanalytic/config.json"
    DESTINATION="/var/www/pterodactyl/config/googleanalytic.json"

    echo -e "${BLUE}📦 Mengunduh file konfigurasi tambahan...${RESET}"
    curl -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3.raw" \
         -L -o "${DESTINATION}" "${FILE_URL}"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File berhasil diunduh ke ${DESTINATION}${RESET}"
    else
        echo -e "${RED}❌ Gagal mengunduh file konfigurasi.${RESET}"
    fi
    ;;

     8)

# Fungsi untuk menampilkan animasi loading
show_loading() {
    echo -n "[-] LOADING"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo ""
}

# Menampilkan animasi loading saat skrip dimulai
show_loading

# Nomor lama yang akan digunakan secara otomatis
nomor_lama="081997715124"
echo -e "${BLUE}JIKA ADA PILIHAN SILAHKAN KETIK y${RESET}"

# Persiapan environment
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | \
    sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update -y
sudo apt-get install -y nodejs npm zip unzip git curl wget
npm i -g yarn

# Build ulang Pterodactyl panel
cd /var/www/pterodactyl || exit
yarn
cd /var/www/ || exit

# Masukkan token GitHub (gunakan ghp_)
GITHUB_TOKEN="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"

# Clone repositori menggunakan token
REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
TEMP_DIR="installer-premium"

echo "[-] Mengkloning repositori dari GitHub..."
git clone "https://${GITHUB_TOKEN}@github.com/KiwamiXq1031/installer-premium.git" "$TEMP_DIR"

# Pindahkan dan ekstrak file zip
cd "$TEMP_DIR" || exit
sudo mv enigmarimake.zip /var/www/
cd /var/www/ || exit

unzip -o enigmarimake.zip -d /var/www/
rm -rf "$TEMP_DIR" enigmarimake.zip

# Build ulang panel
cd /var/www/pterodactyl || exit
npx update-browserslist-db@latest
yarn build:production

echo ""
echo -e "${GREEN}PROSES SELESAI ✅${RESET}"
;;
     9)
# Default URL gambar
DEFAULT_URL="https://i.postimg.cc/s2wGzpHs/zerodev.jpg"

# Input URL manual
read -p "Masukkan URL gambar (tekan Enter untuk menggunakan URL default): " USER_URL

# Gunakan default kalau kosong
if [ -z "$USER_URL" ]; then
    URL="$DEFAULT_URL"
else
    URL="$USER_URL"
fi

# Pindah ke direktori template Pterodactyl
cd /var/www/pterodactyl/resources/views/templates || exit

# Backup dulu sebelum ubah
cp wrapper.blade.php wrapper_backup_$(date +"%Y%m%d%H%M%S").blade.php

# Buat file baru dengan HTML + CSS full
{
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '    <meta charset="UTF-8">'
  echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
  echo '    <title>Pterodactyl Background</title>'
  echo '    <style>'
  echo '        * { margin: 0; padding: 0; box-sizing: border-box; }'
  echo "        body {"
  echo "            background-image: url('$URL');"
  echo '            background-size: cover;'
  echo '            background-repeat: no-repeat;'
  echo '            background-attachment: fixed;'
  echo '            height: 100vh;'
  echo '            width: 100vw;'
  echo '        }'
  echo '    </style>'
  echo '</head>'
  echo '<body>'
  echo '    <!-- Template original dimulai di bawah -->'
  cat wrapper.blade.php
  echo '</body>'
  echo '</html>'
} > /tmp/new_wrapper.blade.php

# Timpa file lama
mv /tmp/new_wrapper.blade.php wrapper.blade.php

echo "BACKGROUND BERHASIL DIGANTI ✅"
;;
10)
# Path ke file wrapper Pterodactyl
file_path="/var/www/pterodactyl/resources/views/templates/wrapper.blade.php"

# Pastikan direktori ada
if [ ! -f "$file_path" ]; then
    echo "File wrapper.blade.php tidak ditemukan!"
    exit 1
fi

# Ganti isi file wrapper.blade.php dengan template asli bawaan Pterodactyl
cat << 'EOF' > "$file_path"
<!DOCTYPE html>
<html>
    <head>
        <title>{{ config('app.name', 'Pterodactyl') }}</title>

        @section('meta')
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
            <meta name="csrf-token" content="{{ csrf_token() }}">
            <meta name="robots" content="noindex">
            <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png">
            <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32">
            <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16">
            <link rel="manifest" href="/favicons/manifest.json">
            <link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#bc6e3c">
            <link rel="shortcut icon" href="/favicons/favicon.ico">
            <meta name="msapplication-config" content="/favicons/browserconfig.xml">
            <meta name="theme-color" content="#0e4688">
        @show

        @section('user-data')
            @if(!is_null(Auth::user()))
                <script>
                    window.PterodactylUser = {!! json_encode(Auth::user()->toVueObject()) !!};
                </script>
            @endif
            @if(!empty($siteConfiguration))
                <script>
                    window.SiteConfiguration = {!! json_encode($siteConfiguration) !!};
                </script>
            @endif
        @show
        <style>
            @import url('//fonts.googleapis.com/css?family=Rubik:300,400,500&display=swap');
            @import url('//fonts.googleapis.com/css?family=IBM+Plex+Mono|IBM+Plex+Sans:500&display=swap');
        </style>

        @yield('assets')
        @include('layouts.scripts')

        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id={{ config('app.google_analytics', 'Pterodactyl') }}"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '{{ config('app.google_analytics', 'Pterodactyl') }}');
        </script>
    </head>
    <body class="{{ $css['body'] ?? 'bg-neutral-50' }}">
        @section('content')
            @yield('above-container')
            @yield('container')
            @yield('below-container')
        @show
        @section('scripts')
            {!! $asset->js('main.js') !!}
        @show
    </body>
</html>
EOF

if [ $? -eq 0 ]; then
    echo "BACKGROUND BERHASIL DIHAPUS ✅"
else
    echo "GAGAL MENGGANTI FILE! Hubungi 081997715124 untuk bantuan."
fi
;;

    11)
echo "🧹 Menghapus semua theme dan addon..."
cd /var/www/pterodactyl || exit 1

# Maintenance mode
php artisan down

# Ambil panel versi terbaru langsung dari GitHub Pterodactyl
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

# Set izin file dan cache
chmod -R 755 storage/* bootstrap/cache
composer install --no-dev --optimize-autoloader

php artisan view:clear
php artisan config:clear
php artisan migrate --seed --force

# Reset permission
chown -R www-data:www-data /var/www/pterodactyl/*

# Kembali online
php artisan up

echo "✅ Semua theme dan addon berhasil dihapus dan panel telah dipulihkan ke versi original."
;;
    
12)
cd /var/www/ || exit

# Ngecek dependensi blueprint
BLUEPRINT_FILE="/var/www/pterodactyl/blueprint.sh"
if [ ! -f "$BLUEPRINT_FILE" ]; then
    echo -e "❌ 𝗗𝗘𝗣𝗘𝗡𝗗 𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗕𝗘𝗟𝗨𝗠 𝗗𝗜𝗜𝗡𝗦𝗧𝗔𝗟.\n👉 Silakan install dulu lewat opsi nomor 11."
    exit 1
fi

# Supaya script stop kalau ada error
set -e

# Token GitHub pribadi
GITHUB_TOKEN="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"

# Repo dan direktori sementara
REPO_URL="https://github.com/KiwamiXq1031/installer-premium.git"
TEMP_DIR="installer-premium"

echo -e "🔄 Mengunduh addon Cookies dari GitHub..."
git clone "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1 || {
    echo -e "❌ Gagal mengkloning repository."
    exit 1
}

# Pindahkan dan ekstrak zip
sudo mv "$TEMP_DIR/cookies.zip" /var/www/pterodactyl/
unzip -o /var/www/pterodactyl/cookies.zip -d /var/www/pterodactyl/ >/dev/null 2>&1

# Install addon cookies
cd /var/www/pterodactyl || exit
bash blueprint.sh -install cookies >/dev/null 2>&1 || {
    echo -e "⚠️  Gagal menjalankan blueprint install cookies."
    exit 1
}

# Bersih-bersih file sisa
rm -rf /var/www/installer-premium \
       /var/www/pterodactyl/cookies.zip \
       /var/www/pterodactyl/cookies.blueprint

echo -e "✅ ADDON COOKIES BERHASIL DIINSTAL"

# Unduh file tambahan dari GitHub (jika ada)
FILE_URL="https://raw.githubusercontent.com/KiwamiXq1031/installer-premium/main/addons/cookies/config.json"
DESTINATION="/var/www/pterodactyl/config/cookies.json"

echo -e "📦 Mengunduh file konfigurasi tambahan..."
curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3.raw" \
         -L -o "${DESTINATION}" "${FILE_URL}"

if [ $? -eq 0 ]; then
    echo -e "✅ File berhasil diunduh ke ${DESTINATION}"
else
    echo -e "❌ Gagal mengunduh file konfigurasi tambahan."
fi
;;
13)
set -e

echo -e "🔧 Menginstal dependensi dasar..."
sudo apt-get install -y ca-certificates curl gnupg unzip zip git wget >/dev/null 2>&1

echo -e "📦 Menambahkan repository Node.js 20.x..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg >/dev/null 2>&1
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
  | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null

sudo apt-get update -y >/dev/null
sudo apt-get install -y nodejs >/dev/null 2>&1

echo -e "⚙️  Menginstal Yarn dan dependensi proyek..."
npm install -g yarn >/dev/null 2>&1
cd /var/www/pterodactyl || { echo "❌ Direktori Pterodactyl tidak ditemukan!"; exit 1; }
yarn >/dev/null 2>&1
yarn add cross-env >/dev/null 2>&1

echo -e "🌐 Mengunduh Blueprint Framework versi terbaru..."
LATEST_URL=$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest \
  | grep 'browser_download_url' | cut -d '"' -f 4 | head -n 1)

if [ -z "$LATEST_URL" ]; then
    echo "❌ Gagal mengambil URL rilis terbaru dari GitHub."
    exit 1
fi

wget "$LATEST_URL" -O /var/www/pterodactyl/release.zip >/dev/null 2>&1
cd /var/www/pterodactyl

echo -e "📂 Mengekstrak Blueprint Framework..."
unzip -o release.zip >/dev/null 2>&1
rm -f release.zip

# Menentukan variabel untuk konfigurasi
WEBUSER="www-data"
USERSHELL="/bin/bash"
PERMISSIONS="www-data:www-data"
FOLDER="/var/www/pterodactyl"

# Pastikan file blueprint.sh ada
if [ ! -f "$FOLDER/blueprint.sh" ]; then
    echo "❌ File blueprint.sh tidak ditemukan setelah ekstraksi!"
    exit 1
fi

echo -e "🧩 Mengatur konfigurasi blueprint.sh..."
sed -i -E \
    -e "s|WEBUSER=\"www-data\" #;|WEBUSER=\"$WEBUSER\" #;|g" \
    -e "s|USERSHELL=\"/bin/bash\" #;|USERSHELL=\"$USERSHELL\" #;|g" \
    -e "s|OWNERSHIP=\"www-data:www-data\" #;|OWNERSHIP=\"$PERMISSIONS\" #;|g" \
    "$FOLDER/blueprint.sh"

chmod +x "$FOLDER/blueprint.sh"

echo -e "🚀 Menjalankan Blueprint Framework..."
bash "$FOLDER/blueprint.sh" >/dev/null 2>&1 || {
    echo "⚠️  Blueprint berhasil diinstal, tapi terjadi peringatan saat eksekusi."
}

echo -e "✅ Blueprint Framework berhasil diinstal dan dikonfigurasi!"
;;
    14)
        DISABLE_ANIMATIONS=1
        save_config
        echo -e "${YELLOW}Semua animasi telah dimatikan.${RESET}"
        ;;
    15)
        echo -e "${BLUE}EXIT DARI INSTALLER DIPILIH${RESET}"
        exit 0
        ;;
     16)
# Navigasi ke direktori extensions
cd /var/www/pterodactyl/public/extensions

# Cek jumlah file di direktori extensions
file_count=$(ls | wc -l)

# Jika jumlah file tepat 2, tampilkan peringatan dan hentikan proses
if [ "$file_count" -eq 2 ]; then
    echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗧𝗘𝗥𝗦𝗜𝗦𝗔 𝟭 𝗕𝗜𝗔𝗥 𝗧𝗜𝗗𝗔𝗞 𝗘𝗥𝗥𝗢𝗥 𝗜𝗡𝗜 𝗗𝗜𝗕𝗔𝗧𝗔𝗟𝗞𝗔𝗡"
    exit 1
else
    # Cek apakah direktori nebula ada
    if [ -d "nebula" ]; then
        # Jika folder nebula ada, navigasi ke folder tersebut dan hapus nebula
        cd nebula
        
        # Jalankan command untuk menghapus nebula
        blueprint -remove nebula
        echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗡𝗘𝗕𝗨𝗟𝗔 𝗧𝗘𝗥𝗛𝗔𝗣𝗨𝗦"
    else
        # Jika folder nebula tidak ada, tampilkan peringatan
        echo "𝗧𝗛𝗘𝗠𝗘 𝗡𝗘𝗕𝗨𝗟𝗔 𝗧𝗜𝗗𝗔𝗞 𝗧𝗘𝗥𝗜𝗡𝗦𝗧𝗔𝗟"
    fi
fi
       ;;
17)
# Navigasi ke direktori extensions
cd /var/www/pterodactyl/public/extensions

# Cek jumlah file di direktori extensions
file_count=$(ls | wc -l)

# Jika jumlah file tepat 2, tampilkan peringatan dan hentikan proses
if [ "$file_count" -eq 2 ]; then
    echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗧𝗘𝗥𝗦𝗜𝗦𝗔 𝟭 𝗕𝗜𝗔𝗥 𝗧𝗜𝗗𝗔𝗞 𝗘𝗥𝗥𝗢𝗥 𝗜𝗡𝗜 𝗗𝗜𝗕𝗔𝗧𝗔𝗟𝗞𝗔𝗡"
    exit 1
else
    # Cek apakah direktori nebula ada
    if [ -d "slate" ]; then
        # Jika folder nebula ada, navigasi ke folder tersebut dan hapus nebula
        cd slate
        
        # Jalankan command untuk menghapus nebula
        blueprint -remove slate
        echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦  𝗧𝗘𝗥𝗛𝗔𝗣𝗨𝗦"
    else
        # Jika folder nebula tidak ada, tampilkan peringatan
        echo "𝗧𝗛𝗘𝗠𝗘 𝗧𝗜𝗗𝗔𝗞 𝗧𝗘𝗥𝗜𝗡𝗦𝗧𝗔𝗟"
    fi
fi
;;
18)
# Navigasi ke direktori extensions
cd /var/www/pterodactyl/public/extensions

# Cek jumlah file di direktori extensions
file_count=$(ls | wc -l)

# Jika jumlah file tepat 2, tampilkan peringatan dan hentikan proses
if [ "$file_count" -eq 2 ]; then
    echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗧𝗘𝗥𝗦𝗜𝗦𝗔 𝟭 𝗕𝗜𝗔𝗥 𝗧𝗜𝗗𝗔𝗞 𝗘𝗥𝗥𝗢𝗥 𝗜𝗡𝗜 𝗗𝗜𝗕𝗔𝗧𝗔𝗟𝗞𝗔𝗡"
    exit 1
else
    # Cek apakah direktori nebula ada
    if [ -d "cookies" ]; then
        # Jika folder nebula ada
        cd cookies
        
        # Jalankan command untuk menghapus 
        blueprint -remove cookies
        echo "𝗣𝗟𝗨𝗚𝗜𝗡𝗦 𝗧𝗘𝗥𝗛𝗔𝗣𝗨𝗦"
    else
        # Jika folder tidak ada, tampilkan peringatan
        echo "𝗧𝗛𝗘𝗠𝗘 𝗧𝗜𝗗𝗔𝗞 𝗧𝗘𝗥𝗜𝗡𝗦𝗧𝗔𝗟"
    fi
fi
;;
19)
# Pastikan variabel penting terisi
if [ -z "$CONTROLLER_USER" ] || [ -z "$SERVICE_SERVER" ]; then
    echo -e "${RED}❌ Variabel CONTROLLER_USER atau SERVICE_SERVER belum diatur.${RESET}"
    exit 1
fi

read -p "$(echo -e "${CYAN}Masukkan User ID Admin Utama (contoh: 1): ${RESET}")" ADMIN_ID
[ -z "$ADMIN_ID" ] && echo -e "${RED}❌ User ID tidak boleh kosong.${RESET}" && exit 1

VERSION=${VERSION:-1.0.0}

echo -e "${YELLOW}➤ Menambahkan Protect Delete User...${RESET}"
if [ ! -f "$CONTROLLER_USER" ]; then
    echo -e "${RED}❌ File ${CONTROLLER_USER} tidak ditemukan.${RESET}"
    exit 1
fi

cp "$CONTROLLER_USER" "${CONTROLLER_USER}.bak"

awk -v admin_id="$ADMIN_ID" -v version="$VERSION" '
/public function delete\(Request \$request, User \$user\): RedirectResponse/ {
    print; in_func = 1; next;
}
in_func == 1 && /^\s*{/ {
    print;
    print "        if ($request->user()->id !== " admin_id ") {";
    print "            throw new DisplayException(\"Lu Siapa Mau Delet User Lain Tolol? Izin dulu sama ID 1 kalo mau delet. ©Protect By Zero - Protect V" version "\");";
    print "        }";
    in_func = 0; next;
}
{ print }
' "${CONTROLLER_USER}.bak" > "$CONTROLLER_USER"

echo -e "${GREEN}✔ Protect UserController selesai.${RESET}"


echo -e "${YELLOW}➤ Menambahkan Protect Delete Server...${RESET}"
if [ ! -f "$SERVICE_SERVER" ]; then
    echo -e "${RED}❌ File ${SERVICE_SERVER} tidak ditemukan.${RESET}"
    exit 1
fi

cp "$SERVICE_SERVER" "${SERVICE_SERVER}.bak"

# Tambah use statement jika belum ada
awk '
BEGIN { added = 0 }
{
    print
    if (!added && $0 ~ /^namespace Pterodactyl\\Services\\Servers;/) {
        print "use Illuminate\\Support\\Facades\\Auth;"
        print "use Pterodactyl\\Exceptions\\DisplayException;"
        added = 1
    }
}
' "$SERVICE_SERVER" > "$SERVICE_SERVER.tmp" && mv "$SERVICE_SERVER.tmp" "$SERVICE_SERVER"

# Tambah logika protect ke fungsi handle()
awk -v admin_id="$ADMIN_ID" -v version="$VERSION" '
/public function handle\(Server \$server\): void/ {
    print; in_func = 1; next;
}
in_func == 1 && /^\s*{/ {
    print;
    print "        $user = Auth::user();";
    print "        if ($user && $user->id !== " admin_id ") {";
    print "            throw new DisplayException(\"Lu Siapa Mau Delet Server Lain Tolol? Izin dulu sama ID 1 kalo mau delet. ©Protect By Zero - Protect V" version "\");";
    print "        }";
    in_func = 0; next;
}
{ print }
' "$SERVICE_SERVER" > "${SERVICE_SERVER}.patched" && mv "${SERVICE_SERVER}.patched" "$SERVICE_SERVER"

echo -e "${GREEN}✔ Protect ServerDeletionService selesai.${RESET}"


echo -e "${YELLOW}➤ Install Node.js 20 & build ulang frontend panel...${RESET}"
sudo apt-get update -y >/dev/null 2>&1
sudo apt-get remove nodejs -y >/dev/null 2>&1
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
sudo apt-get install -y nodejs >/dev/null 2>&1

cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

npm i -g yarn >/dev/null 2>&1
yarn add cross-env >/dev/null 2>&1
yarn build:production --progress

echo -e "${GREEN}🎉 Protect V${VERSION} & Build Panel berhasil dipasang.${RESET}"
;;
20)
    echo -e "${YELLOW}♻ Memulihkan dari backup...${RESET}"

    [ -f "${CONTROLLER_USER}.bak" ] && cp "${CONTROLLER_USER}.bak" "$CONTROLLER_USER" && \
        echo -e "${GREEN}✔ UserController dipulihkan.${RESET}" || \
        echo -e "${RED}⚠ Backup UserController tidak ditemukan.${RESET}"

    [ -f "${SERVICE_SERVER}.bak" ] && cp "${SERVICE_SERVER}.bak" "$SERVICE_SERVER" && \
        echo -e "${GREEN}✔ ServerDeletionService dipulihkan.${RESET}" || \
        echo -e "${RED}⚠ Backup ServerDeletionService tidak ditemukan.${RESET}"

    echo -e "${YELLOW}➤ Build ulang panel...${RESET}"
    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "${GREEN}✅ Restore & build selesai.${RESET}"
    ;;
    21)
    read -p "$(echo -e "${CYAN}👤 Masukkan ID Admin Utama (contoh: 1): ${RESET}")" ADMIN_ID
    if [[ -z "$ADMIN_ID" ]]; then
        echo -e "${RED}❌ Admin ID tidak boleh kosong.${RESET}"
        exit 1
    fi

    mkdir -p "$BACKUP_DIR"

    echo -e "${YELLOW}📦 Membackup file asli sebelum di-protect ke: ${BLUE}$BACKUP_DIR${RESET}"
    for name in "${!CONTROLLERS[@]}"; do
        if [ -f "${CONTROLLERS[$name]}" ]; then
            cp "${CONTROLLERS[$name]}" "$BACKUP_DIR/$name.bak"
        else
            echo -e "${RED}⚠️ File ${CONTROLLERS[$name]} tidak ditemukan, dilewati.${RESET}"
        fi
    done

    echo -e "${GREEN}🔧 Menerapkan Protect hanya untuk ID $ADMIN_ID...${RESET}"

    for name in "${!CONTROLLERS[@]}"; do
        path="${CONTROLLERS[$name]}"
        if [ ! -f "$path" ]; then
            echo -e "${RED}⚠️ File $path tidak ditemukan, dilewati.${RESET}"
            continue
        fi

        if ! grep -q "public function index" "$path"; then
            echo -e "${RED}⚠️ Gagal: $name tidak memiliki 'public function index()'! Lewat.${RESET}"
            continue
        fi

        awk -v admin_id="$ADMIN_ID" '
        BEGIN { inserted_use=0; in_func=0; }
        /^namespace / {
            print;
            if (!inserted_use) {
                print "use Illuminate\\Support\\Facades\\Auth;";
                inserted_use = 1;
            }
            next;
        }
        /public function index\(.*\)/ {
            print; in_func = 1; next;
        }
        in_func == 1 && /^\s*{/ {
            print;
            print "        $user = Auth::user();";
            print "        if (!$user || $user->id !== " admin_id ") {";
            print "            abort(403, \"Zero Protect - Akses ditolak\");";
            print "        }";
            in_func = 0; next;
        }
        { print; }
        ' "$path" > "$path.patched" && mv "$path.patched" "$path"
        echo -e "${GREEN}✅ Protect diterapkan ke: $name${RESET}"
    done

    echo -e "${YELLOW}➤ Install Node.js 20 & build frontend panel...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove -y nodejs >/dev/null 2>&1
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install -y nodejs >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${BLUE}🎉 Protect selesai!${RESET}"
    echo -e "${GREEN}📁 Backup file tersimpan di: ${BLUE}$BACKUP_DIR${RESET}"
    echo -e "${YELLOW}🛡️ Sekarang hanya ID ${CYAN}$ADMIN_ID${YELLOW} yang bisa mengakses halaman Nodes, Nests, & Settings.${RESET}"
    ;;
    22)
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo -e "${RED}❌ Folder backup tidak ditemukan: ${BLUE}$BACKUP_DIR${RESET}"
        echo -e "${YELLOW}⚠️ Jalankan mode Protect terlebih dahulu sebelum restore.${RESET}"
        exit 1
    fi

    echo -e "${CYAN}♻️ Mengembalikan semua file ke versi sebelum Protect...${RESET}"

    for name in "${!CONTROLLERS[@]}"; do
        src="$BACKUP_DIR/$name.bak"
        dest="${CONTROLLERS[$name]}"

        if [[ -f "$src" ]]; then
            cp "$src" "$dest"
            echo -e "${GREEN}🔄 Dipulihkan: ${BLUE}$name${RESET}"
        else
            echo -e "${RED}⚠️ Backup tidak ditemukan untuk ${YELLOW}$name${RESET}"
        fi
    done

    echo -e "${YELLOW}➤ Rebuild panel menggunakan Node.js 20...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove -y nodejs >/dev/null 2>&1
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install -y nodejs >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal masuk ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${GREEN}✅ Restore & rebuild panel selesai.${RESET}"
    echo -e "${BLUE}📁 Semua file dikembalikan ke versi sebelum Protect.${RESET}"
    ;;
    *)
        echo -e "${RED}Pilihan tidak valid.${RESET}"
        ;;
esac

animate_text "𝗣𝗥𝗢𝗦𝗘𝗦 𝗦𝗘𝗟𝗘𝗦𝗔𝗜"

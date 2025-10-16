#!/bin/bash

# Warna
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"
VERSION="1.4"

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
echo "║        🛡️  ZERO PROTECT + PANEL BUILDER  🛡️                      ║"
echo "║                    Version $VERSION                                ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo ""
echo -e "${YELLOW}${BOLD}Pilih mode yang ingin dijalankan:${RESET}"
echo ""
echo -e "${GREEN}[1]${RESET} 🔐 Install Protect (Add Protect)"
echo -e "${GREEN}[2]${RESET} ♻️ Restore Backup (Restore)"
echo ""
read -p "$(echo -e ${CYAN}${BOLD}"Masukkan pilihan (1/2): "${RESET})" MODE

declare -A CONTROLLERS
CONTROLLERS["NodeController.php"]="/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeController.php"
CONTROLLERS["NestController.php"]="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/NestController.php"
CONTROLLERS["IndexController.php"]="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/IndexController.php"

BACKUP_DIR="backup_pablo_protect"

if [[ "$MODE" == "1" ]]; then
    read -p "👤 Masukkan ID Admin Utama (contoh: 1): " ADMIN_ID
    if [[ -z "$ADMIN_ID" ]]; then
        echo -e "${RED}❌ Admin ID tidak boleh kosong.${RESET}"
        exit 1
    fi

    mkdir -p "$BACKUP_DIR"

    echo -e "${YELLOW}📦 Membackup file asli sebelum di protect ke: ${BLUE}$BACKUP_DIR${RESET}"
    for name in "${!CONTROLLERS[@]}"; do
        cp "${CONTROLLERS[$name]}" "$BACKUP_DIR/$name.bak"
    done

    echo -e "${GREEN}🔧 Menerapkan Protect hanya untuk ID $ADMIN_ID...${RESET}"

    for name in "${!CONTROLLERS[@]}"; do
        path="${CONTROLLERS[$name]}"
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

    echo -e "${YELLOW}➤ Install Node.js 20 dan build frontend panel...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove nodejs -y >/dev/null
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install nodejs -y >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${BLUE}🎉 Protect selesai!"
    echo -e "📁 Backup file tersimpan di: $BACKUP_DIR"
    echo -e "🛡️ Sekarang hanya ID $ADMIN_ID yang bisa mengakses halaman Nodes/Nests/Settings"
    echo -e "${RESET}"

elif [[ "$MODE" == "2" ]]; then
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo -e "${RED}❌ Folder backup tidak ditemukan: $BACKUP_DIR"
        echo -e "⚠️ Jalankan mode Protect terlebih dahulu.${RESET}"
        exit 1
    fi

    echo -e "${CYAN}♻️ Mengembalikan file ke versi sebelum Protect...${RESET}"
    for name in "${!CONTROLLERS[@]}"; do
        if [[ -f "$BACKUP_DIR/$name.bak" ]]; then
            cp "$BACKUP_DIR/$name.bak" "${CONTROLLERS[$name]}"
            echo -e "${GREEN}🔄 Dipulihkan: $name${RESET}"
        else
            echo -e "${RED}⚠️ Backup tidak ditemukan untuk $name!${RESET}"
        fi
    done

    echo -e "${YELLOW}➤ Install Node.js 20 dan build frontend panel...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove nodejs -y >/dev/null
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install nodejs -y >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${BLUE}✅ Restore selesai. Semua file dikembalikan ke versi asli.${RESET}"

else
    echo -e "${RED}❌ Pilihan tidak valid. Masukkan 1 atau 2.${RESET}"
    exit 1
fi        echo -e "${GREEN}✅ Protect diterapkan ke: $name${RESET}"
    done

    echo -e "${YELLOW}➤ Install Node.js 20 dan build frontend panel...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove nodejs -y >/dev/null
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install nodejs -y >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${BLUE}🎉 Protect selesai!"
    echo -e "📁 Backup file tersimpan di: $BACKUP_DIR"
    echo -e "🛡️ Sekarang hanya ID $ADMIN_ID yang bisa mengakses halaman Nodes/Nests/Settings"
    echo -e "${RESET}"

elif [[ "$MODE" == "2" ]]; then
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo -e "${RED}❌ Folder backup tidak ditemukan: $BACKUP_DIR"
        echo -e "⚠️ Jalankan mode Protect terlebih dahulu.${RESET}"
        exit 1
    fi

    echo -e "${CYAN}♻️ Mengembalikan file ke versi sebelum Protect...${RESET}"
    for name in "${!CONTROLLERS[@]}"; do
        if [[ -f "$BACKUP_DIR/$name.bak" ]]; then
            cp "$BACKUP_DIR/$name.bak" "${CONTROLLERS[$name]}"
            echo -e "${GREEN}🔄 Dipulihkan: $name${RESET}"
        else
            echo -e "${RED}⚠️ Backup tidak ditemukan untuk $name!${RESET}"
        fi
    done

    echo -e "${YELLOW}➤ Install Node.js 20 dan build frontend panel...${RESET}"
    sudo apt-get update -y >/dev/null
    sudo apt-get remove nodejs -y >/dev/null
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null
    sudo apt-get install nodejs -y >/dev/null

    cd /var/www/pterodactyl || { echo -e "${RED}❌ Gagal ke direktori panel.${RESET}"; exit 1; }

    npm i -g yarn >/dev/null
    yarn add cross-env >/dev/null
    yarn build:production --progress

    echo -e "\n${BLUE}✅ Restore selesai. Semua file dikembalikan ke versi asli.${RESET}"

else
    echo -e "${RED}❌ Pilihan tidak valid. Masukkan 1 atau 2.${RESET}"
    exit 1
fi

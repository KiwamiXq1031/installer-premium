#!/bin/bash

# ===============================
# 🔧 Auto Create Subdomain (Cloudflare)
# ===============================

# === Konfigurasi Cloudflare ===
CF_API="https://api.cloudflare.com/client/v4"
CF_ZONE_ID="0885a91405436a41a6b0a26c05da9a74"          # Ganti dengan Zone ID domain lo
CF_API_TOKEN="zbna8Er4lS0r5k8lp4nic9_msMi-jJyLMCtzX1Zd"  # Ganti dengan API Token Cloudflare
DOMAIN="zero-hosting.my.id"                              # Domain utama

# === Ambil input subdomain ===
read -rp "Masukkan nama subdomain: " SUBDOMAIN

# Validasi input
if [[ -z "$SUBDOMAIN" ]]; then
  echo "⚠️ Nama subdomain tidak boleh kosong!"
  exit 1
fi

# Cek format subdomain (hanya huruf, angka, dan tanda -)
if [[ ! "$SUBDOMAIN" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "⚠️ Format subdomain tidak valid! Hanya huruf, angka, dan tanda '-' yang diperbolehkan."
  exit 1
fi

# === Ambil IP publik VPS otomatis ===
IP_TARGET=$(curl -s https://ifconfig.me)

if [[ -z "$IP_TARGET" ]]; then
  echo "⚠️ Gagal mendapatkan IP publik VPS!"
  exit 1
fi

echo "🔍 Mengecek apakah subdomain sudah ada di Cloudflare..."

# === Cek apakah record sudah ada ===
CHECK_RESPONSE=$(curl -s -X GET "$CF_API/zones/$CF_ZONE_ID/dns_records?name=$SUBDOMAIN.$DOMAIN" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json")

EXISTING_RECORD_ID=$(echo "$CHECK_RESPONSE" | grep -o '"id":"[a-z0-9]\{32\}"' | cut -d'"' -f4)

if [[ -n "$EXISTING_RECORD_ID" ]]; then
  echo "⚠️ Subdomain sudah ada. Menghapus record lama..."
  curl -s -X DELETE "$CF_API/zones/$CF_ZONE_ID/dns_records/$EXISTING_RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" >/dev/null
fi

# === Buat record baru ===
echo "🔧 Membuat subdomain: $SUBDOMAIN.$DOMAIN → $IP_TARGET"

CREATE_RESPONSE=$(curl -s -X POST "$CF_API/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"type\": \"A\",
    \"name\": \"$SUBDOMAIN.$DOMAIN\",
    \"content\": \"$IP_TARGET\",
    \"ttl\": 120,
    \"proxied\": false
  }")

# === Cek hasil ===
if echo "$CREATE_RESPONSE" | grep -q '"success":true'; then
  echo "✅ Subdomain berhasil dibuat!"
  echo "🌐 URL: https://$SUBDOMAIN.$DOMAIN"
else
  echo "❌ Gagal membuat subdomain!"
  echo "🧩 Respon Cloudflare:"
  echo "$CREATE_RESPONSE"
fi

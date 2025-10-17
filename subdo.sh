#!/bin/bash

# === Konfigurasi ===
CF_API="https://api.cloudflare.com/client/v4"
CF_ZONE_ID="0885a91405436a41a6b0a26c05da9a74"
CF_API_TOKEN="zbna8Er4lS0r5k8lp4nic9_msMi-jJyLMCtzX1Zd"
DOMAIN="zero-hosting.my.id"

# === Input subdomain ===
read -rp "Masukkan nama subdomain: " SUBDOMAIN

if [[ -z "$SUBDOMAIN" ]]; then
  echo "⚠️ Nama subdomain tidak boleh kosong!"
  exit 1
fi

# === Ambil IP publik IPv4 aja ===
IP_TARGET=$(curl -4 -s https://api.ipify.org || curl -4 -s https://ipv4.icanhazip.com || curl -4 -s https://ifconfig.me)

# === Validasi hasil ===
if [[ -z "$IP_TARGET" ]]; then
  echo "⚠️ Gagal mendapatkan IP publik!"
  exit 1
fi

# Cek format IPv4 bener
if [[ ! "$IP_TARGET" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "⚠️ IP tidak valid: $IP_TARGET"
  exit 1
fi

# === Cek subdomain sudah ada atau belum ===
echo "🔍 Mengecek subdomain di Cloudflare..."
CHECK=$(curl -s -X GET "$CF_API/zones/$CF_ZONE_ID/dns_records?name=$SUBDOMAIN.$DOMAIN" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json")

RECORD_ID=$(echo "$CHECK" | grep -o '"id":"[a-z0-9]\{32\}"' | cut -d'"' -f4)

if [[ -n "$RECORD_ID" ]]; then
  echo "⚠️ Subdomain sudah ada, menghapus record lama..."
  curl -s -X DELETE "$CF_API/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" >/dev/null
fi

# === Buat record baru ===
echo "🔧 Membuat subdomain: $SUBDOMAIN.$DOMAIN → $IP_TARGET"

CREATE=$(curl -s -X POST "$CF_API/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"type\": \"A\",
    \"name\": \"$SUBDOMAIN.$DOMAIN\",
    \"content\": \"$IP_TARGET\",
    \"ttl\": 120,
    \"proxied\": false
  }")

# === Hasil ===
if echo "$CREATE" | grep -q '"success":true'; then
  echo "✅ Subdomain berhasil dibuat!"
  echo "🌐 https://$SUBDOMAIN.$DOMAIN"
else
  echo "❌ Gagal membuat subdomain!"
  echo "$CREATE"
fi

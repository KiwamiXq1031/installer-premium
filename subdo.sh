#!/bin/bash

# === Konfigurasi ===
CF_API="https://api.cloudflare.com/client/v4"
CF_ZONE_ID="b95b2842510f342cfccfd66ae4f31d09"           # Ganti dengan Zone ID domain lo
CF_API_TOKEN="zbna8Er4lS0r5k8lp4nic9_msMi-jJyLMCtzX1Zd"       # Ganti dengan API Token Cloudflare
DOMAIN="myzoku.my.id"                # Domain utama

# === Ambil input subdomain ===
read -p "Masukkan nama subdomain: " SUBDOMAIN

if [ -z "$SUBDOMAIN" ]; then
  echo "⚠️ Nama subdomain tidak boleh kosong!"
  exit 1
fi

# === Ambil IP publik VPS otomatis ===
IP_TARGET=$(curl -s ifconfig.me)

if [ -z "$IP_TARGET" ]; then
  echo "⚠️ Gagal mendapatkan IP publik VPS!"
  exit 1
fi

# === Buat record di Cloudflare ===
echo "🔧 Membuat subdomain: $SUBDOMAIN.$DOMAIN → $IP_TARGET"

RESPONSE=$(curl -s -X POST "$CF_API/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"type\":\"A\",
    \"name\":\"$SUBDOMAIN.$DOMAIN\",
    \"content\":\"$IP_TARGET\",
    \"ttl\":120,
    \"proxied\":false
  }")

# === Cek hasil ===
if echo "$RESPONSE" | grep -q "\"success\":true"; then
  echo "✅ Subdomain berhasil dibuat!"
  echo "🌐 URL: https://$SUBDOMAIN.$DOMAIN"
else
  echo "❌ Gagal membuat subdomain!"
  echo "Respon Cloudflare:"
  echo "$RESPONSE"
fi

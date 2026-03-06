#!/bin/bash
# ============================================================
# TurboSzpona — Quick Setup
# ============================================================
# Connects your TurboSzpona to our managed infrastructure.
# No API keys needed - everything included in your plan.
#
# Usage:
#   curl -fsSL https://turboszpona.pl/install | bash
#
# Your TurboSzpona plan includes:
#   - Starter:  ideal for personal use
#   - Pro:      for power users and small teams
#   - Business: unlimited, priority support
#
# Manage your account: https://app.turboszpona.pl
# ============================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}         TurboSzpona — Quick Setup          ${NC}"
echo -e "${BLUE}============================================${NC}"
echo

# --- Check if TurboSzpona/OpenClaw is installed ---
CONFIG_PATH="${OPENCLAW_CONFIG:-$HOME/.openclaw/openclaw.json}"
if [ ! -f "$CONFIG_PATH" ]; then
    for path in "$HOME/.config/openclaw/openclaw.json" "/etc/openclaw/openclaw.json"; do
        [ -f "$path" ] && CONFIG_PATH="$path" && break
    done
fi

if [ ! -f "$CONFIG_PATH" ]; then
    echo -e "${RED}TurboSzpona nie jest zainstalowana.${NC}"
    echo "Pobierz na: https://turboszpona.pl"
    exit 1
fi

echo -e "${YELLOW}Konfiguracja:${NC} $CONFIG_PATH"

# --- Get license key ---
LICENSE_KEY="${1:-}"

if [ -z "$LICENSE_KEY" ]; then
    echo
    echo -e "Potrzebujesz klucza licencyjnego z ${BLUE}https://app.turboszpona.pl${NC}"
    echo -e "Nie masz jeszcze? Zaloz konto na ${BLUE}https://turboszpona.pl${NC}"
    echo
    echo -ne "${YELLOW}Wklej klucz licencyjny:${NC} "
    read -r LICENSE_KEY
    echo
fi

if [ -z "$LICENSE_KEY" ]; then
    echo -e "${RED}Blad:${NC} Klucz licencyjny jest wymagany."
    echo "Pobierz go na: https://app.turboszpona.pl"
    exit 1
fi

# --- Validate license ---
echo -ne "Weryfikacja licencji... "
RESPONSE=$(curl -s -w "\n%{http_code}" "https://api.turboszpona.pl/v1/license/verify" \
    -H "Authorization: Bearer $LICENSE_KEY" \
    -H "Content-Type: application/json" 2>/dev/null || echo -e "\n000")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "000" ]; then
    # Fallback - verify against model endpoint
    RESPONSE=$(curl -s -w "\n%{http_code}" "https://llm.xfaang.com/v1/models" \
        -H "Authorization: Bearer $LICENSE_KEY" 2>/dev/null)
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
fi

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}NIEPRAWIDLOWY${NC}"
    echo "Sprawdz klucz na: https://app.turboszpona.pl"
    exit 1
fi
echo -e "${GREEN}OK${NC}"

# --- Backup config ---
BACKUP_PATH="${CONFIG_PATH}.backup.$(date +%s)"
cp "$CONFIG_PATH" "$BACKUP_PATH"
echo -e "${YELLOW}Backup:${NC} $BACKUP_PATH"

# --- Patch config ---
echo -ne "Konfiguracja TurboSzpona... "

python3 << PYEOF
import json

config_path = "$CONFIG_PATH"
license_key = "$LICENSE_KEY"

with open(config_path) as f:
    config = json.load(f)

# Ensure models section exists
if "models" not in config:
    config["models"] = {}
if "providers" not in config["models"]:
    config["models"]["providers"] = {}

# Add TurboSzpona as a single provider - no individual model names exposed
config["models"]["providers"]["turboszpona"] = {
    "baseUrl": "https://api.turboszpona.pl/v1",
    "apiKey": license_key,
    "api": "openai-completions",
    "models": [
        {
            "id": "turbo",
            "name": "TurboSzpona",
            "contextWindow": 200000,
            "maxTokens": 16384,
            "input": ["text", "image"]
        },
        {
            "id": "turbo-fast",
            "name": "TurboSzpona Fast",
            "contextWindow": 1000000,
            "maxTokens": 65536,
            "input": ["text", "image"]
        },
        {
            "id": "turbo-max",
            "name": "TurboSzpona Max",
            "contextWindow": 200000,
            "maxTokens": 32768,
            "input": ["text", "image"]
        }
    ]
}

# Set defaults
config.setdefault("agents", {}).setdefault("defaults", {})
config["agents"]["defaults"]["model"] = {
    "primary": "turboszpona/turbo",
    "fallbacks": [
        "turboszpona/turbo-fast"
    ]
}

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)

print("OK")
PYEOF

echo -e "${GREEN}Gotowe!${NC}"

# --- Restart ---
echo
echo -ne "Restart TurboSzpona... "
if command -v openclaw &>/dev/null; then
    openclaw gateway restart 2>/dev/null && echo -e "${GREEN}OK${NC}" || echo -e "${YELLOW}Zrestartuj recznie${NC}"
else
    echo -e "${YELLOW}Zrestartuj TurboSzpona recznie${NC}"
fi

# --- Summary ---
echo
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}      TurboSzpona skonfigurowana!           ${NC}"
echo -e "${GREEN}============================================${NC}"
echo
echo -e "  TurboSzpona       — codzienne zadania"
echo -e "  TurboSzpona Fast  — szybkie odpowiedzi"
echo -e "  TurboSzpona Max   — zlozzone zadania"
echo
echo -e "Zarzadzaj kontem: ${BLUE}https://app.turboszpona.pl${NC}"
echo

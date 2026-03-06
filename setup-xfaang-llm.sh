#!/bin/bash
# ============================================================
# TurboSzpona / OpenClaw — Setup Xfaang LLM Gateway
# ============================================================
# Configures any OpenClaw instance to use llm.xfaang.com
# as its LLM provider (LiteLLM proxy by Xfaang).
#
# Usage:
#   ./setup-xfaang-llm.sh <API_KEY>
#
# Example:
#   ./setup-xfaang-llm.sh sk-xfaang-abc123def456
#
# What it does:
#   1. Validates the API key against llm.xfaang.com
#   2. Patches openclaw.json with the Xfaang provider config
#   3. Sets the default model to claude-sonnet-4 via proxy
#   4. Restarts OpenClaw gateway
#
# Available models via Xfaang gateway:
#   - claude-opus-4-6     (Anthropic, complex tasks)
#   - claude-sonnet-4     (Anthropic, daily tasks)
#   - claude-haiku        (Anthropic, fast & cheap)
#   - gpt-4o              (OpenAI, multimodal)
#   - gpt-4o-mini         (OpenAI, fast & cheap)
#   - gemini-3-flash      (Google, fast)
#   - gemini-3.1-pro      (Google, long context)
#   - gemini-2.5-pro      (Google, reasoning)
#   - gemini-2.5-flash    (Google, balanced)
#   - gemini-2.0-flash    (Google, legacy fast)
#   - grok-fast           (xAI, fast)
#   - grok                (xAI, standard)
#   - qwen3-coder         (Ollama, self-hosted, coding)
# ============================================================

set -euo pipefail

PROXY_URL="https://llm.xfaang.com"
PROVIDER_NAME="xfaang"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Xfaang LLM Gateway Setup for OpenClaw    ${NC}"
echo -e "${BLUE}============================================${NC}"
echo

# --- Get API key (argument or interactive) ---
API_KEY="${1:-}"

if [ -z "$API_KEY" ]; then
    echo -e "Potrzebujesz klucza API z ${BLUE}https://app.turboszpona.pl${NC}"
    echo
    echo -ne "${YELLOW}Wklej swoj klucz API:${NC} "
    read -r API_KEY
    echo
fi

if [ -z "$API_KEY" ]; then
    echo -e "${RED}Blad:${NC} Klucz API jest wymagany."
    echo "Pobierz go na: https://app.turboszpona.pl"
    exit 1
fi

# --- Find OpenClaw config ---
CONFIG_PATH="${OPENCLAW_CONFIG:-$HOME/.openclaw/openclaw.json}"
if [ ! -f "$CONFIG_PATH" ]; then
    # Try alternate locations
    for path in "$HOME/.config/openclaw/openclaw.json" "/etc/openclaw/openclaw.json"; do
        if [ -f "$path" ]; then
            CONFIG_PATH="$path"
            break
        fi
    done
fi

if [ ! -f "$CONFIG_PATH" ]; then
    echo -e "${RED}Error:${NC} OpenClaw config not found."
    echo "Expected at: $CONFIG_PATH"
    echo "Is OpenClaw installed? Run: npm i -g openclaw"
    exit 1
fi

echo -e "${YELLOW}Config:${NC} $CONFIG_PATH"

# --- Validate API key ---
echo -ne "Validating API key... "
RESPONSE=$(curl -s -w "\n%{http_code}" "$PROXY_URL/v1/models" \
    -H "Authorization: Bearer $API_KEY" 2>/dev/null)
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}FAILED${NC}"
    echo -e "HTTP $HTTP_CODE - Invalid API key or gateway unreachable."
    echo "Check your key or contact hello@xfaang.com"
    exit 1
fi

MODEL_COUNT=$(echo "$BODY" | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('data',[])))" 2>/dev/null || echo "0")
echo -e "${GREEN}OK${NC} ($MODEL_COUNT models available)"

# --- List available models ---
echo
echo -e "${BLUE}Available models:${NC}"
echo "$BODY" | python3 -c "
import sys, json
models = json.load(sys.stdin).get('data', [])
for m in sorted(models, key=lambda x: x['id']):
    print(f'  - {m[\"id\"]}')
" 2>/dev/null

# --- Backup config ---
BACKUP_PATH="${CONFIG_PATH}.backup.$(date +%s)"
cp "$CONFIG_PATH" "$BACKUP_PATH"
echo
echo -e "${YELLOW}Backup:${NC} $BACKUP_PATH"

# --- Patch config ---
echo -ne "Patching OpenClaw config... "

python3 << PYEOF
import json, sys

config_path = "$CONFIG_PATH"
api_key = "$API_KEY"
proxy_url = "$PROXY_URL"

with open(config_path) as f:
    config = json.load(f)

# Ensure models section exists
if "models" not in config:
    config["models"] = {}
if "providers" not in config["models"]:
    config["models"]["providers"] = {}

# Add Xfaang provider
config["models"]["providers"]["xfaang"] = {
    "baseUrl": f"{proxy_url}/v1",
    "apiKey": api_key,
    "api": "openai-completions",
    "models": [
        {
            "id": "claude-opus-4-6",
            "name": "Claude Opus 4.6 (via Xfaang)",
            "contextWindow": 200000,
            "maxTokens": 32768,
            "input": ["text", "image"],
            "cost": {"input": 15, "output": 75, "cacheRead": 1.5, "cacheWrite": 18.75}
        },
        {
            "id": "claude-sonnet-4",
            "name": "Claude Sonnet 4 (via Xfaang)",
            "contextWindow": 200000,
            "maxTokens": 16384,
            "input": ["text", "image"],
            "cost": {"input": 3, "output": 15, "cacheRead": 0.3, "cacheWrite": 3.75}
        },
        {
            "id": "claude-haiku",
            "name": "Claude Haiku (via Xfaang)",
            "contextWindow": 200000,
            "maxTokens": 8192,
            "input": ["text", "image"],
            "cost": {"input": 0.8, "output": 4, "cacheRead": 0.08, "cacheWrite": 1}
        },
        {
            "id": "gpt-4o",
            "name": "GPT-4o (via Xfaang)",
            "contextWindow": 128000,
            "maxTokens": 16384,
            "input": ["text", "image"],
            "cost": {"input": 2.5, "output": 10}
        },
        {
            "id": "gpt-4o-mini",
            "name": "GPT-4o Mini (via Xfaang)",
            "contextWindow": 128000,
            "maxTokens": 16384,
            "input": ["text", "image"],
            "cost": {"input": 0.15, "output": 0.6}
        },
        {
            "id": "gemini-3-flash",
            "name": "Gemini 3 Flash (via Xfaang)",
            "contextWindow": 1000000,
            "maxTokens": 65536,
            "input": ["text", "image"],
            "cost": {"input": 0.15, "output": 0.6}
        },
        {
            "id": "gemini-3.1-pro",
            "name": "Gemini 3.1 Pro (via Xfaang)",
            "contextWindow": 1000000,
            "maxTokens": 65536,
            "input": ["text", "image"],
            "cost": {"input": 1.25, "output": 10}
        },
        {
            "id": "gemini-2.5-pro",
            "name": "Gemini 2.5 Pro (via Xfaang)",
            "contextWindow": 1000000,
            "maxTokens": 65536,
            "input": ["text", "image"],
            "reasoning": True,
            "cost": {"input": 1.25, "output": 10}
        },
        {
            "id": "gemini-2.5-flash",
            "name": "Gemini 2.5 Flash (via Xfaang)",
            "contextWindow": 1000000,
            "maxTokens": 65536,
            "input": ["text", "image"],
            "cost": {"input": 0.15, "output": 0.6}
        },
        {
            "id": "grok-fast",
            "name": "Grok Fast (via Xfaang)",
            "contextWindow": 131072,
            "maxTokens": 32768,
            "input": ["text"],
            "cost": {"input": 2, "output": 10}
        },
        {
            "id": "grok",
            "name": "Grok (via Xfaang)",
            "contextWindow": 131072,
            "maxTokens": 32768,
            "input": ["text"],
            "cost": {"input": 5, "output": 15}
        }
    ]
}

# Set default model to use Xfaang provider
config.setdefault("agents", {}).setdefault("defaults", {})
config["agents"]["defaults"]["model"] = {
    "primary": "xfaang/claude-sonnet-4",
    "fallbacks": [
        "xfaang/gemini-3-flash",
        "xfaang/gpt-4o-mini"
    ]
}

# Add convenient aliases
config["agents"]["defaults"].setdefault("models", {})
config["agents"]["defaults"]["models"].update({
    "xfaang/claude-opus-4-6": {"alias": "opus"},
    "xfaang/claude-sonnet-4": {"alias": "sonnet"},
    "xfaang/claude-haiku": {"alias": "haiku"},
    "xfaang/gpt-4o": {"alias": "gpt4o"},
    "xfaang/gpt-4o-mini": {"alias": "gpt4mini"},
    "xfaang/gemini-3-flash": {"alias": "flash"},
    "xfaang/gemini-3.1-pro": {"alias": "gemini-pro"},
    "xfaang/gemini-2.5-pro": {"alias": "gemini25"},
    "xfaang/grok-fast": {"alias": "grok"}
})

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)

print("OK")
PYEOF

echo -e "${GREEN}Done!${NC}"

# --- Restart OpenClaw ---
echo
echo -ne "Restarting OpenClaw... "
if command -v openclaw &>/dev/null; then
    openclaw gateway restart 2>/dev/null && echo -e "${GREEN}OK${NC}" || echo -e "${YELLOW}Manual restart needed${NC}"
else
    echo -e "${YELLOW}openclaw CLI not found - restart manually${NC}"
fi

# --- Summary ---
echo
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}          Setup Complete!                   ${NC}"
echo -e "${GREEN}============================================${NC}"
echo
echo -e "Gateway:  ${BLUE}$PROXY_URL${NC}"
echo -e "Provider: ${BLUE}xfaang${NC}"
echo -e "Default:  ${BLUE}xfaang/claude-sonnet-4${NC}"
echo -e "Fallback: ${BLUE}xfaang/gemini-3-flash -> xfaang/gpt-4o-mini${NC}"
echo
echo -e "Model aliases (use with /model command):"
echo -e "  opus, sonnet, haiku, gpt4o, gpt4mini, flash, gemini-pro, gemini25, grok"
echo
echo -e "${YELLOW}Token usage is tracked. Check balance at: https://app.turboszpona.pl${NC}"
echo

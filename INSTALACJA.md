# Instalacja TurboSzpona

## Szybka instalacja

### macOS/Linux
```bash
npm install -g turboszpona
turboszpona init
```

### Windows
```powershell
npm install -g turboszpona
turboszpona init
```

## Wymagania systemowe

- **Node.js** 18+ lub 20+ (zalecane)
- **npm** (dostępne z Node.js)
- **System operacyjny:** macOS, Linux, Windows
- **RAM:** Minimum 2GB wolnej pamięci
- **Miejsce na dysku:** 500MB dla instalacji

## Proces instalacji krok po kroku

### 1. Zainstaluj Node.js
Pobierz z [nodejs.org](https://nodejs.org/) i zainstaluj najnowszą wersję LTS.

### 2. Zainstaluj TurboSzpona
```bash
npm install -g turboszpona
```

### 3. Inicjalizuj agenta
```bash
turboszpona init
```

Program uruchomi kreator konfiguracji, który pomoże Ci:
- Wybrać osobowość agenta
- Skonfigurować kanały komunikacji (WhatsApp, Discord, etc.)
- Ustawić preferencje językowe
- Połączyć z modelami LLM

### 4. Uruchom agenta
```bash
turboszpona start
```

## Konfiguracja kanałów

### WhatsApp
1. Zeskanuj kod QR w aplikacji WhatsApp Web
2. Agent automatycznie połączy się z Twoim kontem

### Discord
1. Utwórz aplikację Discord Bot w Discord Developer Portal
2. Skopiuj token bota
3. Dodaj token do konfiguracji TurboSzpona

### Telegram
1. Napisz do @BotFather w Telegram
2. Utwórz nowego bota komendą `/newbot`
3. Skopiuj otrzymany token do konfiguracji

## Rozwiązywanie problemów

### Problem: `npm: command not found`
**Rozwiązanie:** Zainstaluj Node.js z [nodejs.org](https://nodejs.org/)

### Problem: `Permission denied`
**Rozwiązanie na macOS/Linux:**
```bash
sudo npm install -g turboszpona
```

### Problem: Agent nie odpowiada
1. Sprawdź czy proces działa: `turboszpona status`
2. Sprawdź logi: `turboszpona logs`
3. Restartuj agenta: `turboszpona restart`

## Aktualizacja

```bash
npm update -g turboszpona
turboszpona restart
```

## Wsparcie

- **Dokumentacja:** [turboszpona.pl/docs](https://turboszpona.pl/docs)
- **Discord:** [discord.gg/turboszpona](https://discord.gg/turboszpona)
- **Email:** [pomoc@xfaang.com](mailto:pomoc@xfaang.com)
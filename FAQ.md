# Często Zadawane Pytania (FAQ)

## Ogólne

### Co to jest TurboSzpona?
TurboSzpona to gotowy do wdrożenia agent cyfrowej inteligencji oparty na silniku OpenClaw. To osobisty asystent AI, który działa na Twoim urządzeniu i może komunikować się przez WhatsApp, Discord, Telegram i inne kanały.

### Czym różni się od ChatGPT/Claude?
- **Lokalny**: Działa na Twoim urządzeniu, nie w chmurze
- **Multi-kanałowy**: Rozmawiaj przez WhatsApp, Discord, SMS
- **Wykonawczy**: Może wykonywać zadania, nie tylko rozmawiać
- **Prywatny**: Twoje dane zostają u Ciebie
- **Konfigurowalny**: Pełna personalizacja osobowości i zachowania

### Ile to kosztuje?
TurboSzpona jest darmowy do pobrania. Płacisz tylko za wykorzystanie modeli LLM (jak GPT-4, Claude) według cennika dostawcy. Szacunkowo: 10-50 zł miesięcznie przy normalnym użytkowaniu.

## Instalacja i konfiguracja

### Na jakich systemach działa?
- **macOS** (Intel i Apple Silicon)
- **Windows** 10/11
- **Linux** (Ubuntu, Debian, CentOS, Arch)
- **Raspberry Pi** (ARM64)

### Czy potrzebuję konto programisty?
Nie. TurboSzpona jest gotowy do użycia od razu po instalacji. Opcjonalnie możesz dodać własne klucze API dla tańszego dostępu do modeli LLM.

### Ile miejsca na dysku zajmuje?
- Instalacja: ~500MB
- Dane operacyjne: 50-200MB (zależnie od historii rozmów)
- Cache modeli: 1-5GB (opcjonalnie, dla szybszego działania)

### Czy mogę używać bez internetu?
Częściowo. Agent potrzebuje internetu do:
- Komunikacji z modelami LLM
- Pobierania informacji z sieci
- Wysyłania wiadomości przez kanały online

Lokalne funkcje (zarządzanie plikami, analiza dokumentów) działają offline.

## Modele LLM

### Które modele są obsługiwane?
- **OpenAI**: GPT-4o, GPT-4o Mini, GPT-4 Turbo
- **Anthropic**: Claude 3.5 Sonnet, Claude 3 Haiku
- **Google**: Gemini Pro, Gemini Flash
- **Lokalne**: Ollama, LM Studio (eksperymentalne)

### Który model wybrać?
- **GPT-4o**: Najlepszy ogólny model, droższy
- **Claude 3.5 Sonnet**: Świetny do analizy i pisania
- **Gemini Flash**: Szybki i tani, dobry do prostych zadań
- **GPT-4o Mini**: Ekonomiczny wybór do podstawowych funkcji

### Czy mogę zmienić model w trakcie?
Tak, w dowolnym momencie przez `turboszpona config` lub komendę w chacie.

## Kanały komunikacji

### Jak podłączyć WhatsApp?
1. Uruchom `turboszpona channels`
2. Wybierz WhatsApp
3. Zeskanuj kod QR w WhatsApp Web
4. Agent automatycznie się połączy

### Discord bot nie odpowiada
Sprawdź czy:
- Bot ma uprawnienia do czytania i pisania wiadomości
- Bot został dodany do serwera z odpowiednimi rolami
- Token bota jest poprawnie skonfigurowany

### Mogę używać na grupowych chatach?
Tak! Agent może uczestniczyć w:
- Grupach WhatsApp (mention @agent)
- Serwerach Discord (mention lub DM)
- Grupach Telegram (komendy lub mention)

## Bezpieczeństwo

### Czy moje rozmowy są bezpieczne?
Tak:
- Wszystkie dane przechowywane lokalnie
- Komunikacja z modelami LLM szyfrowana (HTTPS)
- Brak przesyłania danych do serwerów TurboSzpona
- Możliwość całkowitego szyfrowania historii

### Co widzi mój agent?
Agent może uzyskać dostęp tylko do tego, na co mu pozwolisz:
- Wiadomości z kanałów, które skonfigurowałeś
- Pliki, które mu udostępnisz
- Aplikacje, do których dasz uprawnienia

### Jak usunąć wszystkie dane?
```bash
turboszpona data-clear --all
# lub usuń folder ~/.turboszpona/
```

## Personalizacja

### Czy mogę zmienić osobowość agenta?
Tak! Użyj kreatora osobowości:
```bash
turboszpona personality
```

Możesz ustawić:
- Imię i charakter
- Styl komunikacji  
- Specjalizacje i umiejętności
- Język i regionalne preferencje

### Mogę mieć kilku agentów?
Tak, możesz utworzyć profile:
```bash
turboszpona profile create "Agent Biznesowy"
turboszpona profile create "Asystent Osobisty" 
turboszpona profile switch "Agent Biznesowy"
```

### Jak nauczyć agenta moich preferencji?
Agent uczy się z każdej rozmowy. Możesz też:
- Dodać informacje w `turboszpona config`
- Utworzyć pliki z kontekstem w folderze agenta
- Używać komend trenowania: "Zapamiętaj, że lubię kawę bez cukru"

## Funkcje zaawansowane

### Czy agent może wykonywać zadania automatycznie?
Tak, może:
- Ustawiać przypomnienia i alarmy
- Monitorować strony i wysyłać alerty
- Generować regularne raporty
- Wykonywać backup plików

### Integracje z innymi aplikacjami?
Agent integruje się z:
- **Kalendarzem** (Google, Outlook, Apple)
- **Emailem** (Gmail, Outlook)
- **Notatkami** (Notion, Obsidian)
- **Chmurą** (Google Drive, Dropbox)
- **Plus setki aplikacji przez API**

### Czy mogę pisać własne funkcje?
Tak! TurboSzpona obsługuje:
- Pluginy JavaScript/TypeScript
- Skrypty Shell/Python/Node.js
- Integracje webhook
- Komendę exec dla zaawansowanych użytkowników

## Rozwiązywanie problemów

### Agent działa wolno
Możliwe przyczyny:
- Model LLM jest przeciążony (spróbuj inny)
- Słabe połączenie internetowe
- Za mało RAM (zamknij inne aplikacje)
- Cache jest przepełniony (`turboszpona cache clear`)

### "Permission denied" na macOS
```bash
# Daj uprawnienia dla folderu
sudo chown -R $(whoami) ~/.turboszpona/

# Lub uruchom z sudo (niezalecane)
sudo turboszpona start
```

### Agent nie pamięta wcześniejszych rozmów
Sprawdź ustawienia pamięci:
```bash
turboszpona config
# Zwiększ memory.maxHistory do 1000
# Ustaw memory.persistent na true
```

### Błąd "Model not available"
- Sprawdź saldo konta u dostawcy LLM
- Zweryfikuj poprawność kluczy API
- Spróbuj innego modelu: `turboszpona model set gpt-4o-mini`

## Aktualizacje i wsparcie

### Jak sprawdzić wersję?
```bash
turboszpona version
```

### Jak aktualizować?
```bash
npm update -g turboszpona
turboszpona restart
```

### Gdzie szukać pomocy?
1. **Ten FAQ** - podstawowe odpowiedzi
2. **Discord**: [discord.gg/turboszpona](https://discord.gg/turboszpona) - społeczność
3. **Dokumentacja**: [docs.turboszpona.pl](https://docs.turboszpona.pl) - szczegóły techniczne
4. **Email**: [pomoc@xfaang.com](mailto:pomoc@xfaang.com) - wsparcie techniczne
5. **GitHub**: [issues](https://github.com/TurboSzpona/turboszpona/issues) - zgłaszanie błędów

### Jak zgłosić błąd?
Na GitHubie podaj:
- Wersję TurboSzpona (`turboszpona version`)
- System operacyjny
- Kroki do odtworzenia problemu
- Logi błędu (`turboszpona logs --error`)

---

**Nie znalazłeś odpowiedzi? Zapytaj na [Discord](https://discord.gg/turboszpona)!** 💬
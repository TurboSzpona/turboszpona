# Przewodnik Użytkownika TurboSzpona

## Pierwsze kroki

Po instalacji TurboSzpona, Twój osobisty agent cyfrowej inteligencji jest gotowy do pracy. Oto jak z niego korzystać:

## Podstawowe komendy

### Uruchamianie i zatrzymywanie
```bash
turboszpona start      # Uruchom agenta
turboszpona stop       # Zatrzymaj agenta
turboszpona restart    # Restartuj agenta
turboszpona status     # Sprawdź status
```

### Konfiguracja
```bash
turboszpona config     # Otwórz edytor konfiguracji
turboszpona channels   # Zarządzaj kanałami komunikacji
turboszpona models     # Ustaw model LLM
```

## Komunikacja z agentem

### WhatsApp
- Wyślij dowolną wiadomość na WhatsApp
- Agent odpowie używając wybranej osobowości
- Może wykonywać zadania, wyszukiwać informacje, pomagać w codziennych sprawach

### Discord
- Oznacz agenta: `@TurboSzpona jak pogoda jutro?`
- Lub wyślij prywatną wiadomość
- Agent rozpoznaje kontekst rozmowy i historia jest zachowana

### Telegram
- Dodaj bota do rozmowy lub grupy
- Komenda `/start` uruchamia interakcję
- Wszystkie podstawowe funkcje dostępne przez chat

## Kreator osobowości

TurboSzpona pozwala stworzyć unikalną osobowość agenta:

### 1. Uruchom kreatora
```bash
turboszpona personality
```

### 2. Przejdź przez 8 kroków:
- **Imię i charakter** - Jak ma się nazywać i zachowywać
- **Język** - Polski, angielski, lub mieszany  
- **Styl komunikacji** - Formalny, luźny, humorystyczny
- **Specjalizacje** - Technologia, biznes, kreatywność
- **Ograniczenia** - Co może/nie może robić
- **Kontekst** - Informacje o Tobie dla lepszej personalizacji
- **Głos** - Jeśli używasz funkcji TTS (text-to-speech)
- **Finalizacja** - Podgląd i zatwierdzenie

### 3. Testuj i dopracuj
Agent zostanie utworzony z Twoją unikalną osobowością. Możesz ją później modyfikować przez `turboszpona config`.

## Zaawansowane funkcje

### Zarządzanie plikami
Agent może:
- Czytać i analizować dokumenty
- Tworzyć raporty i podsumowania  
- Organizować pliki i foldery
- Konwertować formaty

### Integracje
- **Kalendarz** - Sprawdzanie i planowanie spotkań
- **Email** - Czytanie i wysyłanie wiadomości
- **Web scraping** - Pobieranie informacji ze stron
- **API** - Łączenie z zewnętrznymi usługami

### Automatyzacja
- Ustawianie przypomnień i powiadomień
- Cykliczne zadania i raporty
- Monitoring stron i usług
- Backup i synchronizacja

## Przykłady użycia

### Asystent biznesowy
```
"Przygotuj raport sprzedaży z ostatniego miesiąca"
"Zaplanuj spotkanie z zespołem na przyszły tydzień"
"Wyślij podsumowanie projektu do klienta"
```

### Pomoc osobista
```
"Przypomnij mi jutro o 9:00 o wizycie u dentysty"
"Jaka będzie pogoda w weekend?"
"Znajdź przepis na ciasto jabłkowe"
```

### Badania i analiza
```
"Przeanalizuj ten dokument PDF i wyciągnij kluczowe punkty"
"Porównaj ceny produktów w 3 różnych sklepach"
"Przygotuj prezentację o trendach w AI"
```

## Bezpieczeństwo i prywatność

### Ochrona danych
- Wszystkie dane przechowywane lokalnie na Twoim urządzeniu
- Komunikacja z modelami LLM szyfrowana
- Brak przechowywania historii rozmów w chmurze
- Pełna kontrola nad tym, co agent może robić

### Ustawienia prywatności
```bash
turboszpona privacy      # Zarządzaj ustawieniami prywatności
turboszpona data-export  # Eksportuj swoje dane
turboszpona data-clear   # Wyczyść historię
```

## Rozwiązywanie problemów

### Agent nie odpowiada
1. `turboszpona status` - sprawdź czy działa
2. `turboszpona logs` - przejrzyj logi błędów
3. `turboszpona restart` - restartuj usługę

### Problemy z konfiguracją
1. `turboszpona config reset` - reset do ustawień domyślnych
2. Usuń plik `.turboszpona/config.json` i uruchom `turboszpona init`

### Problemy z kanałami
- **WhatsApp**: Zeskanuj ponownie kod QR
- **Discord**: Sprawdź uprawnienia bota na serwerze
- **Telegram**: Zweryfikuj poprawność tokena

## Wsparcie

### Dokumentacja
- **Strona główna:** [turboszpona.pl](https://turboszpona.pl)
- **Pełna dokumentacja:** [docs.turboszpona.pl](https://docs.turboszpona.pl)
- **Poradniki wideo:** [youtube.com/@xfaang](https://youtube.com/@xfaang)

### Społeczność
- **Discord:** [discord.gg/turboszpona](https://discord.gg/turboszpona)  
- **Forum:** [forum.turboszpona.pl](https://forum.turboszpona.pl)
- **Reddit:** [r/turboszpona](https://reddit.com/r/turboszpona)

### Kontakt
- **Email wsparcia:** [pomoc@xfaang.com](mailto:pomoc@xfaang.com)
- **Email biznesowy:** [biznes@xfaang.com](mailto:biznes@xfaang.com)
- **Zgłaszanie błędów:** [github.com/TurboSzpona/turboszpona/issues](https://github.com/TurboSzpona/turboszpona/issues)

---

**Miłego korzystania z TurboSzpona!** 🦞⚡
// 1. Language Service (neue Datei: lib/src/services/language_service.dart)
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('de'); // Standard: Deutsch

  Locale get currentLocale => _currentLocale;

  // Verfügbare Sprachen
  static const List<LanguageOption> supportedLanguages = [
    LanguageOption('de', 'Deutsch', '🇩🇪'),
    LanguageOption('en', 'English', '🇺🇸'),
    LanguageOption('fr', 'Français', '🇫🇷'),
    LanguageOption('es', 'Español', '🇪🇸'),
  ];

  // Beim App-Start laden
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'de';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  // Sprache ändern und speichern
  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  // Aktuelle Sprache als LanguageOption
  LanguageOption get currentLanguageOption {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == _currentLocale.languageCode,
      orElse: () => supportedLanguages.first,
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String flag;

  const LanguageOption(this.code, this.name, this.flag);
}

// 2. Language Selection Widget (für Settings Screen)
class LanguageSelector extends StatelessWidget {
  final LanguageService languageService;

  const LanguageSelector({super.key, required this.languageService});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Text(
          languageService.currentLanguageOption.flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          'Sprache / Language',
          style: TextStyle(
            color: Palette.textWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          languageService.currentLanguageOption.name,
          style: TextStyle(color: Palette.textWhite.withAlpha(150)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Palette.textWhite,
          size: 16,
        ),
        onTap: () => _showLanguageDialog(context),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageService.supportedLanguages.map((language) {
            final isSelected =
                language.code == languageService.currentLocale.languageCode;

            return ListTile(
              leading: Text(
                language.flag,
                style: const TextStyle(fontSize: 20),
              ),
              title: Text(language.name),
              trailing: isSelected
                  ? Icon(Icons.check, color: Palette.lightGreenBlue)
                  : null,
              onTap: () {
                languageService.changeLanguage(language.code);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }
}

// 3. Mini Language Button (für Login/Registration)
class MiniLanguageButton extends StatelessWidget {
  final LanguageService languageService;

  const MiniLanguageButton({super.key, required this.languageService});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showLanguageBottomSheet(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Palette.textWhite.withAlpha(20), // DEINE FARBE
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(120), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageService.currentLanguageOption.flag,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Palette.backgroundGreenBlue, // DEINE FARBE
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Palette.lightGreenBlue,
              Palette.darkGreenblue,
            ], // DEIN GRADIENT
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Palette.textWhite.withAlpha(175), // DEINE FARBE
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sprache auswählen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Palette.textWhite, // DEINE SCHRIFTFARBE
                ),
              ),
              const SizedBox(height: 16),
              ...LanguageService.supportedLanguages.map((language) {
                final isSelected =
                    language.code == languageService.currentLocale.languageCode;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Palette.textWhite.withAlpha(
                            100,
                          ) // Highlight für ausgewählte Sprache
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: Text(
                      language.name,
                      style: TextStyle(
                        color: Palette.textWhite, // DEINE SCHRIFTFARBE
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Palette.textWhite,
                          ) // DEINE ICON-FARBE
                        : null,
                    onTap: () {
                      languageService.changeLanguage(language.code);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Integration in deinen Registration Screen
// Ersetze die Header-Section (App Icon + Titel) mit diesem Code:

/*
// In deinem Registration Screen Column, ersetze den Header-Bereich:
Row(
  children: [
    // Linke Seite: App Icon + Text zentriert
    Expanded(
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.asset(
                "assets/images/appicon.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Bundle",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    ),
    // Rechte Seite: Language Button
    Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return MiniLanguageButton(languageService: languageService);
      },
    ),
  ],
),
*/

// 5. Integration in deinen Settings Screen
// Füge das in deinen SettingScreen nach dem Logout-Button hinzu:

/*
// Nach dem Logout-Button in deinem build() method:
Consumer<LanguageService>(
  builder: (context, languageService, child) {
    return Column(
      children: [
        const SizedBox(height: 16),
        LanguageSelector(languageService: languageService),
        const SizedBox(height: 16),
      ],
    );
  },
),
*/

// 5. Provider Setup (in main.dart):
/*
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthRepository()),
    ChangeNotifierProvider(create: (_) => DatabaseRepository()),
    ChangeNotifierProvider(create: (_) => LanguageService()..loadSavedLanguage()),
  ],
  child: MyApp(),
)
*/

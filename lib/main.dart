import 'package:firebase_core/firebase_core.dart';
import 'package:fluentzy/data/enums/support_language.dart';
import 'package:fluentzy/data/models/chat_message.dart';
import 'package:fluentzy/di/provider_setup.dart';
import 'package:fluentzy/firebase_options.dart';
import 'package:fluentzy/routing/app_router.dart';
import 'package:fluentzy/ui/language/language_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  await Hive.openBox<ChatMessage>('chatBox');
  runApp(MultiProvider(providers: appProviders, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageViewModel>().locale;
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.varelaRoundTextTheme()),
      locale: locale,
      supportedLocales:
          SupportLanguage.values
              .map((lang) => lang.languageCode.locale)
              .toList(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

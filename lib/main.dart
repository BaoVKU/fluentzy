import 'package:firebase_core/firebase_core.dart';
import 'package:fluentzy/data/enums/support_language.dart';
import 'package:fluentzy/data/models/chat_message.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/ai_service.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/data/services/auth_service.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/data/services/dictionary_service.dart';
import 'package:fluentzy/data/services/flash_card_service.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/data/services/listening_service.dart';
import 'package:fluentzy/data/services/speaking_service.dart';
import 'package:fluentzy/data/services/stt_service.dart';
import 'package:fluentzy/data/services/tts_service.dart';
import 'package:fluentzy/firebase_options.dart';
import 'package:fluentzy/routing/router.dart';
import 'package:fluentzy/ui/language/language_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final appDir = await getApplicationDocumentsDirectory();
  // Hive.init(appDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  await Hive.openBox<ChatMessage>('chatBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageViewModel()),
        Provider(create: (context) => TtsService()),
        Provider(create: (context) => SttService()),
        Provider(create: (context) => AiService()),
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => SpeakingService()),
        Provider(create: (context) => CameraService()),
        Provider(create: (context) => ImagePickerService()),
        Provider(create: (context) => DictionaryService()),
        Provider(create: (context) => AudioService()),
        Provider(create: (context) => ListeningService()),
        Provider(create: (context) => FlashCardService()),
        Provider(
          create: (context) => TtsRepository(context.read<TtsService>()),
        ),
        Provider(
          create: (context) => SttRepository(context.read<SttService>()),
        ),
        Provider(create: (context) => AiRepository(context.read<AiService>())),
        Provider(
          create: (context) => AuthRepository(context.read<AuthService>()),
        ),
        Provider(
          create:
              (context) => LessonRepository(
                context.read<SpeakingService>(),
                context.read<ListeningService>(),
              ),
        ),
        Provider(
          create:
              (context) =>
                  DictionaryRepository(context.read<DictionaryService>()),
        ),
        Provider(
          create:
              (context) =>
                  FlashCardRepository(context.read<FlashCardService>()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageViewModel>().locale;
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
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

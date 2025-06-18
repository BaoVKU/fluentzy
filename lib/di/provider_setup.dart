import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/data/repositories/iap_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/translation_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/ai_service.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/data/services/auth_service.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/data/services/dictionary_service.dart';
import 'package:fluentzy/data/services/flash_card_service.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/data/services/listening_service.dart';
import 'package:fluentzy/data/services/quiz_service.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/data/services/speaking_service.dart';
import 'package:fluentzy/data/services/stt_service.dart';
import 'package:fluentzy/data/services/translation_service.dart';
import 'package:fluentzy/data/services/tts_service.dart';
import 'package:fluentzy/data/services/user_service.dart';
import 'package:fluentzy/ui/language/language_view_model.dart';

List<SingleChildWidget> appProviders = [
  Provider(create: (context) => PreferenceService()),
  Provider(create: (context) => TtsService()),
  Provider(create: (context) => SttService()),
  Provider(create: (context) => AiService()),
  Provider(create: (context) => AuthService()),
  Provider(create: (context) => UserService()),
  Provider(create: (context) => SpeakingService()),
  Provider(create: (context) => CameraService()),
  Provider(create: (context) => ImagePickerService()),
  Provider(create: (context) => DictionaryService()),
  Provider(create: (context) => AudioService()),
  Provider(create: (context) => ListeningService()),
  Provider(create: (context) => FlashCardService()),
  Provider(create: (context) => QuizService()),
  Provider(create: (context) => TranslationService()),
  Provider(create: (context) => TtsRepository(context.read<TtsService>())),
  Provider(create: (context) => SttRepository(context.read<SttService>())),
  Provider(
    create:
        (context) => AiRepository(
          context.read<PreferenceService>(),
          context.read<AiService>(),
        ),
  ),
  Provider(
    create:
        (context) => AuthRepository(
          context.read<AuthService>(),
          context.read<UserService>(),
        ),
  ),
  Provider(
    create:
        (context) => LessonRepository(
          context.read<UserService>(),
          context.read<SpeakingService>(),
          context.read<ListeningService>(),
          context.read<QuizService>(),
        ),
  ),
  Provider(
    create:
        (context) => DictionaryRepository(context.read<DictionaryService>()),
  ),
  Provider(
    create:
        (context) => FlashCardRepository(
          context.read<FlashCardService>(),
          context.read<UserService>(),
        ),
  ),
  Provider(create: (context) => IapRepository(context.read<UserService>())),
  Provider(
    create:
        (context) => TranslationRepository(context.read<TranslationService>()),
  ),
  ChangeNotifierProvider(
    create: (context) => LanguageViewModel(context.read<PreferenceService>()),
  ),
];

import 'package:camera/camera.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/scanner/camera/camera_screen.dart';
import 'package:fluentzy/ui/scanner/camera/camera_view_model.dart';
import 'package:fluentzy/ui/scanner/crop/crop_screen.dart';
import 'package:fluentzy/ui/scanner/crop/crop_view_model.dart';
import 'package:fluentzy/ui/scanner/option/option_screen.dart';
import 'package:fluentzy/ui/scanner/option/option_view_model.dart';
import 'package:fluentzy/ui/scanner/result/result_screen.dart';
import 'package:fluentzy/ui/scanner/result/result_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final scannerRoutes = [
  GoRoute(
    path: AppRoutePath.scannerOptions,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => OptionViewModel(context.read<ImagePickerService>()),
          child: ScannerOptionScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.scannerCamera,
    builder:
        (context, state) => ChangeNotifierProvider(
          create: (context) => CameraViewModel(context.read<CameraService>()),
          child: ScannerCameraScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.scannerCrop,
    builder:
        (context, state) => ChangeNotifierProvider(
          create: (context) => CropViewModel(state.extra as XFile),
          child: ScannerCropScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.scannerResult,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => ScannerResultViewModel(
                context.read<AiRepository>(),
                context.read<DictionaryRepository>(),
                context.read<TtsRepository>(),
                state.extra as XFile,
              ),
          child: ScannerResultScreen(),
        ),
  ),
];

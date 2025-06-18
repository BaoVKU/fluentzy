import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/flash_card/edit/edit_screen.dart';
import 'package:fluentzy/ui/flash_card/edit/edit_view_model.dart';
import 'package:fluentzy/ui/flash_card/learn/learn_screen.dart';
import 'package:fluentzy/ui/flash_card/learn/learn_view_model.dart';
import 'package:fluentzy/ui/flash_card/list/list_screen.dart';
import 'package:fluentzy/ui/flash_card/list/list_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final flashCardRoutes = [
  GoRoute(
    path: AppRoutePath.flashCardList,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) =>
                  FlashCardListViewModel(context.read<FlashCardRepository>()),
          child: FlashCardListScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.flashCardCreate,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => FlashCardEditViewModel(
                context.read<AuthRepository>(),
                context.read<FlashCardRepository>(),
                context.read<AiRepository>(),
                null,
              ),
          child: FlashCardEditScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.flashCardEdit,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => FlashCardEditViewModel(
                context.read<AuthRepository>(),
                context.read<FlashCardRepository>(),
                context.read<AiRepository>(),
                state.extra as FlashCardSet,
              ),
          child: FlashCardEditScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.flashCardLearn,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => FlashCardLearnViewModel(
                context.read<FlashCardRepository>(),
                state.extra as FlashCardSet,
              ),
          child: const FlashCardLearnScreen(),
        ),
  ),
];

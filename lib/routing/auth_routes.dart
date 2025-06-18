import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/login/login_screen.dart';
import 'package:fluentzy/ui/login/login_view_model.dart';
import 'package:fluentzy/ui/register/register_screen.dart';
import 'package:fluentzy/ui/register/register_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final authRoutes = [
  GoRoute(
    path: AppRoutePath.login,
    builder:
        (context, state) => ChangeNotifierProvider(
          create: (context) => LoginViewModel(context.read<AuthRepository>()),
          child: LoginScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.register,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => RegisterViewModel(context.read<AuthRepository>()),
          child: RegisterScreen(),
        ),
  ),
];

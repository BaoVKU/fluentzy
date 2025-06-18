import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    if (viewModel.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutePath.home);
      });
    }

    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 480,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        width: 48,
                        height: 48,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Fluentzy",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.loginAndContinue,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Email", style: TextStyle(fontSize: 12)),
                            Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: AppColors.primary.withAlpha(
                                    (0.2 * 255).toInt(),
                                  ),
                                  cursorColor: AppColors.primary,
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "user@gmail.com",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.password,
                              style: TextStyle(fontSize: 12),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: AppColors.primary.withAlpha(
                                    (0.2 * 255).toInt(),
                                  ),
                                  cursorColor: AppColors.primary,
                                ),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText:
                                      AppLocalizations.of(
                                        context,
                                      )!.enterYourPassword,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            FilledButton(
                              onPressed: () {
                                viewModel.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.primary,
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 48),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.continueStr,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(AppLocalizations.of(context)!.or),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.privacyPolicy,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.secondary),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.dontHaveAccountYet,
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.go(AppRoutePath.register);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.signUp,
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

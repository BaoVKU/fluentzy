import 'package:fluentzy/extensions/string_ext.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_code/language_code.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    if (viewModel.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutePath.login);
      });
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.onSecondary,
        backgroundColor: AppColors.background,
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      viewModel.user?.email ??
                          AppLocalizations.of(context)!.noEmail,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Divider(color: AppColors.border, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.iSpeak,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LanguageCodes.fromCode(
                        viewModel.user?.nativeLangCode ?? 'en',
                      ).nativeName,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Divider(color: AppColors.border, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.planOfEducation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      viewModel.user?.plan.capitalize() ??
                          AppLocalizations.of(context)!.free,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Divider(color: AppColors.border, thickness: 1),
                GestureDetector(
                  onTap: () {
                    context.go(RoutePath.language);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.interfaceLanguage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        viewModel.currentLanguageName ??
                            AppLocalizations.of(context)!.english,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.border, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.support,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.contactUs,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Divider(color: AppColors.border, thickness: 1),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: Text(
                            AppLocalizations.of(context)!.confirmLogout,
                          ),
                          content: Text(
                            AppLocalizations.of(context)!.areYouSureLogout,
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.onSecondary,
                              ),
                              onPressed: () {
                                context.pop(); // Close the dialog
                              },
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                context.pop(); // Close the dialog
                                await viewModel
                                    .logout(); // Call the logout method
                              },
                              child: Text(AppLocalizations.of(context)!.logout),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

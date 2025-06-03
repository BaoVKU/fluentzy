import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DialogExtension on BuildContext {
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.background),
          ),
        );
      },
    );
  }

  void hideLoadingDialog() {
    pop();
  }

  void showInputDialog({
    required String title,
    required String labelText,
    String initValue = '',
    required Function(String) onSaved,
  }) {
    showDialog(
      context: this,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        controller.text = initValue; // Set the initial value

        return AlertDialog(
          title: Text(title),
          titleTextStyle: TextStyle(color: AppColors.onSecondary, fontSize: 20),
          content: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: AppColors.primary.withAlpha(
                  (0.2 * 255).toInt(),
                ),
                cursorColor: AppColors.primary,
              ),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: AppColors.onSecondary),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.onSecondary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                pop(); // Close the dialog
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppColors.onSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final setName = controller.text.trim();
                if (setName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.fieldCannotBeEmpty,
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                onSaved(setName); // Call the function passed from the parent
                pop(); // Close the dialog
              },
              child: Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}

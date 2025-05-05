import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  int _selectedPlan = 0;

  void _onPlanSelected(int plan) {
    setState(() {
      _selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Premium'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 520,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "More than 100.000 people have purchased Premium",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "14 days money back guarantee",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => _onPlanSelected(0),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _selectedPlan == 0
                                        ? AppColors.surface
                                        : AppColors.surface,
                                border: Border.all(
                                  color:
                                      _selectedPlan == 0
                                          ? AppColors.primary
                                          : AppColors.border,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Base Plan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "0\$",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '• Access to daily practice with limited exercises\n• Basic vocabulary flashcards\n• Text-based conversation feature\n• Standard learning paths\n• Limited AI explanation support\n• Ads supported experience\n',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => _onPlanSelected(1),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _selectedPlan == 1
                                        ? AppColors.surfacePrimary
                                        : AppColors.surface,
                                border: Border.all(
                                  color:
                                      _selectedPlan == 1
                                          ? AppColors.primary
                                          : AppColors.border,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Premium Plan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "20\$",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '• Unlimited access to all practice exercises and flashcards\n• AI-powered pronunciation feedback\n• Interactive conversation chat with advanced AI support\n• Personalized learning paths tailored to your progress\n• Offline mode for all content\n• Ad-free experience\n• Early access to new features and updates\n• Support for image-based translation and rich explanations',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Restore purchase",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {},
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
                      child: Text("Try 7 days free"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

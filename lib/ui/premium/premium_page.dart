import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/premium/premium_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PremiumViewModel>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.onSecondary,
        backgroundColor: AppColors.background,
        title: Text(AppLocalizations.of(context)!.premium),
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
                      AppLocalizations.of(context)!.premiumTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.moneyBackGuarantee,
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
                            onTap: () => viewModel.selectPlan(0),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    viewModel.selectedPlanIndex == 0
                                        ? AppColors.surface
                                        : AppColors.surface,
                                border: Border.all(
                                  color:
                                      viewModel.selectedPlanIndex == 0
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
                                    AppLocalizations.of(context)!.basePlan,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.basePlanPrice,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.basePlanDescription,
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
                            onTap: () => viewModel.selectPlan(1),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    viewModel.selectedPlanIndex == 1
                                        ? AppColors.surfacePrimary
                                        : AppColors.surface,
                                border: Border.all(
                                  color:
                                      viewModel.selectedPlanIndex == 1
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
                                    AppLocalizations.of(context)!.premiumPlan,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.premiumPlanPrice,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.premiumPlanDescription,
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
                    Visibility(
                      visible: viewModel.currentPlan == 'premium',
                      child: TextButton(
                        onPressed: viewModel.restorePurchase,
                        child: Text(
                          AppLocalizations.of(context)!.restorePurchase,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: viewModel.currentPlan == 'free',
                      child: FilledButton(
                        onPressed: viewModel.purchasePremium,
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
                        child: Text(AppLocalizations.of(context)!.try7DaysFree),
                      ),
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

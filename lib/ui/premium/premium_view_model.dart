import 'package:fluentzy/data/repositories/iap_repository.dart';
import 'package:flutter/material.dart';

class PremiumViewModel extends ChangeNotifier {
  final IapRepository _iapRepository;
  int _selectedPlanIndex = 0;
  int get selectedPlanIndex => _selectedPlanIndex;
  String get currentPlan => _iapRepository.currentPlan;

  PremiumViewModel(this._iapRepository) {
    setupPlans();
  }

  void setupPlans() {
    if (_iapRepository.currentPlan == 'premium') {
      _selectedPlanIndex = 1;
    } else {
      _selectedPlanIndex = 0;
    }
    notifyListeners();
  }

  void selectPlan(int plan) {
    if (_selectedPlanIndex != plan && _iapRepository.currentPlan == 'free') {
      _selectedPlanIndex = plan;
      notifyListeners();
    }
  }

  void purchasePremium() async {
    await _iapRepository.purchasePlan('premium');
    setupPlans();
    notifyListeners();
  }

  void restorePurchase() async {
    await _iapRepository.purchasePlan('free');
    setupPlans();
    notifyListeners();
  }
}

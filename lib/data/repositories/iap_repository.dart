import 'package:fluentzy/data/services/user_service.dart';

class IapRepository {
  final UserService _userService;
  String get currentPlan => _userService.currentUser?.plan ?? 'free';
  IapRepository(this._userService);

  Future<bool> purchasePlan(String plan) async {
    try {
      await _userService.updatePlanById(_userService.currentUser!.id, plan);
      await _userService.fetchAppUser(_userService.currentUser!.id);
      return true; 
    } catch (e) {
      return false; 
    }
  }
}
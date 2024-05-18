import 'package:demogp/src/core/model/user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final RxString gender = ''.obs;
  final RxString age = ''.obs;
  final RxString username = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  var isLoggedIn = false.obs;
  RxBool notification = false.obs;
  RxBool isSwitched = false.obs;

  @override
  void onInit() {
    super.onInit();
    logIn();
    checkLoginStatus();
    loadSwitchState();
  }

  Future<void> loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    isSwitched(prefs.getBool('switchState') ?? false);
  }

  Future<void> saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchState', value);
    isSwitched(value);
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  void logIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    isLoggedIn.value = true;
  }

  void setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    isLoggedIn.value = value;
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    email.value = prefs.getString('email') ?? '';
    phone.value = prefs.getString('phone') ?? '';
  }

  Future<void> saveUserInfo(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user.name);
    await prefs.setString('email', user.email);

    await prefs.setBool('isLoggedIn', true);

    username.value = user.name;
    email.value = user.email;
    isLoggedIn.value = true;
  }

  Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('switchState', false);

    username.value = '';
    email.value = '';
    phone.value = '';
    gender.value = '';
    age.value = '';
    isLoggedIn.value = false;
    notification.value = false;
    isSwitched.value = false;
  }
}

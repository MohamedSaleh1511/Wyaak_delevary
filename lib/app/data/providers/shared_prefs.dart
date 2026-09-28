import 'package:shared_preferences/shared_preferences.dart';
// import 'constants.dart';

class SharedPrefsHelper {
  static SharedPreferences? prefs;

/*----------------------------------------------------------------------------*/
/*----------------------------  Initialize Prefs  ----------------------------*/
/*----------------------------------------------------------------------------*/
  static initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

/*----------------------------------------------------------------------------*/
/*------------------------------  Access Token  ------------------------------*/
/*----------------------------------------------------------------------------*/
  static void saveApiKeyToPrefs(accessToken) async {
    await initPrefs();
    prefs!.setString('accessToken', accessToken);
  }

  static Future<String?> getApiTokenFromPrefs() async {
    await initPrefs();
    String? accessTokenSaved = prefs!.getString('accessToken');
    return accessTokenSaved;
  }

  static Future removeToken() async {
    await initPrefs();
    prefs!.remove('accessToken');
  }

/*----------------------------------------------------------------------------*/
/*---------------------------------  User Id  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static void saveUserIdToPrefs(userid) async {
    await initPrefs();
    prefs!.setInt('userId', userid);
  }

  static Future<int?> getUserIdFromPrefs() async {
    await initPrefs();
    int? userIdSaved = prefs!.getInt('userId');
    return userIdSaved;
  }

  static Future removeUserId() async {
    await initPrefs();
    prefs!.remove('userId');
  }

/*----------------------------------------------------------------------------*/
/*----------------------------  User Notifiable  -----------------------------*/
/*----------------------------------------------------------------------------*/
  static void saveUserNotifiable(bool notifiable) async {
    await initPrefs();
    prefs!.setBool('notifiable', notifiable);
  }

  static Future<bool?> getUserNotifiable() async {
    await initPrefs();
    bool? userIdSaved = prefs!.getBool('notifiable');
    return userIdSaved;
  }

  static Future removeUserNotifiable() async {
    await initPrefs();
    prefs!.remove('notifiable');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  Language  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static storeLanguage(String language) async {
    await initPrefs();
    await prefs!.setString('lang', language);
  }

  static Future<String?> getLanguage() async {
    await initPrefs();
    return prefs?.getString('lang');
  }

  static removeLanguage() async {
    await initPrefs();
    prefs?.remove('lang');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  Country  ---------------------------------*/
/*----------------------------------------------------------------------------*/
  static storeCurrencyCode(String code) async {
    await initPrefs();
    await prefs!.setString('country', code);
  }

  static Future<String?> getCurrencyCode() async {
    await initPrefs();
    return prefs?.getString('country');
  }

  static removeCurrency() async {
    await initPrefs();
    prefs?.remove('country');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  User Type  -------------------------------*/
/*----------------------------------------------------------------------------*/
  static saveUserName(String name) async {
    await initPrefs();
    await prefs!.setString('userName', name);
  }

  static Future<String?> getUserName() async {
    await initPrefs();
    return prefs!.getString('userName');
  }

  static removeUserName() async {
    await initPrefs();
    prefs!.remove('userName');
  }

  static saveUserImg(String img) async {
    await initPrefs();
    await prefs!.setString('userImg', img);
  }

  static Future<String?> getUserImg() async {
    await initPrefs();
    return prefs!.getString('userImg');
  }

  static removeUserImg() async {
    await initPrefs();
    prefs!.remove('userImg');
  }

  static saveNotificationStatus(bool status) async {
    await initPrefs();
    await prefs!.setBool('notificationStatus', status);
  }

  static Future<bool?> getNotificationStatus() async {
    await initPrefs();
    return prefs!.getBool('notificationStatus');
  }

  static removeNotificationStatus() async {
    await initPrefs();
    prefs!.remove('notificationStatus');
  }

  static saveUserPhone(String phone) async {
    await initPrefs();
    await prefs!.setString('userPhone', phone);
  }

  static Future<String?> getUserPhone() async {
    await initPrefs();
    return prefs!.getString('userPhone');
  }

  static removeUserPhone() async {
    await initPrefs();
    prefs!.remove('userPhone');
  }

/*----------------------------------------------------------------------------*/
/*--------------------------------  First time  --------------------------------*/
/*----------------------------------------------------------------------------*/
  static void storeisFirstTime(bool isFirstTime) async {
    await initPrefs();
    prefs!.setBool('isFirstTime', isFirstTime);
  }

  static Future<bool?> getIsFirstTime() async {
    await initPrefs();
    bool? isFirstTimeSaved = prefs!.getBool('isFirstTime');
    return isFirstTimeSaved;
  }

  static removeIsFirstTime() async {
    await initPrefs();
    prefs!.remove('isFirstTime');
  }
}

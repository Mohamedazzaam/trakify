import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  //! shred preferences
  static late SharedPreferences sharedPreferences;

  //! Flutter secure storage
  static late FlutterSecureStorage flutterSecureStorage;

  //! Here The Initialize of cache .
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    flutterSecureStorage = const FlutterSecureStorage();
  }

  //! this method to put data in local database using key
  /// [key] is the key of the data that you want to get
  String? getDataString({required String key}) {
    return sharedPreferences.getString(key);
  }

  //! this method to put data in local database using key
  /// [key] is the key of the data that you want to save
  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

  //! this method to get data already saved in local database
  /// [key] is the key of the data that you want to get
  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  //! remove data using specific key
  /// [key] is the key of the data that you want to remove
  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  //! this method to check if local database contains {key}
  /// [key] is the key of the data that you want to check
  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  //! clear all data in the local database

  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

  //! this method to put data in local database using key
  /// [key] is the key of the data that you want to save
  Future<dynamic> put({required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else {
      return await sharedPreferences.setInt(key, value);
    }
  }

  //! save secured data
  /// [key] is the key of the data that you want to save
  Future<void> saveSecuredData({
    required String key,
    required String value,
  }) async {
    await flutterSecureStorage.write(key: key, value: value);
  }

  //! get secured data
  /// [key] is the key of the data that you want to get
  Future<String?> getSecuredData({required String key}) async {
    return await flutterSecureStorage.read(key: key);
  }

  //! Remove secured data
  /// [key] is the key of the data that you want to remove
  Future<void> removeSecuredData({required String key}) async {
    await flutterSecureStorage.delete(key: key);
  }

  //! Check if secured data exists
  /// [key] is the key of the data that you want to check
  Future<bool> containsSecuredKey({required String key}) async {
    return await flutterSecureStorage.containsKey(key: key);
  }

  //! Clear all secured data
  Future<void> clearSecuredData() async {
    await flutterSecureStorage.deleteAll();
  }
}

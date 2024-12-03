import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  // TextEditingController for managing input fields
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> updatePassword(String token) async {
    isLoading.value = true;
    try {
      var postUri = Uri.parse(baseUrl + '/change-password');
      var request = http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer$token';
      request.headers['ApiKey'] = '$apiKey';

      request.fields['old_password'] = oldPasswordController.text;
      request.fields['new_password'] = newPasswordController.text;
      request.fields['confirm_password'] = confirmPasswordController.text;

      var response = await request.send();
      var jsonResponse = await http.Response.fromStream(response);
      var jsonString = jsonDecode(jsonResponse.body);

      if (!jsonString['success']) {
        CustomSnackBar().snackBarError(jsonString['message']);
      } else {
        CustomSnackBar().snackBarSuccess(jsonString['message']);
        // Clear the token and fields if needed
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      print('Error: $e');
      CustomSnackBar().snackBarError("An error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed from memory
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

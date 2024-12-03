import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Views/Account/controllers/change_password_controller.dart';
import 'package:lms_flutter_app/Views/Account/widgets/auth_textfield.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController controller =
        Get.put(ChangePasswordController());
    final GetStorage userToken = GetStorage();
    String tokenKey = "token";

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: false,
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Form(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "${stctrl.lang['Change Password']}",
                            style: Get.textTheme.titleMedium,
                          ),
                          SizedBox(width: 50),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      controller: controller.oldPasswordController,
                      hintText: "${stctrl.lang['Old Password']}",
                      obscureText: true,
                      suffixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        return '';
                      },
                    ),
                    AuthTextField(
                      controller: controller.newPasswordController,
                      hintText: "${stctrl.lang['New Password']}",
                      obscureText: true,
                      suffixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        return '';
                      },
                    ),
                    AuthTextField(
                      controller: controller.confirmPasswordController,
                      hintText: "${stctrl.lang['Confirm Password']}",
                      obscureText: true,
                      suffixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        if (value != controller.newPasswordController.text) {
                          return "${stctrl.lang['New Password and Confirm Password is not same']}";
                        }
                        return '';
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        height: 46,
                        width: 185,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${stctrl.lang['Update Password']}",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        controller.updatePassword(userToken.read(tokenKey));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Text(
                          "${stctrl.lang['Cancel']}",
                          style: TextStyle(color: Color(0xff8E99B7)),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Views/Account/register_page.dart';
import 'package:lms_flutter_app/Views/Account/widgets/auth_textfield.dart';
import 'package:lms_flutter_app/Views/Account/widgets/social_login_options.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

// ignore: must_be_immutable
class SignInPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showSearch: false,
        goToSearch: false,
        showFilterBtn: false,
        showBack: false,
      ),
      body: Obx(() {
        if (controller.isRegisterScreen.value) {
          return RegisterPage();
        } else {
          return Container(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      height: 70,
                      width: 70,
                      child: Image.asset('images/signin_img.png'),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: Text(
                          "${stctrl.lang['Sign In']}",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    AuthTextField(
                      controller: controller.email,
                      hintText: '${stctrl.lang['Enter Your Email']}',
                      suffixIcon: Icons.email,
                    ),
                    // SizedBox(height: 15),
                    AuthTextField(
                      controller: controller.password,
                      hintText: "${stctrl.lang["Password"]}",
                      obscureText: controller.obscurePass.value,
                      suffixIcon: controller.obscurePass.value
                          ? Icons.lock_rounded
                          : Icons.lock_open,
                      onSuffixIconTap: () {
                        controller.obscurePass.value =
                            !controller.obscurePass.value;
                      },
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Container(
                        child: Text(
                          controller.loginMsg.value,
                          style: TextStyle(
                            color: Color(0xff8E99B7),
                            fontSize: 14,
                            fontFamily: 'AvenirNext',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 100),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "${stctrl.lang["Sign In"]}",
                          ),
                        ),
                        onTap: () async {
                          controller.obscurePass.value = true;
                          await controller.fetchUserLogin();
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    (facebookLogin || googleLogin)
                        ? SocialLoginOptions(controller: controller)
                        : SizedBox.shrink(),
                    Center(
                      child: InkWell(
                        onTap: () {
                          controller.showRegisterScreen();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "${stctrl.lang["Don\'t have an Account? Register now"]}",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                  ],
                );
              }
            }),
          );
        }
      }),
    );
  }
}

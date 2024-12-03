// Dart imports:
import 'dart:convert';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Package imports:

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';

import 'package:lms_flutter_app/utils/CustomSnackBar.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

Widget descriptionWidget(
    {required HomeController controller,
    required DashboardController dashboardController,
    required double percentageHeight,
    required double percentageWidth,
    required BuildContext context}) {
  return ExtendedVisibilityDetector(
    uniqueKey: const Key('Tab1'),
    child: Obx(() {
      return Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: controller.courseDetails.value.about == null &&
                      controller.courseDetails.value.about == null
                  ? HtmlWidget(
                      'NA',
                      textStyle: TextStyle(color: Colors.black),
                    )
                  : HtmlWidget(
                      '''
                    ${controller.courseDetails.value.about ?? "${controller.courseDetails.value.about}"}
                    ''',
                      customStylesBuilder: (element) {
                        if (element.classes.contains('foo')) {
                          return {'color': 'red'};
                        }
                        return null;
                      },
                      customWidgetBuilder: (element) {
                        if (element.attributes['foo'] == 'bar') {
                          // return FooBarWidget();
                        }
                        return null;
                      },
                      textStyle: Get.textTheme.titleSmall,
                    ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "${stctrl.lang["Outcome"]}",
              style: Get.textTheme.titleMedium,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: controller.courseDetails.value.outcomes == null &&
                      controller.courseDetails.value.outcomes == null
                  ? HtmlWidget(
                      'NA',
                      textStyle: TextStyle(color: Colors.black),
                    )
                  : HtmlWidget(
                      '''
                    ${controller.courseDetails.value.outcomes ?? "${controller.courseDetails.value.outcomes}"}
                    ''',
                      customStylesBuilder: (element) {
                        if (element.classes.contains('foo')) {
                          return {'color': 'red'};
                        }
                        return null;
                      },
                      customWidgetBuilder: (element) {
                        if (element.attributes['foo'] == 'bar') {
                          // return FooBarWidget();
                        }
                        return null;
                      },
                      textStyle: Get.textTheme.titleSmall,
                    ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "${stctrl.lang["Requirements"]}",
              style: Get.textTheme.titleMedium,
            ),
            Container(
              width: percentageWidth * 100,
              // height: percentageHeight * 25,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: HtmlWidget(
                '''
                    ${controller.courseDetails.value.requirements ?? "NA"}
                    ''',
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.attributes['foo'] == 'bar') {
                    // return FooBarWidget();
                  }
                  return null;
                },
                textStyle: Get.textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dashboardController.loggedIn.value
            ? controller.isCourseBought.value
                ? SizedBox.shrink()
                : controller.courseDetails.value.price == 0
                    ? ElevatedButton(
                        child: Text(
                          "${stctrl.lang["Enroll the Course"]}",
                          style: Get.textTheme.titleSmall
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        style: Get.theme.elevatedButtonTheme.style,
                        onPressed: () async {
                          await controller
                              .buyNow(controller.courseDetails.value.id)
                              .then((value) async {
                            if (value) {
                              await Future.delayed(Duration(seconds: 5), () {
                                Get.back();
                                dashboardController
                                    .changeTabIndex(Platform.isIOS ? 1 : 2);
                              });
                            }
                          });
                        },
                      )
                    : controller.cartAdded.value && !Platform.isIOS
                        ? ElevatedButton(
                            child: Text(
                              "${stctrl.lang["View On Cart"]}",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Get.back();
                              stctrl.dashboardController.persistentTabController
                                  .jumpToTab(1);
                              dashboardController.changeTabIndex(1);
                              Get.back();
                            },
                          )
                        : ElevatedButton(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: controller.isPurchasingIAP.value
                                  ? CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${stctrl.lang["Enroll the Course"]}",
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${controller.courseDetails.value.discountPrice == null || controller.courseDetails.value.discountPrice == 0 ? controller.courseDetails.value.price.toString() : controller.courseDetails.value.discountPrice.toString()} $appCurrency",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                            ),
                            onPressed: () async {
                              if (Platform.isIOS) {
                                try {
                                  print(
                                      "IAP Product ID -> ${controller.courseDetails.value.iapProductId}");
                                  controller.isPurchasingIAP.value = true;
                                  CustomerInfo purchaserInfo =
                                      await Purchases.purchaseProduct(controller
                                              .courseDetails
                                              .value
                                              .iapProductId ??
                                          '');
                                  print(jsonEncode(purchaserInfo.toJson()));

                                  await controller
                                      .enrollIAP(
                                          controller.courseDetails.value.id)
                                      .then((value) {
                                    Get.back();
                                    dashboardController.changeTabIndex(1);
                                  });
                                  controller.isPurchasingIAP.value = false;
                                } on PlatformException catch (e) {
                                  var errorCode =
                                      PurchasesErrorHelper.getErrorCode(e);
                                  if (errorCode ==
                                      PurchasesErrorCode
                                          .purchaseCancelledError) {
                                    print("Cancelled");
                                    CustomSnackBar()
                                        .snackBarWarning("Cancelled");
                                  } else if (errorCode ==
                                      PurchasesErrorCode
                                          .purchaseNotAllowedError) {
                                    CustomSnackBar().snackBarWarning(
                                        "User not allowed to purchase");
                                  } else if (errorCode ==
                                      PurchasesErrorCode.paymentPendingError) {
                                    CustomSnackBar()
                                        .snackBarWarning("Payment is pending");
                                  } else {
                                    print(e);
                                  }
                                  controller.isPurchasingIAP.value = false;
                                } catch (e) {
                                  print(e);
                                  controller.isPurchasingIAP.value = false;
                                }
                              } else {
                                await controller.addToCart(controller
                                    .courseDetails.value.id
                                    .toString());
                              }
                            },
                          )
            : ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  stctrl.dashboardController.persistentTabController
                      .jumpToTab(1);
                  dashboardController.changeTabIndex(1);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD7598F)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${stctrl.lang["Enroll the Course"]}",
                      style: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      controller.courseDetails.value.discountPrice == null ||
                              controller.courseDetails.value.discountPrice == 0
                          ? (controller.courseDetails.value.price == null ||
                                  controller.courseDetails.value.price == 0
                              ? ''
                              : '${controller.courseDetails.value.price.toString()} $appCurrency')
                          : '${controller.courseDetails.value.discountPrice.toString()} $appCurrency',
                      style: Get.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
      );
    }),
  );
}

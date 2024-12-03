import 'dart:convert';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Model/Class/BbbMeeting.dart';
import 'package:lms_flutter_app/Model/Class/JitsiMeeting.dart';
import 'package:lms_flutter_app/Model/Class/ZoomMeeting.dart';

import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Widget scheduleWidget(
    {required ClassController controller,
    required DashboardController dashboardController,
    double? percentageHeight,
    double? percentageWidth}) {
  return ExtendedVisibilityDetector(
    uniqueKey: const Key('Tab1'),
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: controller.classDetails.value.dataClass != null
            ? controller.classDetails.value.dataClass?.host == 'Zoom'
                ? ListView.separated(
                    itemCount: controller.classDetails.value.dataClass
                            ?.zoomMeetings?.length ??
                        0,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemBuilder: (context, zoomIndex) {
                      ZoomMeeting zoomMeeting = controller.classDetails.value
                              .dataClass?.zoomMeetings?[zoomIndex] ??
                          ZoomMeeting();
                      bool showPlayBtn = false;
                      bool showLiveBtn = false;
                      int now = DateTime.now().millisecondsSinceEpoch;
                      if (now >
                              (zoomMeeting.startTime?.millisecondsSinceEpoch ??
                                  0) &&
                          now <
                              (zoomMeeting.endTime?.millisecondsSinceEpoch ??
                                  0)) {
                        showPlayBtn = true;
                        showLiveBtn = true;
                      } else if (now >
                          (zoomMeeting.endTime?.millisecondsSinceEpoch ?? 0)) {
                        showPlayBtn = false;
                        showLiveBtn = false;
                      } else if (now <
                          (zoomMeeting.startTime?.millisecondsSinceEpoch ??
                              0)) {
                        showPlayBtn = true;
                        showLiveBtn = false;
                      }
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: showPlayBtn
                                ? showLiveBtn
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("${stctrl.lang["Start Date"]}"),
                                courseStructure(
                                  CustomDate().formattedDate(controller
                                      .classDetails
                                      .value
                                      .dataClass
                                      ?.zoomMeetings?[zoomIndex]
                                      .startTime),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("${stctrl.lang["Time (Start-End)"]}"),
                                courseStructure(
                                  '${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass?.zoomMeetings?[zoomIndex].startTime)} - ${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass?.zoomMeetings?[zoomIndex].endTime)}',
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("${stctrl.lang["Duration"]}"),
                                courseStructure(
                                  CustomDate().durationToString(int.parse(
                                          controller
                                                  .classDetails
                                                  .value
                                                  .dataClass
                                                  ?.zoomMeetings?[zoomIndex]
                                                  .meetingDuration ??
                                              '')) +
                                      ' Hr(s)',
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            showPlayBtn
                                ? showLiveBtn
                                    ? Icon(FontAwesomeIcons.solidPlayCircle)
                                    : Icon(FontAwesomeIcons.solidPauseCircle)
                                : Icon(FontAwesomeIcons.solidStopCircle),
                          ],
                        ),
                      );
                    })
                : controller.classDetails.value.dataClass?.host == 'Jitsi'
                    ? ListView.builder(
                        itemCount: controller.classDetails.value.dataClass
                            ?.jitsiMeetings?.length,
                        itemBuilder: (context, jitsiIndex) {
                          JitsiMeeting jitsiMeeting = controller
                                  .classDetails
                                  .value
                                  .dataClass
                                  ?.jitsiMeetings?[jitsiIndex] ??
                              JitsiMeeting();

                          bool showPlayBtn = false;
                          bool showLiveBtn = false;
                          DateTime startDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(jitsiMeeting.datetime ?? '') *
                                      1000);
                          DateTime endDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  (int.parse(jitsiMeeting.datetime ?? '') +
                                          ((jitsiMeeting.duration ?? 0) * 60)) *
                                      1000);
                          int now = DateTime.now().millisecondsSinceEpoch;
                          if (now > startDate.millisecondsSinceEpoch &&
                              now < endDate.millisecondsSinceEpoch) {
                            showPlayBtn = true;
                            showLiveBtn = true;
                          } else if (now > endDate.millisecondsSinceEpoch) {
                            showPlayBtn = false;
                            showLiveBtn = false;
                          } else if (now < startDate.millisecondsSinceEpoch) {
                            showPlayBtn = true;
                            showLiveBtn = false;
                          }
                          return Container(
                            decoration: BoxDecoration(
                                color: showPlayBtn
                                    ? showLiveBtn
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.blue.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal("${stctrl.lang["Start Date"]}"),
                                    courseStructure(
                                      CustomDate().formattedDate(startDate),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal(
                                        "${stctrl.lang["Time (Start-End)"]}"),
                                    courseStructure(
                                      '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal("${stctrl.lang["Duration"]}"),
                                    courseStructure(
                                      CustomDate().durationToString(controller
                                                  .classDetails
                                                  .value
                                                  .dataClass
                                                  ?.jitsiMeetings?[jitsiIndex]
                                                  .duration ??
                                              0) +
                                          ' Hr(s)',
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                showPlayBtn
                                    ? showLiveBtn
                                        ? Icon(FontAwesomeIcons.solidPlayCircle)
                                        : Icon(
                                            FontAwesomeIcons.solidPauseCircle)
                                    : Icon(FontAwesomeIcons.solidStopCircle),
                              ],
                            ),
                          );
                        })
                    : controller.classDetails.value.dataClass?.host == 'BBB'
                        ? ListView.builder(
                            itemCount: controller.classDetails.value.dataClass
                                ?.bbbMeetings?.length,
                            itemBuilder: (context, bbbIndex) {
                              BbbMeeting bbbMeeting = controller
                                      .classDetails
                                      .value
                                      .dataClass
                                      ?.bbbMeetings?[bbbIndex] ??
                                  BbbMeeting();

                              bool showPlayBtn = false;
                              bool showLiveBtn = false;
                              DateTime startDate =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(bbbMeeting.datetime ?? '') *
                                          1000);
                              DateTime endDate =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (int.parse(bbbMeeting.datetime ?? '') +
                                                  (bbbMeeting.duration * 60))
                                              .toInt() *
                                          1000);
                              // DateTime.fromMillisecondsSinceEpoch((int.parse(bbbMeeting.datetime) + (bbbMeeting.duration * 60)) * 1000);
                              int now = DateTime.now().millisecondsSinceEpoch;
                              if (now > startDate.millisecondsSinceEpoch &&
                                  now < endDate.millisecondsSinceEpoch) {
                                showPlayBtn = true;
                                showLiveBtn = true;
                              } else if (now > endDate.millisecondsSinceEpoch) {
                                showPlayBtn = false;
                                showLiveBtn = false;
                              } else if (now <
                                  startDate.millisecondsSinceEpoch) {
                                showPlayBtn = true;
                                showLiveBtn = false;
                              }

                              return Container(
                                decoration: BoxDecoration(
                                    color: showPlayBtn
                                        ? showLiveBtn
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal(
                                            "${stctrl.lang["Start Date"]}"),
                                        courseStructure(
                                          CustomDate().formattedDate(startDate),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal(
                                            "${stctrl.lang["Time (Start-End)"]}"),
                                        courseStructure(
                                          '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal("${stctrl.lang["Duration"]}"),
                                        courseStructure(
                                          CustomDate().durationToString(
                                                  controller
                                                      .classDetails
                                                      .value
                                                      .dataClass
                                                      ?.bbbMeetings?[bbbIndex]
                                                      .duration) +
                                              ' Hr(s)',
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    showPlayBtn
                                        ? showLiveBtn
                                            ? Icon(FontAwesomeIcons
                                                .solidPlayCircle)
                                            : Icon(FontAwesomeIcons
                                                .solidPauseCircle)
                                        : Icon(
                                            FontAwesomeIcons.solidStopCircle),
                                  ],
                                ),
                              );
                            })
                        : Container()
            : Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: dashboardController.loggedIn.value
          ? controller.isClassBought.value
              ? Container()
              : controller.classDetails.value.price == 0
                  ? ElevatedButton(
                      child: Text(
                        "${stctrl.lang["Enroll the Class"]}",
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      style: Get.theme.elevatedButtonTheme.style,
                      onPressed: () async {
                        await controller
                            .buyNow(controller.classDetails.value.id)
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
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffffffff),
                                height: 1.3,
                                fontFamily: 'AvenirNext'),
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
                                        "${controller.classDetails.value.discountPrice == null || controller.classDetails.value.discountPrice == 0 ? '${controller.classDetails.value.price ?? ''}' : '${controller.classDetails.value.discountPrice ?? ''}'} $appCurrency",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ),
                          onPressed: () async {
                            if (Platform.isIOS) {
                              try {
                                print(
                                    "IAP Product ID -> ${controller.classDetails.value.iapProductId}");
                                controller.isPurchasingIAP.value = true;
                                CustomerInfo purchaserInfo =
                                    await Purchases.purchaseProduct(controller
                                            .classDetails.value.iapProductId ??
                                        '');
                                print(jsonEncode(purchaserInfo.toJson()));

                                await controller
                                    .enrollIAP(controller.classDetails.value.id)
                                    .then((value) {
                                  Get.back();
                                  dashboardController.changeTabIndex(1);
                                });
                                controller.isPurchasingIAP.value = false;
                              } on PlatformException catch (e) {
                                var errorCode =
                                    PurchasesErrorHelper.getErrorCode(e);
                                if (errorCode ==
                                    PurchasesErrorCode.purchaseCancelledError) {
                                  print("Cancelled");
                                  CustomSnackBar().snackBarWarning("Cancelled");
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
                              await controller.addToCart(
                                  controller.classDetails.value.id.toString());
                            }
                          },
                        )
          : ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                stctrl.dashboardController.persistentTabController.jumpToTab(1);
                dashboardController.changeTabIndex(1);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFD7598F)),
              child: Container(
                width: (percentageWidth ?? 0) * 42,
                height: (percentageHeight ?? 0) * 5,
                alignment: Alignment.center,
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
                      controller.classDetails.value.discountPrice == null ||
                              controller.classDetails.value.discountPrice == 0
                          ? (controller.classDetails.value.price == null ||
                                  controller.classDetails.value.price == 0
                              ? ''
                              : '${controller.classDetails.value.price.toString()} $appCurrency')
                          : '${controller.classDetails.value.discountPrice.toString()} $appCurrency',
                      style: Get.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
    ),
  );
}

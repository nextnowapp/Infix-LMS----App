import 'dart:convert';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Model/Class/BbbMeeting.dart';
import 'package:lms_flutter_app/Model/Class/JitsiMeeting.dart';
import 'package:lms_flutter_app/Model/Class/ZoomMeeting.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/LiveClassProviders/BigBlueButtonClass.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/LiveClassProviders/JitsiMeetClass.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyClass/LiveClassProviders/ZoomClass.dart';
import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Widget scheduleWidget(
    {required ClassController controller,
    required DashboardController dashboardController,
    required GetStorage userToken,
    required String tokenKey}) {
  print(controller.classDetails.value.dataClass?.host);
  return ExtendedVisibilityDetector(
    uniqueKey: const Key('Tab1'),
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: controller.classDetails.value.dataClass?.host == 'Zoom'
            ? ListView.separated(
                itemCount: controller
                        .classDetails.value.dataClass?.zoomMeetings?.length ??
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
                          (zoomMeeting.endTime?.millisecondsSinceEpoch ?? 0)) {
                    showPlayBtn = true;
                    showLiveBtn = true;
                  } else if (now >
                      (zoomMeeting.endTime?.millisecondsSinceEpoch ?? 0)) {
                    showPlayBtn = false;
                    showLiveBtn = false;
                  } else if (now <
                      (zoomMeeting.startTime?.millisecondsSinceEpoch ?? 0)) {
                    showPlayBtn = true;
                    showLiveBtn = false;
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (showLiveBtn) {
                        final _url = RemoteServices.getJoinMeetingUrlApp(
                            mid: zoomMeeting.meetingId,
                            passcode: zoomMeeting.password);

                        // ignore: deprecated_member_use
                        if (await canLaunch(_url)) {
                          // ignore: deprecated_member_use
                          await launch(_url);
                        } else {
                          Get.to(() => ZoomLaunchMeeting(
                                meetingUrl: RemoteServices.getJoinMeetingUrlWeb(
                                    mid: zoomMeeting.meetingId,
                                    passcode: zoomMeeting.password),
                                meetingName: zoomMeeting.topic,
                              ));
                        }
                      }
                    },
                    child: Container(
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
                    ),
                  );
                })
            : controller.classDetails.value.dataClass?.host == 'Jitsi'
                ? ListView.builder(
                    itemCount: controller
                        .classDetails.value.dataClass?.jitsiMeetings?.length,
                    itemBuilder: (context, jitsiIndex) {
                      JitsiMeeting jitsiMeeting = controller.classDetails.value
                              .dataClass?.jitsiMeetings?[jitsiIndex] ??
                          JitsiMeeting();

                      bool showPlayBtn = false;
                      bool showLiveBtn = false;
                      DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(jitsiMeeting.datetime ?? '') * 1000);
                      DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
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
                      return GestureDetector(
                        onTap: () {
                          if (showLiveBtn) {
                            Get.to(() => JitsiMeetClass(
                                  meetingId: jitsiMeeting.meetingId,
                                  meetingSubject: jitsiMeeting.topic,
                                  userEmail:
                                      dashboardController.profileData.email,
                                  userName:
                                      dashboardController.profileData.name,
                                ));
                          }
                        },
                        child: Container(
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
                                      : Icon(FontAwesomeIcons.solidPauseCircle)
                                  : Icon(FontAwesomeIcons.solidStopCircle),
                            ],
                          ),
                        ),
                      );
                    })
                : controller.classDetails.value.dataClass?.host == 'BBB'
                    ? ListView.builder(
                        itemCount: controller
                            .classDetails.value.dataClass?.bbbMeetings?.length,
                        itemBuilder: (context, bbbIndex) {
                          BbbMeeting bbbMeeting = controller.classDetails.value
                                  .dataClass?.bbbMeetings?[bbbIndex] ??
                              BbbMeeting();

                          bool showPlayBtn = false;
                          bool showLiveBtn = false;
                          DateTime startDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(bbbMeeting.datetime ?? '') * 1000);
                          DateTime endDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  (int.parse(bbbMeeting.datetime ?? '') +
                                              (bbbMeeting.duration * 60))
                                          .toInt() *
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

                          return GestureDetector(
                            onTap: () async {
                              if (showLiveBtn) {
                                String token = await userToken.read(tokenKey);

                                Uri topCatUrl = Uri.parse(baseUrl +
                                    '/get-bbb-start-url/${bbbMeeting.meetingId}/${dashboardController.profileData.name}');

                                var response = await http.get(
                                  topCatUrl,
                                  headers: header(token: token),
                                );
                                if (response.statusCode == 200) {
                                  var jsonString = jsonDecode(response.body);

                                  if (jsonString['status'] == 'running') {
                                    final _url = jsonString['url'];
                                    Get.to(() => BigBlueButtonTest(
                                          meetingUrl: _url,
                                          meetingName: bbbMeeting.topic,
                                        ));
                                  } else {
                                    Get.snackbar(
                                      "${stctrl.lang["Waiting"]}",
                                      "The Live Class haven\'t started yet",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.deepOrange,
                                      colorText: Colors.white,
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "${stctrl.lang["Error"]}",
                                    "${stctrl.lang["Unable to start live class"]}",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            },
                            child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cartTotal("${stctrl.lang["Duration"]}"),
                                      courseStructure(
                                        CustomDate().durationToString(controller
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
                                          ? Icon(
                                              FontAwesomeIcons.solidPlayCircle)
                                          : Icon(
                                              FontAwesomeIcons.solidPauseCircle)
                                      : Icon(FontAwesomeIcons.solidStopCircle),
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(),
      ),
    ),
  );
}

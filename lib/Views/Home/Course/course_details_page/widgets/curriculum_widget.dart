import 'package:flutter/material.dart';
// Dart imports:
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

// Package imports:

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/download_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/utils/generate_vdo_cipher_otp.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page/widgets/show_download_alert_dialog.dart';

import 'package:lms_flutter_app/Views/VideoView/PDFViewPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoChipherPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoPlayerPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VimeoPlayerPage.dart';
import 'package:lms_flutter_app/utils/CustomExpansionTileCard.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/MediaUtils.dart';
import 'package:lms_flutter_app/utils/open_files.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_document/open_document.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

Widget curriculumWidget(
    HomeController controller, DashboardController dashboardController) {
  void _scrollToSelectedContent(GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab2'),
      child: Scaffold(
        body: ListView.separated(
          itemCount: controller.courseDetails.value.chapters?.length ?? 0,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 4,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            var lessons = controller.courseDetails.value.lessons
                ?.where((element) =>
                    int.parse(element.chapterId.toString()) ==
                    int.parse(controller.courseDetails.value.chapters![index].id
                        .toString()))
                .toList();
            var total = 0;
            lessons?.forEach((element) {
              if (element.duration != null && element.duration != "") {
                if (!element.duration!.contains("H")) {
                  total += double.parse(element.duration ?? '').toInt();
                }
              }
            });
            final GlobalKey expansionTileKey = GlobalKey();
            return CustomExpansionTileCard(
              key: expansionTileKey,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              onExpansionChanged: (isExpanded) {
                if (isExpanded) _scrollToSelectedContent(expansionTileKey);
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    (index + 1).toString() + ". ",
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    child: Text(
                      controller.courseDetails.value.chapters?[index].name ??
                          '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  total > 0
                      ? Text(
                          getTimeString(total).toString() +
                              " ${stctrl.lang["Hour(s)"]}",
                        )
                      : SizedBox.shrink()
                ],
              ),
              children: <Widget>[
                ListView.builder(
                    itemCount: lessons?.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (BuildContext context, int index) {
                      if (lessons?[index].isLock == 1) {
                        return InkWell(
                          onTap: () {
                            CustomSnackBar().snackBarWarning(
                              "${stctrl.lang["This lesson is locked. Purchase this course to get full access"]}",
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.lock,
                                        color: Get.theme.primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: lessons?[index].isQuiz == 1
                                          ? Text(
                                              lessons?[index].quiz?[0].title ??
                                                  "",
                                              style: Get.textTheme.titleSmall,
                                            )
                                          : Text(
                                              lessons?[index].name ?? "",
                                              style: Get.textTheme.titleSmall,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () async {
                            if (lessons?[index].isQuiz != 1) {
                              context.loaderOverlay.show();
                              final isVisible = context.loaderOverlay.visible;
                              print(isVisible);

                              controller.selectedLessonID.value =
                                  lessons?[index].id;

                              if (lessons?[index].host == "Vimeo") {
                                var vimeoID = lessons?[index]
                                    .videoUrl
                                    ?.replaceAll("/videos/", "");

                                Get.bottomSheet(
                                  VimeoPlayerPage(
                                    lesson: lessons?[index] ?? Lesson(),
                                    videoTitle: "${lessons?[index].name}",
                                    videoId: '$rootUrl/vimeo/video/$vimeoID',
                                  ),
                                  backgroundColor: Colors.black,
                                  isScrollControlled: true,
                                );
                                context.loaderOverlay.hide();
                              } else if (lessons?[index].host == "Youtube") {
                                Get.bottomSheet(
                                  VideoPlayerPage(
                                    "Youtube",
                                    lesson: lessons?[index] ?? Lesson(),
                                    videoID: lessons?[index].videoUrl ?? '',
                                  ),
                                  backgroundColor: Colors.black,
                                  isScrollControlled: true,
                                );
                                context.loaderOverlay.hide();
                              } else if (lessons?[index].host == "SCORM") {
                                var videoUrl;
                                videoUrl =
                                    rootUrl + (lessons?[index].videoUrl ?? '');

                                final LessonController lessonController =
                                    Get.put(LessonController());

                                await lessonController
                                    .updateLessonProgress(lessons?[index].id,
                                        lessons?[index].courseId, 1)
                                    .then((value) async {
                                  Get.bottomSheet(
                                    VimeoPlayerPage(
                                      lesson: lessons?[index] ?? Lesson(),
                                      videoTitle: lessons?[index].name ?? '',
                                      videoId: '$videoUrl',
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                });
                              } else if (lessons?[index].host == "VdoCipher") {
                                await generateVdoCipherOtp(
                                        lessons?[index].videoUrl)
                                    .then((value) {
                                  if (value['otp'] != null) {
                                    final EmbedInfo embedInfo =
                                        EmbedInfo.streaming(
                                      otp: value['otp'],
                                      playbackInfo: value['playbackInfo'],
                                      embedInfoOptions: EmbedInfoOptions(
                                        autoplay: true,
                                      ),
                                    );

                                    Get.bottomSheet(
                                      VdoCipherPage(
                                        embedInfo: embedInfo,
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else {
                                    context.loaderOverlay.hide();
                                    CustomSnackBar()
                                        .snackBarWarning(value['message']);
                                  }
                                });
                              } else {
                                var videoUrl;
                                if (lessons?[index].host == "Self") {
                                  videoUrl = rootUrl +
                                      "/" +
                                      (lessons?[index].videoUrl ?? '');
                                  Get.bottomSheet(
                                    VideoPlayerPage(
                                      "network",
                                      lesson: lessons?[index] ?? Lesson(),
                                      videoID: videoUrl,
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons?[index].host == "URL" ||
                                    lessons?[index].host == "Iframe") {
                                  videoUrl = lessons?[index].videoUrl;

                                  // Get.bottomSheet(
                                  //   VideoPlayerPage(
                                  //     "network",
                                  //     lesson: lessons?[index] ?? Lesson(),
                                  //     videoID: videoUrl,
                                  //   ),
                                  //   backgroundColor: Colors.black,
                                  //   isScrollControlled: true,
                                  // );
                                  //context.loaderOverlay.hide();

                                  Get.bottomSheet(
                                    VimeoPlayerPage(
                                      lesson: lessons?[index] ?? Lesson(),
                                      videoTitle: "${lessons?[index].name}",
                                      videoId: videoUrl,
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons?[index].host == "PDF") {
                                  videoUrl = rootUrl +
                                      "/" +
                                      (lessons?[index].videoUrl ?? '');
                                  Get.to(() => PDFViewPage(
                                        pdfLink: videoUrl,
                                      ));
                                  context.loaderOverlay.hide();
                                } else {
                                  videoUrl = lessons?[index].videoUrl;

                                  String filePath;

                                  final extension = p.extension(videoUrl);

                                  Directory applicationSupportDir =
                                      await getApplicationSupportDirectory();
                                  String appSupportPath =
                                      applicationSupportDir.path;

                                  filePath =
                                      "$appSupportPath/${companyName}_${lessons?[index].name}$extension";

                                  final isCheck =
                                      await OpenDocument.checkDocument(
                                          filePath: filePath);

                                  debugPrint("Exist: $isCheck");

                                  if (isCheck) {
                                    context.loaderOverlay.hide();
                                    await openAppFile(filePath);
                                  } else {
                                    final LessonController lessonController =
                                        Get.put(LessonController());

                                    // ignore: deprecated_member_use
                                    if (await canLaunch(
                                        rootUrl + '/' + videoUrl)) {
                                      await lessonController
                                          .updateLessonProgress(
                                              lessons?[index].id,
                                              lessons?[index].courseId,
                                              1)
                                          .then((value) async {
                                        context.loaderOverlay.hide();
                                        final DownloadController
                                            downloadController =
                                            Get.put(DownloadController());
                                        Get.dialog(showDownloadAlertDialog(
                                          context,
                                          lessons?[index].name ?? "",
                                          videoUrl,
                                          downloadController,
                                        ));
                                      });
                                    } else {
                                      context.loaderOverlay.hide();
                                      CustomSnackBar().snackBarError(
                                          "${stctrl.lang["Unable to open"]}" +
                                              " ${lessons?[index].name}");
                                      // throw 'Unable to open url : ${rootUrl + '/' + videoUrl}';
                                    }
                                  }
                                }
                              }
                            } else {
                              CustomSnackBar().snackBarWarning(
                                "${stctrl.lang["This lesson is locked. Purchase this course to get full access"]}",
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    lessons?[index].isQuiz == 1
                                        ? Icon(
                                            FontAwesomeIcons.questionCircle,
                                            color: Get.theme.primaryColor,
                                            size: 16,
                                          )
                                        : !MediaUtils.isFile(
                                                lessons?[index].host ?? '')
                                            ? Icon(
                                                Icons.play_circle_outline,
                                                color: Get.theme.primaryColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                FontAwesomeIcons.file,
                                                color: Get.theme.primaryColor,
                                                size: 16,
                                              ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: lessons?[index].isQuiz == 1
                                            ? Text(
                                                lessons?[index]
                                                        .quiz?[0]
                                                        .title
                                                        .toString() ??
                                                    "",
                                                style: Get.textTheme.titleSmall,
                                              )
                                            : Text(
                                                lessons?[index].name ?? "",
                                                style: Get.textTheme.titleSmall,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            );
          },
        ),
      ));
}

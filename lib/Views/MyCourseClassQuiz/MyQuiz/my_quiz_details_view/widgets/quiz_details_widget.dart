import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/start_quiz_page/start_quiz_page.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

Widget quizDetailsWidget(
    {required QuizController controller,
    required DashboardController dashboardController,
    required BuildContext context,
    required double percentageWidth,
    required double percentageHeight}) {
  return ExtendedVisibilityDetector(
    uniqueKey: const Key('Tab1'),
    child: Scaffold(
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Text(
            "${stctrl.lang["Instruction"]}",
            style: Get.textTheme.titleMedium,
          ),
          Container(
            width: percentageWidth * 100,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: HtmlWidget(
              '''
                ${controller.myQuizDetails.value.quiz?.instruction ?? "${controller.myQuizDetails.value.quiz?.instruction}"}
                ''',
              textStyle: Get.textTheme.titleSmall,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${stctrl.lang["Quiz Time"]}",
            style: Get.textTheme.titleMedium,
          ),
          SizedBox(
            height: 10,
          ),
          controller.myQuizDetails.value.quiz?.questionTimeType == 0
              ? Text(
                  "${controller.myQuizDetails.value.quiz?.questionTime} " +
                      "${stctrl.lang["minute(s) per question"]}",
                  style: Get.textTheme.titleSmall,
                )
              : Text(
                  "${controller.myQuizDetails.value.quiz?.questionTime} " +
                      "${stctrl.lang["minute(s)"]}",
                  style: Get.textTheme.titleSmall,
                ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: controller
                  .myQuizDetails.value.quiz?.multipleAttend ==
              1
          ? ElevatedButton(
              child: Text(
                "${stctrl.lang["Start Quiz"]}",
                style: Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "${stctrl.lang["Start Quiz"]}",
                          style: context.theme.textTheme.titleMedium,
                        ),
                        backgroundColor: Get.theme.cardColor,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            courseStructure(
                              "${stctrl.lang["Do you want to start the quiz?"]}",
                            ),
                            controller.myQuizDetails.value.quiz
                                        ?.questionTimeType ==
                                    0
                                ? courseStructure(
                                    "${stctrl.lang["Quiz Time"]}" +
                                        ": " +
                                        '${controller.myQuizDetails.value.quiz?.questionTime.toString()}' +
                                        " " +
                                        "${stctrl.lang["minute(s) per question"]}",
                                  )
                                : courseStructure(
                                    "${stctrl.lang["Quiz Time"]}" +
                                        ": " +
                                        '${controller.myQuizDetails.value.quiz?.questionTime.toString()}' +
                                        " " +
                                        "${stctrl.lang["minute(s)"]}",
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: percentageHeight * 5,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "${stctrl.lang["Cancel"]}",
                                      style: Get.textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Obx(() {
                                  return controller.isQuizStarting.value
                                      ? Container(
                                          width: 100,
                                          height: percentageHeight * 5,
                                          alignment: Alignment.center,
                                          child: CupertinoActivityIndicator())
                                      : ElevatedButton(
                                          onPressed: () async {
                                            await controller
                                                .startQuiz()
                                                .then((value) {
                                              if (value) {
                                                Navigator.of(context).pop();
                                                Get.to(() => StartQuizPage(
                                                    getQuizDetails: controller
                                                        .myQuizDetails.value));
                                              } else {
                                                Get.snackbar(
                                                  "${stctrl.lang["Error"]}",
                                                  "${stctrl.lang["Error Starting Quiz"]}",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.black,
                                                  borderRadius: 5,
                                                  duration:
                                                      Duration(seconds: 3),
                                                );
                                              }
                                            });
                                          },
                                          child: Text(
                                            "${stctrl.lang["Start"]}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xffffffff),
                                                height: 1.3,
                                                fontFamily: 'AvenirNext'),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                })
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
            )
          : Container(),
    ),
  );
}

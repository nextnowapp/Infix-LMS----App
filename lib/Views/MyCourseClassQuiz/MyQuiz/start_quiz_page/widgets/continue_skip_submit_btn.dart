import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/question_controller.dart';
import 'package:lms_flutter_app/Model/Quiz/Assign.dart';
import 'package:lms_flutter_app/Model/Quiz/QuestionMu.dart';

class ContinueSkipSubmitBtn extends StatelessWidget {
  ContinueSkipSubmitBtn({
    this.qnController,
    this.index,
    this.data,
    this.showEachSubmit,
    this.correctAnswer,
    this.formKey,
    this.type,
    this.checkBoxList,
    this.assign,
  });

  final QuestionController? qnController;
  final int? index;
  final Map? data;
  final bool? showEachSubmit;
  final List<QuestionMu>? correctAnswer;
  final GlobalKey<FormState>? formKey;
  final String? type;
  final List<CheckboxModal>? checkBoxList;
  final Assign? assign;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 0,
      top: 0,
      child: qnController!.submitSingleAnswer.value
          ? Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ))
          : Align(
              alignment: Alignment.bottomCenter,
              child: qnController!.lastQuestion.value
                  ? ElevatedButton(
                      onPressed: () async {
                        if ((type == 'S' || type == 'L') && formKey != null) {
                          if (formKey!.currentState!.validate()) {
                            await qnController
                                ?.singleSubmit(data ?? Map(), index ?? 0)
                                .then((value) {
                              if (value) {
                                qnController?.skipPress(index);
                              } else {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Error submitting answer"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              }
                            });
                          }
                        } else {
                          if (data?['ans'].length == 0) {
                            Get.snackbar(
                              "${stctrl.lang["Error"]}",
                              "${stctrl.lang["Please select an option"]}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.amber[700],
                              colorText: Colors.black,
                              borderRadius: 5,
                              duration: Duration(seconds: 3),
                            );
                          } else {
                            await qnController
                                ?.singleSubmit(data ?? Map(), index ?? 0)
                                .then((value) {
                              if (value) {
                                qnController?.skipPress(index);
                              } else {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Error submitting answer"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        "${stctrl.lang["Submit"]}",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if ((type == 'S' || type == 'L') &&
                                formKey != null) {
                              if (formKey!.currentState!.validate()) {
                                await qnController
                                    ?.singleSubmit(data ?? Map(), index ?? 0)
                                    .then((value) {
                                  if (value) {
                                    qnController?.skipPress(index);
                                  } else {
                                    Get.snackbar(
                                      "${stctrl.lang["Error"]}",
                                      "${stctrl.lang["Error submitting answer"]}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red[700],
                                      colorText: Colors.black,
                                      borderRadius: 5,
                                      duration: Duration(seconds: 3),
                                    );
                                  }
                                });
                              }
                            } else {
                              if (data?['ans'].length == 0) {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Please select an option"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.amber[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              } else {
                                await qnController
                                    ?.singleSubmit(data ?? Map(), index ?? 0)
                                    .then((value) {
                                  if (value) {
                                    qnController?.skipPress(index);
                                  } else {
                                    Get.snackbar(
                                      "${stctrl.lang["Error"]}",
                                      "${stctrl.lang["Error submitting answer"]}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red[700],
                                      colorText: Colors.black,
                                      borderRadius: 5,
                                      duration: Duration(seconds: 3),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          child: Text(
                            "${stctrl.lang["Continue"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            qnController?.skipPress(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "${stctrl.lang["Skip Question"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

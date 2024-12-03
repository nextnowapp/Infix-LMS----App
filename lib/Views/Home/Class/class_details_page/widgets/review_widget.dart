// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';

import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';
import 'package:octo_image/octo_image.dart';

Widget reviewWidget(
    {required ClassController controller,
    required DashboardController dashboardController,
    required GetStorage userToken,
    required String tokenKey,
    double? percentageWidth,
    double? percentageHeight}) {
  return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab4'),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          SizedBox(height: 10),
          GestureDetector(
            child: Container(
              width: (percentageWidth ?? 0) * 100,
              height: (percentageHeight ?? 0) * 6,
              padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(23),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cartTotal("${stctrl.lang["Rate the class"]}"),
                  Icon(
                    Icons.add,
                    color: Get.theme.primaryColor,
                    size: 15,
                  )
                ],
              ),
            ),
            onTap: () {
              var myRating = 5.0;
              controller.reviewText.clear();
              userToken.read(tokenKey) != null
                  ? Get.bottomSheet(SingleChildScrollView(
                      child: Container(
                        width: (percentageWidth ?? 0) * 100,
                        height: (percentageHeight ?? 0) * 54.68,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                            decoration: BoxDecoration(
                              color: Get.theme.cardColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(30),
                                  topRight: const Radius.circular(30)),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      width: (percentageWidth ?? 0) * 18.66,
                                      height: (percentageHeight ?? 0) * 1,
                                      decoration: BoxDecoration(
                                          color: Color(0xffE5E5E5),
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(4.5)),
                                      // color: Color(0xffE5E5E5),
                                    ),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "${stctrl.lang["Rate the class"]}",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      "${stctrl.lang["Your rating"]}",
                                      style: Get.textTheme.titleSmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: RatingBar.builder(
                                      itemSize: 30,
                                      initialRating: myRating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        myRating = rating;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: (percentageWidth ?? 0) * 100,
                                    height: (percentageHeight ?? 0) * 12.19,
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height:
                                                (percentageHeight ?? 0) * 6.19,
                                            width: (percentageWidth ?? 0) * 12,
                                            child: ClipOval(
                                              child: stctrl
                                                              .dashboardController
                                                              .profileData
                                                              .image ==
                                                          null ||
                                                      stctrl
                                                              .dashboardController
                                                              .profileData
                                                              .image ==
                                                          ''
                                                  ? Image.asset(
                                                      'images/profile.jpg')
                                                  : OctoImage(
                                                      fit: BoxFit.cover,
                                                      height: 40,
                                                      width: 40,
                                                      image: stctrl
                                                              .dashboardController
                                                              .profileData
                                                              .image!
                                                              .contains(
                                                                  'public/')
                                                          ? NetworkImage(
                                                              "${stctrl.dashboardController.profileData.image}")
                                                          : NetworkImage(
                                                              "${stctrl.dashboardController.profileData.image}"),
                                                      // placeholderBuilder:
                                                      //     OctoPlaceholder.blurHash(
                                                      //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                      // ),
                                                      placeholderBuilder:
                                                          OctoPlaceholder
                                                              .circularProgressIndicator(),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: (percentageWidth ?? 0) * 2,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height:
                                                (percentageHeight ?? 0) * 12.19,
                                            width:
                                                (percentageWidth ?? 0) * 75.22,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF2F6FF),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextField(
                                              maxLines: 6,
                                              controller: controller.reviewText,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                  left: 10,
                                                  top: 10,
                                                ),
                                                filled: true,
                                                fillColor:
                                                    Get.theme.canvasColor,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          142, 153, 183, 0.4),
                                                      width: 1.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          142, 153, 183, 0.4),
                                                      width: 1.0),
                                                ),
                                                hintText:
                                                    "${stctrl.lang["Your Review"]}",
                                                hintStyle:
                                                    Get.textTheme.titleSmall,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.submitCourseReview(
                                          controller.classDetails.value.id,
                                          controller.reviewText.value.text,
                                          myRating);
                                    },
                                    child: Container(
                                      width: (percentageWidth ?? 0) * 50,
                                      height: (percentageHeight ?? 0) * 5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Get.theme.primaryColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "${stctrl.lang["Submit Review"]}",
                                        style: Get.textTheme.titleSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ])),
                      ),
                    ))
                  : showLoginAlertDialog(
                      "${stctrl.lang["Login"]}",
                      "${stctrl.lang["You are not Logged In"]}",
                      "${stctrl.lang["Login"]}");
              Container();
            },
          ),
          controller.classDetails.value.reviews == null ||
                  controller.classDetails.value.reviews?.length == 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "${stctrl.lang["No Review Found"]}",
                    style: Get.textTheme.titleSmall,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.classDetails.value.reviews?.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: (percentageWidth ?? 0) * 100,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Color(0xFFD7598F),
                                backgroundImage: controller.classDetails.value
                                            .reviews?[index].userImage
                                            ?.contains("public/") ??
                                        false
                                    ? NetworkImage(
                                        '${controller.classDetails.value.reviews?[index].userImage}')
                                    : NetworkImage(
                                        controller.classDetails.value
                                                .reviews?[index].userImage ??
                                            '',
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          cartTotal(controller
                                                  .classDetails
                                                  .value
                                                  .reviews?[index]
                                                  .userName ??
                                              ''),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          StarCounterWidget(
                                            value: controller.classDetails.value
                                                    .reviews?[index].star
                                                    ?.toDouble() ??
                                                0,
                                            color: Color(0xffFFCF23),
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: courseStructure(controller
                                                .classDetails
                                                .value
                                                .reviews?[index]
                                                .comment ??
                                            ''),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  })
        ],
      ));
}

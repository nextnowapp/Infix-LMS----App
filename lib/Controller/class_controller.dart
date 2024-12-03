// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/NewControllerAndModels/models/course_model.dart';
import 'package:lms_flutter_app/NewControllerAndModels/models/my_class_model.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import '../utils/CustomAlertBox.dart';
import 'cart_controller.dart';
import 'dashboard_controller.dart';

class ClassController extends GetxController {
  final CartController cartController = Get.put(CartController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  var isLoading = false.obs;

  var isClassLoading = false.obs;

  var cartAdded = false.obs;

  var reviewSubmitting = false.obs;

  var isClassBought = false.obs;

  var allClass = <Course>[].obs;

  var allMyClass = <MyClassModel>[].obs;

  var allClassText = "${stctrl.lang["All Class"]}".obs;

  var courseFiltered = false.obs;

  GetStorage userToken = GetStorage();

  var tokenKey = "token";

  var courseID = 1.obs;

  var classDetails = CourseMain().obs;

  final TextEditingController reviewText = TextEditingController();

  RxBool isPurchasingIAP = false.obs;

  void fetchAllClass() async {
    try {
      isLoading(true);
      var courses = await RemoteServices.fetchAllClass();
      if (courses != null) {
        allClass.value = courses;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<String> addToCart(String courseId) async {
    final CartController cartController = Get.put(CartController());

    Uri addToCartUrl = Uri.parse(baseUrl + '/add-to-cart/$courseID');
    var token = userToken.read(tokenKey);
    var response = await http.get(
      addToCartUrl,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      // showCustomAlertDialog(
      //     "${stctrl.lang["Status"]}", message, "${stctrl.lang["View Cart"]}");
      cartController.getCartList();
      courseID.value = classDetails.value.id;
      getClassDetails();
      // Get.back();
      return message;
    } else {
      //show error message
      return "Somthing Wrong";
    }
  }

  Future<bool> buyNow(int courseId) async {
    Uri addToCartUrl = Uri.parse(baseUrl + '/buy-now');
    var token = userToken.read(tokenKey);
    var response = await http.post(
      addToCartUrl,
      body: jsonEncode({'id': courseId}),
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      print(message);
      allMyClass.value = [];
      allClassText.value = "${stctrl.lang["My Class"]}";
      courseFiltered.value = false;
      await fetchAllMyClass();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> enrollIAP(int courseId) async {
    Uri addToCartUrl = Uri.parse(baseUrl + '/enroll-iap');
    var token = userToken.read(tokenKey);
    var response = await http.post(
      addToCartUrl,
      body: jsonEncode({'id': courseId}),
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      print(message);
      // CustomSnackBar().snackBarSuccess(message);

      allMyClass.value = [];
      await fetchAllMyClass();

      return true;
    } else {
      return false;
    }
  }

  Future getClassDetails() async {
    try {
      isClassLoading(true);
      await RemoteServices.getClassDetails(courseID.value).then((value) async {
        cartAdded(false);
        await cartController.getCartList().then((value) {
          value?.forEach((element) {
            if (element.courseId.toString() == courseID.value.toString()) {
              cartAdded(true);
            }
          });
        });
        if (value?.enrolls != null) {
          isClassBought(false);
          value?.enrolls?.forEach((element) {
            if (element.userId == dashboardController.profileData.id) {
              isClassBought(true);
            }
          });
        }
        classDetails.value = value ?? CourseMain();
      });
      return classDetails.value;
    } finally {
      isClassLoading(false);
    }
  }

  Future<void> submitCourseReview(courseId, review, rating) async {
    try {
      String token = await userToken.read(tokenKey);

      var postUri = Uri.parse(baseUrl + '/submit-review');
      var request = http.MultipartRequest("POST", postUri)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['ApiKey'] = '$apiKey'
        ..fields['course_id'] = courseId.toString()
        ..fields['review'] = review
        ..fields['rating'] = rating.toString();

      // Send the request
      reviewSubmitting(true);
      var response = await request.send();

      // Convert the response to a string and handle it
      var responseBody = await response.stream.bytesToString();
      var jsonString = jsonDecode(responseBody);
      reviewSubmitting(false);

      if (response.statusCode == 200) {
        print(response.statusCode);
        Get.back();

        CustomSnackBar().snackBarSuccess(jsonString['message']);
        // You can call other methods like getClassDetails() or clear text fields here
        await getClassDetails();
        reviewText.text = "";
      } else {
        CustomSnackBar().snackBarError(jsonString['message']);
      }
    } catch (e, t) {
      print('Error: $e');
      print('Stack trace: $t');
    }
  }

  Future fetchAllMyClass() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);

      // Fetch courses from remote service
      var fetchedCourses = await RemoteServices.fetchAllMyClass(token);

      // Ensure fetchedCourses is of type List<CourseMain>
      List<MyClassModel> courses =
          List<MyClassModel>.from(fetchedCourses ?? []);

      if (courses.isNotEmpty) {
        // Create a Set to track existing course IDs
        final existingCourseIds = <String>{};

        // Add existing course IDs to the Set
        existingCourseIds
            .addAll(allMyClass.map((course) => course.id.toString()));

        // Filter out duplicates based on ID and add new courses
        final uniqueCourses = <MyClassModel>[];
        for (var course in courses) {
          if (!existingCourseIds.contains(course.id.toString())) {
            uniqueCourses.add(course);
            existingCourseIds.add(course.id.toString());
          }
        }

        // Update the RxList with unique courses
        allMyClass.addAll(uniqueCourses);
      } else {
        // If courses is empty or null, reset allMyClass
        allMyClass.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchAllClass();
    fetchAllMyClass();
    super.onInit();
  }
}

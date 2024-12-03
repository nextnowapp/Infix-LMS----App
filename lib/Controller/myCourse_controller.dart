// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/account_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/my_course_details_tab_controller.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/NewControllerAndModels/models/my_course_model.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';

class MyCourseController extends GetxController {
  final AccountController accountController = Get.put(AccountController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final HomeController homeController = Get.put(HomeController());

  var myCourses = <MyCourseModel>[].obs;

  var isLoading = false.obs;
  var commentLoader = false.obs;

  var isMyCourseLoading = false.obs;

  var tokenKey = "token";

  var myCourseDetails = CourseMain().obs;

  var lessons = [].obs;

  var youtubeID = "".obs;

  var courseID = 1.obs;

  var totalCourseProgress = 0.obs;

  var selectedLessonID = 0.obs;

  final TextEditingController commentController = TextEditingController();

  final MyCourseDetailsTabController myCourseDetailsTabController =
      Get.put(MyCourseDetailsTabController());

  @override
  void onInit() {
    fetchMyCourse();
    super.onInit();
  }

  Future<List<MyCourseModel>?> fetchMyCourse() async {
    String token = await accountController.userToken.read(tokenKey);

    try {
      isLoading(true);

      // Fetch courses from remote service
      var products = await RemoteServices.fetchMyCourse(token);

      // Ensure products is of type List<CourseMain>
      List<MyCourseModel> newCourses = List<MyCourseModel>.from(products ?? []);

      if (newCourses.isNotEmpty) {
        // Create a Set to track existing course IDs
        final existingCourseIds = <String>{};

        // Add existing course IDs to the Set
        existingCourseIds
            .addAll(myCourses.map((course) => course.id.toString()));

        // Filter out duplicates based on ID and add new courses
        final uniqueCourses = <MyCourseModel>[];
        for (var course in newCourses) {
          if (!existingCourseIds.contains(course.id.toString())) {
            uniqueCourses.add(course);
            existingCourseIds.add(course.id.toString());
          }
        }

        // Update the RxList with unique courses
        myCourses.addAll(uniqueCourses);
      } else {
        // If no courses are fetched, reset myCourses
        myCourses.value = [];
      }

      return products;
    } catch (e, t) {
      print('$e');
      print('$t');
      return null;
    } finally {
      isLoading(false);
    }
  }

  // get course details
  Future getCourseDetails() async {
    try {
      isMyCourseLoading(true);
      await RemoteServices.getMyCourseDetails(courseID.value).then((value) {
        myCourseDetails.value = value ?? CourseMain();
      });
      return myCourseDetails.value;
    } catch (e, t) {
      print('$e');
      print('$t');
    } finally {
      isMyCourseLoading(false);
      homeController.isCourseBought(false);
    }
  }

  Future<List<Lesson>?> getLessons(int courseId, dynamic chapterId) async {
    try {
      Uri topCatUrl =
          Uri.parse(baseUrl + '/get-course-details/' + courseId.toString());
      var response = await http.get(topCatUrl);
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        var courseData = jsonEncode(jsonString['data']['lessons']);
        var lessons = List<Lesson>.from(
                json.decode(courseData).map((x) => Lesson.fromJson(x)))
            .where((element) =>
                int.parse(element.chapterId.toString()) ==
                int.parse(chapterId.toString()))
            .toList();
        return lessons;
      } else {
        //show error message
        return null;
      }
    } catch (e, t) {
      print('$e');
      print('$t');
    } finally {}
    return null;
  }

  void submitComment(courseId, comment) async {
    commentLoader.value = true;
    String token = await accountController.userToken.read(tokenKey);

    var postUri = Uri.parse(baseUrl + '/comment');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['$authHeader'] = '$isBearer' + '$token';
    request.headers['ApiKey'] = '$apiKey';

    request.fields['course_id'] = courseId.toString();
    request.fields['comment'] = comment;
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        var jsonString = jsonDecode(response.body);
        if (jsonString['success'] == false) {
          commentLoader.value = false;
          CustomSnackBar().snackBarError(jsonString['message']);
        } else {
          commentLoader.value = false;
          CustomSnackBar().snackBarSuccess(jsonString['message']);

          getCourseDetails();
          commentController.text = "";
          myCourseDetailsTabController.controller?.animateTo(2);
        }
        return response.body;
      });
    }).catchError((err) {
      commentLoader.value = false;
      print('error : ' + err.toString());
    }).whenComplete(() {});
  }

  @override
  void onClose() {
    commentController.clear();
    super.onClose();
  }
}

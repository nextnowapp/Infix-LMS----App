// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:lms_flutter_app/Controller/payment_controller.dart';
//
// import '../../../Config/app_config.dart';
//
// class StripeController extends GetxController {
//   Map<String, dynamic>? paymentIntent;
//   final PaymentController controller = Get.put(PaymentController());
//
//   Future<void> makePayment({
//     required String amount,
//     required String currency,
//     required String type,
//     required int paymentMethod,
//     int? invoiceId,
//     required String from,
//   }) async {
//     try {
//       paymentIntent = await createPaymentIntent(amount, currency);
//
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret:
//                   paymentIntent!['client_secret'], //Gotten from payment intent
//               style: ThemeMode.dark,
//               merchantDisplayName: 'Ikay',
//             ),
//           )
//           .then((value) {
//             print('Value from error $value ::: $paymentIntent');
//       });
//
//       //STEP 3: Display Payment sheet
//       displayPaymentSheet(
//         amount: amount,
//         type: type,
//         paymentMethod: paymentMethod,
//         invoiceId: invoiceId,
//         from: from,
//       );
//     } catch (e, t) {
//       debugPrint('$e');
//       debugPrint('$t');
//     }
//   }
//
//   displayPaymentSheet({
//     required String amount,
//     required String type,
//     required int paymentMethod,
//     int? invoiceId,
//     required String from,
//   }) async {
//
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) async {
//
//         print('value from stripe ::: $value');
//         Map payment = {
//           'amount': double.tryParse(controller.paymentAmount.value),
//           'payment_method': 'PayStack',
//           'transaction_id': value,
//         };
//         await controller.makePayment('Stripe', payment);
//         Get.back();
//
//         // Get.dialog(
//         //     barrierDismissible: false,
//         //     Dialog(
//         //       backgroundColor: Colors.white,
//         //       child: PopScope(
//         //         canPop: false,
//         //         child: Container(
//         //           padding: const EdgeInsets.all(10),
//         //           decoration: BoxDecoration(
//         //               color: Colors.white,
//         //               borderRadius: BorderRadius.circular(20)),
//         //           child: const Column(
//         //             mainAxisSize: MainAxisSize.min,
//         //             crossAxisAlignment: CrossAxisAlignment.center,
//         //             children: [
//         //               Icon(
//         //                 Icons.check_circle,
//         //                 color: Colors.green,
//         //                 size: 100.0,
//         //               ),
//         //               SizedBox(height: 10.0),
//         //               Text("Payment Successful!"),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //     )).then((value) async {
//         //   //     print('value from stripe ::: $value');
//         //   // Map payment = {
//         //   //   'amount': double.tryParse(controller.paymentAmount.value),
//         //   //   'payment_method': 'PayStack',
//         //   //   'transaction_id': value,
//         //   // };
//         //   // await controller.makePayment('Stripe', payment);
//         // });
//
//
//         // Delay for 2 seconds and then close the alert dialog
//         // await Future.delayed(const Duration(seconds: 2));
//
//         // Close the alert dialog
//         // Get.back();
//
//         paymentIntent = null;
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       debugPrint('Error is:---> $e');
//       const AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     } catch (e, t) {
//       debugPrint('$e');
//       debugPrint('$t');
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     print(amount.runtimeType);
//     print(controller.paymentAmount.value);
//     num amountValue = calculateAmount(amount);
//     try {
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': amountValue.toInt().toString(),
//         'currency': currency,
//       };
//
//       var response = await http.post(
//         Uri.parse(stripeServerURL),
//         headers: {
//           'Authorization': 'Bearer ${stripeToken}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (e, t) {
//       debugPrint('$e');
//       debugPrint('$t');
//     }
//   }
//
//   num calculateAmount(String amount) {
//     print("Amount ::::: $amount");
//
//     num calculatedAmount = (num.tryParse(amount)??0) * 100;
//
//     return calculatedAmount;
//   }
// }

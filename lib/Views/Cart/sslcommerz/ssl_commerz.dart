import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../Config/app_config.dart';
import '../../../utils/widgets/AppBarWidget.dart';

class SslCommerz extends StatefulWidget {
  final String? trackingId;

  SslCommerz({
    Key? key,
    @required this.trackingId,
  }) : super(key: key);

  @override
  State<SslCommerz> createState() => _SslCommerzState();
}

class _SslCommerzState extends State<SslCommerz> {
  bool loading = true;
  String initialUrl = '';
  late final WebViewController _controller;

  @override
  void initState() {
    getAllInitialValue();
    initWebviewController();
    super.initState();
  }

  void getAllInitialValue() async {
    initialUrl = await getSSLPaymentResponse();
    if (initialUrl.isEmpty) {
      Get.back();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void initWebviewController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('url iss: ${request.url}');
            print('url iss: ${request.url.contains('ssl/app?type=success')}');
            if (request.url.contains('sslcommerz/app/success')) {
              Get.back(result: 'success');
            }
            if (request.url.contains('sslcommerz/app/failed')) {
              Get.back(result: 'failed');
            }
            if (request.url.contains('sslcommerz/app/cancel')) {
              Get.back(result: 'cancel');
            }
            // if (request.url.contains(cancelURL)) {
            //   Get.back();
            // }
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(initialUrl));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
    return Scaffold(
      appBar: AppBarWidget(
        showSearch: false,
        goToSearch: false,
        showFilterBtn: false,
        showBack: true,
      ),
      // body: WebView(
      //   initialUrl: initialUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   navigationDelegate: (NavigationRequest request) {
      //     print('url iss: ${request.url}');
      //     print('url iss: ${request.url.contains('ssl/app?type=success')}');
      //     if (request.url.contains('sslcommerz/app/success')) {
      //       Get.back(result: 'success');
      //     }
      //     if (request.url.contains('sslcommerz/app/failed')) {
      //       Get.back(result: 'failed');
      //     }
      //     if (request.url.contains('sslcommerz/app/cancel')) {
      //       Get.back(result: 'cancel');
      //     }
      //     // if (request.url.contains(cancelURL)) {
      //     //   Get.back();
      //     // }
      //     return NavigationDecision.navigate;
      //   },
      // ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<String> getSSLPaymentResponse() async {
    try {
      Uri sslPayment = Uri.parse('$baseUrl/make-order-ssl');
      GetStorage userToken = GetStorage();
      String token = await userToken.read('token');
      var response = await http.post(
        sslPayment,
        headers: header(token: token),
        body: json.encode({
          'tracking_id': widget.trackingId,
        }),
      );
      if (response.statusCode == 200) {
        var res = convert.jsonDecode(response.body);
        print('resonse');
        print(res);
        if (res['success'] == true) {
          return res['data'];
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return '';
    }
  }
}

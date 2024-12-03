import 'package:flutter/material.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';
import 'package:pdfrx/pdfrx.dart';

class PDFViewPage extends StatefulWidget {
  final String? pdfLink;
  PDFViewPage({this.pdfLink});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late PdfViewerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      hintColor: Colors.red,
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        contentTextStyle: TextStyle(color: Colors.black),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      hintColor: Colors.teal,
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );

    final themeData = brightness == Brightness.dark ? darkTheme : lightTheme;

    return ConnectionCheckerWidget(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: Center(
          child: Theme(
            data: themeData,
            child: PdfViewer.uri(
              controller: _controller,
              Uri.parse(widget.pdfLink!),
              params: PdfViewerParams(
                loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: totalBytes != null
                          ? bytesDownloaded / totalBytes
                          : null,
                      backgroundColor: Colors.grey,
                    ),
                  );
                },
                onViewerReady: (document, controller) {
                  // Handle additional setup after the viewer is ready, if needed
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

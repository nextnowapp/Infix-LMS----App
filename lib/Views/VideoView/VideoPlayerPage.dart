import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';
// import 'package:pod_player/pod_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String? videoID;
  final Lesson? lesson;
  final String? source;

  VideoPlayerPage(this.source, {this.videoID, this.lesson});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // PodPlayerController? _podPlayerController;

  final LessonController lessonController = Get.put(LessonController());

  String? video;
  bool _isPlayerReady = false;
  late YoutubePlayerController _controller;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoEnded = false;

  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  init() async {
    if (widget.source == "Youtube") {
      _controller = YoutubePlayerController(
        initialVideoId: extractYouTubeVideoId('${widget.videoID}'),
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoID!);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,

        // Customize controls, aspect ratio, etc.
      );

      _videoPlayerController.addListener(() async {
        if (_videoPlayerController.value.position ==
                _videoPlayerController.value.duration &&
            !_isVideoEnded) {
          setState(() {
            _isVideoEnded = true;
          });
          if (widget.lesson != null) {
            await lessonController
                .updateLessonProgress(
                    widget.lesson?.id, widget.lesson?.courseId, 1)
                .then((value) {
              Get.back();
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    print('Video ID: ${widget.videoID}');
    print('Video Lesson: ${widget.lesson?.name}');
    print('Video Source: ${widget.source}');
    init();

    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  String extractYouTubeVideoId(String url) {
    RegExp regExp = RegExp(
      r'^.*(?:youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    if (match?.groupCount == 1) {
      return match!.group(1)!;
    } else {
      // Return an empty string or throw an exception, depending on your use case.
      return '';
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.source == 'Youtube'
        ? ConnectionCheckerWidget(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: false,
                        progressIndicatorColor: Colors.blueAccent,
                        onReady: () {
                          setState(() {
                            _isPlayerReady = true;
                          });
                        },
                        onEnded: (data) async {
                          if (widget.lesson != null) {
                            await lessonController
                                .updateLessonProgress(widget.lesson?.id,
                                    widget.lesson?.courseId, 1)
                                .then((value) {
                              Get.back();
                            });
                          }
                        },
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 5,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.cancel, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ConnectionCheckerWidget(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Center(
                      child: Chewie(controller: _chewieController),
                    ),
                    Positioned(
                      top: 30,
                      left: 5,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.cancel, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

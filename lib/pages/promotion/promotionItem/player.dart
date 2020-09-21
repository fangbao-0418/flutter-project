import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:video_player/video_player.dart';
import 'package:xtflutter/config/app_config/color_config.dart';

class XTPlayer extends StatelessWidget {
  XTPlayer(
    this.top,
    this.bottom,
    this.url,
  );
  final String url;
  final double top;
  final double bottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _ButterFlyAssetVideo(url),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  _ButterFlyAssetVideo(
    this.url,
  );
  final url;
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _PlayPauseOverlay(controller: _controller),
                  Container(
                    height:2,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: false,
                      padding: EdgeInsets.only(top: 0),
                      colors: VideoProgressColors(
                          playedColor: mainRedColor,
                          backgroundColor: mainF5GrayColor,
                          bufferedColor: main99GrayColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

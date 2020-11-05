import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:video_player/video_player.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/r.dart';

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
      child: _ButterFlyAssetVideo(url, top, bottom),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  _ButterFlyAssetVideo(this.url, this.top, this.bottom);
  final url;
  final double top;
  final double bottom;
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController _controller;
  String timeStr = "00:00/00:00";
  bool openVoice = false;
  @override
  void initState() {
    super.initState();
    print(" flutterplayer initState -----------------------------initState");

    _controller = VideoPlayerController.network(widget.url);

    _controller.addListener(() {
      Duration position = _controller.value.position;
      Duration duration = _controller.value.duration;
      var str = getTime(position) + "/" + getTime(duration);
      print(str);
      timeStr = str;

      setState(() {});
    });
// _controller.s`
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
  }

  String getTime(Duration time) {
    var str = '';
    var h = time.inHours;
    var m = time.inMinutes;
    var s = time.inSeconds;
    if (h > 0) {
      str = str + h.toString() + ":";
    }
    if (m > 0) {
      if (m >= 10) {
        str = str + m.toString() + ":";
      } else {
        str = str + "0" + m.toString() + ":";
      }
    } else {
      str = str + "00:";
    }
    if (s > 0) {
      if (s >= 10) {
        str = str + s.toString();
      } else {
        str = str + "0" + s.toString();
      }
      // str = str + s.toString();
    } else {
      str = str + "00";
    }
    return str;
  }

  @override
  void dispose() {
    print("  flutterplayer  dispose -----------------------------dispose");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 12, right: 12, top: widget.top, bottom: widget.bottom),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_controller),
            _PlayPauseOverlay(controller: _controller),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(bottom: 5),
              color: clearColor,
              // height: 45,R
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  xtText(timeStr, 12, whiteColor),
                  IconButton(
                      icon: Icon(
                        openVoice ? Icons.volume_up : Icons.volume_off,
                        size: 25,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        openVoice = !openVoice;
                        _controller.setVolume(openVoice ? 1 : 0);
                        setState(() {});
                      }),
                ],
              ),
            ),
            Container(
              height: 22,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                colors: VideoProgressColors(
                    playedColor: mainRedColor,
                    backgroundColor: mainF5GrayColor,
                    bufferedColor: main99GrayColor),
              ),
            ),
          ],
        ),
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
                  color: Colors.black12,
                  child: Center(
                      child: Image.asset(R.imagesPlay, width: 50, height: 50)),
                ),
        ),
        GestureDetector(
          onTap: () {
            print("controller.value");
            print(controller.value);
            print("controller.value");
            if (controller.value.position >= controller.value.duration) {
              controller.seekTo(Duration());
            }
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

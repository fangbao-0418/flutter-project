import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:xtflutter/config/app_config/color_config.dart';

class XtRefresh extends StatefulWidget {
  XtRefresh({
    @required this.child,
    @required this.controller,
    this.onRefresh,
    this.onLoad,
  });

  /// 控制器
  final EasyRefreshController controller;
  /// 刷新回调(null为不开启刷新)
  final VoidCallback onRefresh;
  /// 加载回调(null为不开启加载)
  final VoidCallback onLoad;
  /// 子组件
  final Widget child;

  @override
  _XtRefreshState createState() => _XtRefreshState();
}

class _XtRefreshState extends State<XtRefresh> {

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: widget.controller,
      header: XTCustomHeader(
        textColor: main99GrayColor,
      ),
      footer: XTCustomFooter(
        showInfo: false,
        textColor: main99GrayColor,
        overScroll: true
      ),
      onRefresh: widget.onRefresh == null ? null :
      () async {
        await Future.delayed(Duration(seconds: 1), () {
          widget.onRefresh();
        });
      },
      onLoad: widget.onLoad == null ? null : 
      () async {
        await Future.delayed(Duration(seconds: 1), () {
          widget.onLoad();
        });
      },
      child: widget.child,
    );
  }
}



///
/// -----------------------------------------  Header  -----------------------------------------
/// 
class XTCustomHeader extends Header {
  /// Key
  final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示刷新文字
  final String refreshText;

  /// 准备刷新文字
  final String refreshReadyText;

  /// 正在刷新文字
  final String refreshingText;

  /// 刷新完成文字
  final String refreshedText;

  /// 刷新失败文字
  final String refreshFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  XTCustomHeader({
    double extent = 90.0,
    double triggerDistance = 100.0,
    bool float = false,
    Duration completeDuration = const Duration(seconds: 1),
    bool enableInfiniteRefresh = false,
    bool enableHapticFeedback = true,
    bool overScroll = true,
    this.key,
    this.alignment,
    this.refreshText,
    this.refreshReadyText,
    this.refreshingText,
    this.refreshedText,
    this.refreshFailedText,
    this.noMoreText,
    this.showInfo: true,
    this.infoText,
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: float
              ? completeDuration == null
                  ? Duration(
                      milliseconds: 400,
                    )
                  : completeDuration +
                      Duration(
                        milliseconds: 400,
                      )
              : completeDuration,
          enableInfiniteRefresh: enableInfiniteRefresh,
          enableHapticFeedback: enableHapticFeedback,
          overScroll: overScroll,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return XTCustomHeaderWidget(
      key: key,
      customHeader: this,
      refreshState: refreshState,
      pulledExtent: pulledExtent,
      refreshTriggerPullDistance: refreshTriggerPullDistance,
      refreshIndicatorExtent: refreshIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteRefresh: enableInfiniteRefresh,
      success: success,
      noMore: noMore,
    );
  }
}

/// 经典Header组件
class XTCustomHeaderWidget extends StatefulWidget {
  final XTCustomHeader customHeader;
  final RefreshMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteRefresh;
  final bool success;
  final bool noMore;

  XTCustomHeaderWidget(
      {Key key,
      this.refreshState,
      this.customHeader,
      this.pulledExtent,
      this.refreshTriggerPullDistance,
      this.refreshIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteRefresh,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  XTCustomHeaderWidgetState createState() => XTCustomHeaderWidgetState();
}

class XTCustomHeaderWidgetState extends State<XTCustomHeaderWidget>
    with TickerProviderStateMixin<XTCustomHeaderWidget> {
  // 是否到达触发刷新距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
      _overTriggerDistance = over;
    }
  }

  /// 文本
  String get _refreshText {
    return widget.customHeader.refreshText ?? '下拉刷新';
  }

  String get _refreshReadyText {
    return widget.customHeader.refreshReadyText ?? '松开刷新';
  }

  String get _refreshingText {
    return widget.customHeader.refreshingText ?? '正在刷新...';
  }

  String get _refreshedText {
    return widget.customHeader.refreshedText ?? '刷新完成';
  }

  String get _refreshFailedText {
    return widget.customHeader.refreshFailedText ?? '刷新失败，请重试';
  }

  String get _noMoreText {
    return widget.customHeader.noMoreText ?? 'No more';
  }

  String get _infoText {
    return widget.customHeader.infoText ?? 'Update at %T';
  }

  // 是否刷新完成
  bool _refreshFinish = false;

  set refreshFinish(bool finish) {
    if (_refreshFinish != finish) {
      if (finish && widget.float) {
        Future.delayed(widget.completeDuration - Duration(milliseconds: 400),
            () {
          if (mounted) {
            _floatBackController.forward();
          }
        });
        Future.delayed(widget.completeDuration, () {
          _floatBackDistance = null;
          _refreshFinish = false;
        });
      }
      _refreshFinish = finish;
    }
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;
  AnimationController _floatBackController;
  Animation<double> _floatBackAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 浮动时,收起距离
  double _floatBackDistance;

  // 显示文字
  String get _showText {
    if (widget.noMore) return _noMoreText;
    if (widget.enableInfiniteRefresh) {
      if (widget.refreshState == RefreshMode.refreshed ||
          widget.refreshState == RefreshMode.inactive ||
          widget.refreshState == RefreshMode.drag) {
        return _finishedText;
      } else {
        return _refreshingText;
      }
    }
    switch (widget.refreshState) {
      case RefreshMode.refresh:
        return _refreshingText;
      case RefreshMode.armed:
        return _refreshingText;
      case RefreshMode.refreshed:
        return _finishedText;
      case RefreshMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _refreshReadyText;
        } else {
          return _refreshText;
        }
    }
  }

  // 刷新结束文字
  String get _finishedText {
    if (!widget.success) return _refreshFailedText;
    if (widget.noMore) return _noMoreText;
    return _refreshedText;
  }

  // 刷新结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return Icons.hourglass_empty;
    return Icons.done;
  }

  @override
  void initState() {
    super.initState();
    // 准备动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    // 恢复动画
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
    // float收起动画
    _floatBackController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _floatBackAnimation =
        new Tween(begin: widget.refreshIndicatorExtent, end: 0.0)
            .animate(_floatBackController)
              ..addListener(() {
                setState(() {
                  if (_floatBackAnimation.status != AnimationStatus.dismissed) {
                    _floatBackDistance = _floatBackAnimation.value;
                  }
                });
              });
    _floatBackAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _floatBackController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    _floatBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down ||
        widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发刷新距离
    overTriggerDistance = widget.refreshState != RefreshMode.inactive &&
        widget.pulledExtent >= widget.refreshTriggerPullDistance;
    if (widget.refreshState == RefreshMode.refreshed) {
      refreshFinish = true;
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isVertical
              ? 0.0
              : isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          bottom: !isVertical
              ? 0.0
              : !isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          left: isVertical
              ? 0.0
              : isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          right: isVertical
              ? 0.0
              : !isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          child: Container(
            alignment: widget.customHeader.alignment ?? isVertical
                ? isReverse ? Alignment.topCenter : Alignment.bottomCenter
                : !isReverse ? Alignment.centerRight : Alignment.centerLeft,
            width: isVertical
                ? double.infinity
                : _floatBackDistance == null
                    ? (widget.refreshIndicatorExtent > widget.pulledExtent
                        ? widget.refreshIndicatorExtent
                        : widget.pulledExtent)
                    : widget.refreshIndicatorExtent,
            height: isVertical
                ? _floatBackDistance == null
                    ? (widget.refreshIndicatorExtent > widget.pulledExtent
                        ? widget.refreshIndicatorExtent
                        : widget.pulledExtent)
                    : widget.refreshIndicatorExtent
                : double.infinity,
            color: widget.customHeader.bgColor,
            child: SizedBox(
              height:
                  isVertical ? widget.refreshIndicatorExtent : double.infinity,
              width:
                  !isVertical ? widget.refreshIndicatorExtent : double.infinity,
              child: isVertical
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return [
      Image(
        width: 55,
        fit: BoxFit.cover,
        image: AssetImage('images/tuanzi_refresh_header.gif'),
        repeat: ImageRepeat.repeat,
      ),
      Text(
        _showText,
        style: TextStyle(
          fontSize: 15.0,
          color: widget.customHeader.textColor,
        ),
      ),
    ];
  }
}



///
/// -----------------------------------------  Footer  -----------------------------------------
/// 
class XTCustomFooter extends Footer {
  /// Key
  final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示加载文字
  final String loadText;

  /// 准备加载文字
  final String loadReadyText;

  /// 正在加载文字
  final String loadingText;

  /// 加载完成文字
  final String loadedText;

  /// 加载失败文字
  final String loadFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  XTCustomFooter({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration completeDuration = const Duration(seconds: 1),
    bool enableInfiniteLoad = true,
    bool enableHapticFeedback = true,
    bool overScroll = false,
    bool safeArea = true,
    EdgeInsets padding,
    this.key,
    this.alignment,
    this.loadText,
    this.loadReadyText,
    this.loadingText,
    this.loadedText,
    this.loadFailedText,
    this.noMoreText,
    this.showInfo: true,
    this.infoText,
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableInfiniteLoad: enableInfiniteLoad,
          enableHapticFeedback: enableHapticFeedback,
          overScroll: overScroll,
          safeArea: safeArea,
          padding: padding,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return XTCustomFooterWidget(
      key: key,
      customFooter: this,
      loadState: loadState,
      pulledExtent: pulledExtent,
      loadTriggerPullDistance: loadTriggerPullDistance,
      loadIndicatorExtent: loadIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteLoad: enableInfiniteLoad,
      success: success,
      noMore: noMore,
    );
  }
}

/// 经典Footer组件
class XTCustomFooterWidget extends StatefulWidget {
  final XTCustomFooter customFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;

  XTCustomFooterWidget(
      {Key key,
      this.loadState,
      this.customFooter,
      this.pulledExtent,
      this.loadTriggerPullDistance,
      this.loadIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteLoad,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  XTCustomFooterWidgetState createState() => XTCustomFooterWidgetState();
}

class XTCustomFooterWidgetState extends State<XTCustomFooterWidget>
    with TickerProviderStateMixin<XTCustomFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  /// 文本
  String get _loadText {
    return widget.customFooter.loadText ?? '上拉加载';
  }

  String get _loadReadyText {
    return widget.customFooter.loadReadyText ?? '松开加载';
  }

  String get _loadingText {
    return widget.customFooter.loadingText ?? '正在加载中...';
  }

  String get _loadedText {
    return widget.customFooter.loadedText ?? '加载完成';
  }

  String get _loadFailedText {
    return widget.customFooter.loadFailedText ?? '加载失败，请重试';
  }

  /// 没有更多文字
  String get _noMoreText {
    return widget.customFooter.noMoreText ?? '—— 没有更多内容了哦 ——';
  }

  String get _infoText {
    return widget.customFooter.infoText ?? 'Update at %T';
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 显示文字
  String get _showText {
    if (widget.noMore) return _noMoreText;
    if (widget.enableInfiniteLoad) {
      if (widget.loadState == LoadMode.loaded ||
          widget.loadState == LoadMode.inactive ||
          widget.loadState == LoadMode.drag) {
        return _finishedText;
      } else {
        return _loadingText;
      }
    }
    switch (widget.loadState) {
      case LoadMode.load:
        return _loadingText;
      case LoadMode.armed:
        return _loadingText;
      case LoadMode.loaded:
        return _finishedText;
      case LoadMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _loadReadyText;
        } else {
          return _loadText;
        }
    }
  }

  // 加载结束文字
  String get _finishedText {
    if (!widget.success) return _loadFailedText;
    if (widget.noMore) return _noMoreText;
    return _loadedText;
  }

  // 加载结束图标
  IconData get _finishedIcon {
    if (!widget.success) return null;
    if (widget.noMore) return null;
    return Icons.done;
  }

  // 更新时间
  DateTime _dateTime;

  // 获取更多信息
  String get _infoTextStr {
    if (widget.loadState == LoadMode.loaded) {
      _dateTime = DateTime.now();
    }
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return _infoText.replaceAll(
        "%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  void initState() {
    super.initState();
    // 初始化时间
    _dateTime = DateTime.now();
    // 初始化动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down ||
        widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发加载距离
    overTriggerDistance = widget.loadState != LoadMode.inactive &&
        widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isVertical ? 0.0 : !isReverse ? 0.0 : null,
          bottom: !isVertical ? 0.0 : isReverse ? 0.0 : null,
          left: isVertical ? 0.0 : !isReverse ? 0.0 : null,
          right: isVertical ? 0.0 : isReverse ? 0.0 : null,
          child: Container(
            alignment: widget.customFooter.alignment ?? isVertical
                ? !isReverse ? Alignment.topCenter : Alignment.bottomCenter
                : isReverse ? Alignment.centerRight : Alignment.centerLeft,
            width: !isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                    ? widget.loadIndicatorExtent
                    : widget.pulledExtent
                : double.infinity,
            height: isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                    ? widget.loadIndicatorExtent
                    : widget.pulledExtent
                : double.infinity,
            color: widget.customFooter.bgColor,
            child: SizedBox(
              height: isVertical ? widget.loadIndicatorExtent : double.infinity,
              width: !isVertical ? widget.loadIndicatorExtent : double.infinity,
              child: isVertical
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return isVertical
        ? <Widget>[
            Expanded(
              flex: widget.noMore ? 1 : 2,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: (widget.loadState == LoadMode.load ||
                            widget.loadState == LoadMode.armed) &&
                        !widget.noMore
                    ? Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(
                            widget.customFooter.textColor,
                          ),
                        ),
                      )
                    : widget.loadState == LoadMode.loaded ||
                            widget.loadState == LoadMode.done ||
                            (widget.enableInfiniteLoad &&
                                widget.loadState != LoadMode.loaded) ||
                            widget.noMore
                        ? Icon(
                            _finishedIcon,
                            color: widget.customFooter.textColor,
                          )
                        : Transform.rotate(
                            child: Icon(
                              !isReverse
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: widget.customFooter.textColor,
                            ),
                            angle: 2 * pi * _iconRotationValue,
                          ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  _showText,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: widget.customFooter.textColor,
                  ),
                ),
              )
            ),
            Expanded(
              flex: widget.noMore ? 1 : 2,
              child: SizedBox(),
            ),
          ]
        : <Widget>[
            Container(
              child: widget.loadState == LoadMode.load ||
                      widget.loadState == LoadMode.armed
                  ? Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(
                          widget.customFooter.textColor,
                        ),
                      ),
                    )
                  : widget.loadState == LoadMode.loaded ||
                          widget.loadState == LoadMode.done ||
                          (widget.enableInfiniteLoad &&
                              widget.loadState != LoadMode.loaded) ||
                          widget.noMore
                      ? Icon(
                          _finishedIcon,
                          color: widget.customFooter.textColor,
                        )
                      : Transform.rotate(
                          child: Icon(
                            !isReverse ? Icons.arrow_back : Icons.arrow_forward,
                            color: widget.customFooter.textColor,
                          ),
                          angle: 2 * pi * _iconRotationValue,
                        ),
            ),
          ];
  }
}
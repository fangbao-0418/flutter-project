import '../AppConfig/XTSizeFit.dart';

extension DoubleFit on double {
  double get px {
    return XTSizeFit.setPx(this);
  }

  double get rpx {
    return XTSizeFit.setRpx(this);
  }
}

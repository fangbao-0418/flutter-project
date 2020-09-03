import '../app_config/size_fit.dart';

extension IntFit on int {
  double get px {
    return XTSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return XTSizeFit.setRpx(this.toDouble());
  }
}

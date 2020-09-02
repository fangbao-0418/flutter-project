import '../app_config/xt_size_fit.dart';

extension IntFit on int {
  double get px {
    return XTSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return XTSizeFit.setRpx(this.toDouble());
  }
}

import 'dart:math' as math;

extension MathExtension on double {
  /// 近似的なエラー関数 (erf) の実装
  /// 正規分布に従う確率変数の累積分布の計算に使用する
  double erf() {
    // 定数
    double a1 = 0.254829592;
    double a2 = -0.284496736;
    double a3 = 1.421413741;
    double a4 = -1.453152027;
    double a5 = 1.061405429;
    double p = 0.3275911;

    // x の符号を保存
    int sign = (this < 0) ? -1 : 1;
    double x = abs();

    // A&Sの式 7.1.26に記載
    double t = 1.0 / (1.0 + p * x);
    double y = (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t;

    return sign * (1 - y * math.exp(-x * x));
  }
}

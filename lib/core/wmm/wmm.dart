import 'dart:math' as math;

import 'wmm2025_coefficients.dart';

/// World Magnetic Model: magnetic declination (variation) for a position
/// and date. Port of NOAA's reference geomag algorithm.
///
/// Declination is positive east ("east is least": magnetic = true − east).
class Wmm {
  Wmm._() {
    _init();
  }

  static final Wmm instance = Wmm._();

  static const int _maxOrd = 12;
  static const double _a = 6378.137; // WGS84 semi-major axis, km
  static const double _b = 6356.7523142; // WGS84 semi-minor axis, km
  static const double _re = 6371.2; // Mean earth radius, km
  static const double _a2 = _a * _a;
  static const double _b2 = _b * _b;
  static const double _c2 = _a2 - _b2;
  static const double _a4 = _a2 * _a2;
  static const double _b4 = _b2 * _b2;
  static const double _c4 = _a4 - _b4;

  /// Model validity, decimal years.
  static const double validFrom = wmmEpoch;
  static const double validUntil = wmmEpoch + 5;

  final _c = _matrix();
  final _cd = _matrix();
  final _k = _matrix();
  final _fn = List<double>.filled(_maxOrd + 1, 0);
  final _fm = List<double>.filled(_maxOrd + 1, 0);

  static List<List<double>> _matrix() =>
      List.generate(_maxOrd + 1, (_) => List<double>.filled(_maxOrd + 1, 0));

  void _init() {
    for (final row in wmmCoefficients) {
      final n = row[0].toInt();
      final m = row[1].toInt();
      if (m > n) continue;
      _c[m][n] = row[2].toDouble();
      _cd[m][n] = row[4].toDouble();
      if (m != 0) {
        _c[n][m - 1] = row[3].toDouble();
        _cd[n][m - 1] = row[5].toDouble();
      }
    }

    // Convert Schmidt semi-normalised coefficients to Gauss-normalised.
    final snorm = List<double>.filled((_maxOrd + 1) * (_maxOrd + 1), 0);
    snorm[0] = 1;
    for (var n = 1; n <= _maxOrd; n++) {
      snorm[n] = snorm[n - 1] * (2 * n - 1) / n;
      var j = 2;
      for (var m = 0; m <= n; m++) {
        _k[m][n] = ((n - 1) * (n - 1) - m * m) / ((2 * n - 1) * (2 * n - 3));
        if (m > 0) {
          final flnmj = ((n - m + 1) * j) / (n + m);
          snorm[n + m * 13] = snorm[n + (m - 1) * 13] * math.sqrt(flnmj);
          j = 1;
          _c[n][m - 1] *= snorm[n + m * 13];
          _cd[n][m - 1] *= snorm[n + m * 13];
        }
        _c[m][n] *= snorm[n + m * 13];
        _cd[m][n] *= snorm[n + m * 13];
      }
      _fn[n] = n + 1.0;
      _fm[n] = n.toDouble();
    }
    _k[1][1] = 0;
  }

  /// Declination in degrees (positive east) at geodetic [latitude] and
  /// [longitude], [altitudeKm] above the WGS84 ellipsoid, at [decimalYear].
  double declination(
    double latitude,
    double longitude, {
    double altitudeKm = 0,
    double? decimalYear,
  }) {
    final dt = (decimalYear ?? toDecimalYear(DateTime.now())) - wmmEpoch;
    final rlat = latitude * math.pi / 180;
    final rlon = longitude * math.pi / 180;
    final srlon = math.sin(rlon);
    final crlon = math.cos(rlon);
    final srlat = math.sin(rlat);
    final crlat = math.cos(rlat);
    final srlat2 = srlat * srlat;
    final crlat2 = crlat * crlat;

    // Geodetic to spherical coordinates.
    final q = math.sqrt(_a2 - _c2 * srlat2);
    final q1 = altitudeKm * q;
    final q2 = math.pow((q1 + _a2) / (q1 + _b2), 2);
    final ct = srlat / math.sqrt(q2 * crlat2 + srlat2);
    final st = math.sqrt(1 - ct * ct);
    final r2 =
        altitudeKm * altitudeKm + 2 * q1 + (_a4 - _c4 * srlat2) / (q * q);
    final r = math.sqrt(r2);
    final d = math.sqrt(_a2 * crlat2 + _b2 * srlat2);
    final ca = (altitudeKm + d) / r;
    final sa = _c2 * crlat * srlat / (r * d);

    final sp = List<double>.filled(_maxOrd + 1, 0);
    final cp = List<double>.filled(_maxOrd + 1, 0);
    sp[1] = srlon;
    cp[0] = 1;
    cp[1] = crlon;
    for (var m = 2; m <= _maxOrd; m++) {
      sp[m] = sp[1] * cp[m - 1] + cp[1] * sp[m - 1];
      cp[m] = cp[1] * cp[m - 1] - sp[1] * sp[m - 1];
    }

    final p = _matrix();
    final dp = _matrix();
    final tc = _matrix();
    final pp = List<double>.filled(_maxOrd + 1, 0);
    p[0][0] = 1;
    pp[0] = 1;

    final aor = _re / r;
    var ar = aor * aor;
    var br = 0.0, bt = 0.0, bp = 0.0, bpp = 0.0;

    for (var n = 1; n <= _maxOrd; n++) {
      ar *= aor;
      for (var m = 0; m <= n; m++) {
        // Associated Legendre polynomials and derivatives.
        if (n == m) {
          p[m][n] = st * p[m - 1][n - 1];
          dp[m][n] = st * dp[m - 1][n - 1] + ct * p[m - 1][n - 1];
        } else if (n == 1 && m == 0) {
          p[m][n] = ct * p[m][n - 1];
          dp[m][n] = ct * dp[m][n - 1] - st * p[m][n - 1];
        } else {
          if (m > n - 2) {
            p[m][n - 2] = 0;
            dp[m][n - 2] = 0;
          }
          p[m][n] = ct * p[m][n - 1] - _k[m][n] * p[m][n - 2];
          dp[m][n] =
              ct * dp[m][n - 1] - st * p[m][n - 1] - _k[m][n] * dp[m][n - 2];
        }

        // Secular variation.
        tc[m][n] = _c[m][n] + dt * _cd[m][n];
        if (m != 0) tc[n][m - 1] = _c[n][m - 1] + dt * _cd[n][m - 1];

        final par = ar * p[m][n];
        final double temp1, temp2;
        if (m == 0) {
          temp1 = tc[m][n] * cp[m];
          temp2 = tc[m][n] * sp[m];
        } else {
          temp1 = tc[m][n] * cp[m] + tc[n][m - 1] * sp[m];
          temp2 = tc[m][n] * sp[m] - tc[n][m - 1] * cp[m];
        }
        bt -= ar * temp1 * dp[m][n];
        bp += _fm[m] * temp2 * par;
        br += _fn[n] * temp1 * par;

        // Geographic poles.
        if (st == 0 && m == 1) {
          pp[n] = n == 1 ? pp[n - 1] : ct * pp[n - 1] - _k[m][n] * pp[n - 2];
          bpp += _fm[m] * temp2 * ar * pp[n];
        }
      }
    }
    bp = st == 0 ? bpp : bp / st;

    // Rotate back to geodetic.
    final bx = -bt * ca - br * sa;
    final by = bp;
    return math.atan2(by, bx) * 180 / math.pi;
  }

  static double toDecimalYear(DateTime date) {
    final start = DateTime.utc(date.year);
    final end = DateTime.utc(date.year + 1);
    return date.year +
        date.toUtc().difference(start).inSeconds /
            end.difference(start).inSeconds;
  }
}

/// Magnetic variation (positive east) at a position, today.
double magneticVariation(double latitude, double longitude) =>
    Wmm.instance.declination(latitude, longitude);

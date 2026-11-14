import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Service kalkulasi orientasi sensor kompas (Magnetometer + Accelerometer tilt-compensation)
class CompassSensorService {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;
  double _lastAx = 0.0, _lastAy = 9.8, _lastAz = 0.0;
  double _heading = 0.0;

  double get heading => _heading;

  void startListening({required ValueChanged<double> onHeadingChanged}) {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      onHeadingChanged(0.0);
      return;
    }

    try {
      _accelSub?.cancel();
      _accelSub = accelerometerEventStream().listen((acc) {
        _lastAx = acc.x;
        _lastAy = acc.y;
        _lastAz = acc.z;
      }, onError: (_) {});

      _magSub?.cancel();
      _magSub = magnetometerEventStream().listen((event) {
        final mx = event.x;
        final my = event.y;
        final mz = event.z;

        // Kompensasi kemiringan ponsel menggunakan gravitasi accelerometer
        final normAcc = sqrt(_lastAx * _lastAx + _lastAy * _lastAy + _lastAz * _lastAz);
        double rad;
        if (normAcc > 0.5) {
          final pitch = asin((_lastAy / normAcc).clamp(-1.0, 1.0));
          final roll = asin((-_lastAx / normAcc).clamp(-1.0, 1.0));

          final cosP = cos(pitch);
          final sinP = sin(pitch);
          final cosR = cos(roll);
          final sinR = sin(roll);

          final xH = mx * cosR + mz * sinR;
          final yH = mx * sinP * sinR + my * cosP - mz * sinP * cosR;
          rad = atan2(-xH, yH);
        } else {
          rad = atan2(-mx, my);
        }

        // Circular smoothing (low-pass filter) agar jarum berputar mulus tanpa jitter
        final targetDeg = (rad * 180 / pi + 360) % 360;
        final currentDeg = (_heading * 180 / pi + 360) % 360;
        var diff = targetDeg - currentDeg;
        while (diff < -180) {
          diff += 360;
        }
        while (diff > 180) {
          diff -= 360;
        }
        final smoothedDeg = (currentDeg + diff * 0.22 + 360) % 360;
        _heading = (smoothedDeg * pi) / 180;
        onHeadingChanged(_heading);
      }, onError: (_) {});
    } catch (_) {}
  }

  void dispose() {
    _accelSub?.cancel();
    _magSub?.cancel();
    _accelSub = null;
    _magSub = null;
  }
}


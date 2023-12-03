import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconde;
  Debounce({
    this.milliseconde = 500,
  });

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconde), action);
  }
}

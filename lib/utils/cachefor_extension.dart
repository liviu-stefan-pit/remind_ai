import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    final KeepAliveLink link = keepAlive();
    final Timer timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

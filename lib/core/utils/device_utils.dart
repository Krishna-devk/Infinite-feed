import 'package:flutter/widgets.dart';

class DeviceUtils {
  static int getCacheWidth(BuildContext context) {
    return (MediaQuery.sizeOf(context).width *
            MediaQuery.devicePixelRatioOf(context))
        .round();
  }
}

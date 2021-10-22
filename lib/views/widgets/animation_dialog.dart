import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAnimationDialog({required Widget child}) {
  showGeneralDialog(
    context: Get.context!,
    barrierLabel: child.toStringShort(),
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, a1, a2, widget) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: a1,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
    pageBuilder: (context, a1, a2) => const SizedBox.shrink(),
  );
}

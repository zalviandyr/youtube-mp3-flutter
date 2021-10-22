import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAnimationDialog({required Widget dialog}) {
  showGeneralDialog(
    context: Get.context!,
    barrierLabel: dialog.toStringShort(),
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, a1, a2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: a1,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
    pageBuilder: (context, a1, a2) => dialog,
  );
}

import 'package:flutter/material.dart';

import '../utils/app_screen_style.dart';

/// Pada layar lebar (tablet), tampilan app dibatasi lebar agar tidak meregang.
class AppWidthLimiter extends StatelessWidget {
  const AppWidthLimiter({
    super.key,
    required this.child,
  });

  final Widget child;

  static const double tabletBreakpoint = 600;
  static const double maxAppWidth = 720;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= tabletBreakpoint) return child;

    final side = appScaffoldBackground(context);
    return ColoredBox(
      color: Color.alphaBlend(
        Colors.black.withValues(alpha: 0.06),
        side,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxAppWidth,
            minHeight: MediaQuery.sizeOf(context).height,
          ),
          child: Material(
            color: side,
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}

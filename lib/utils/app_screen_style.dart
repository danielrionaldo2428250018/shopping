import 'package:flutter/material.dart';

/// Warna layar mengikuti [ThemeData] (termasuk dark mode).
Color appScaffoldBackground(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

Color appCardColor(BuildContext context) => Theme.of(context).colorScheme.surface;

Color appMutedTextColor(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);

Color appBorderColor(BuildContext context) =>
    Theme.of(context).dividerColor.withValues(alpha: 0.35);

Color appAccentTint(BuildContext context) =>
    Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);

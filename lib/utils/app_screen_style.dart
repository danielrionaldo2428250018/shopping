import 'package:flutter/material.dart';

import '../styles/app_colors_extension.dart';
import 'responsive_layout.dart';

/// Padding horizontal mengikuti lebar layar.
double appHorizontalPadding(BuildContext context) =>
    ResponsiveLayout.of(context).horizontalPadding;

EdgeInsets appPageInsets(
  BuildContext context, {
  double top = 0,
  double bottom = 0,
}) {
  final h = appHorizontalPadding(context);
  return EdgeInsets.fromLTRB(h, top, h, bottom);
}

bool appIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color appScaffoldBackground(BuildContext context) =>
    appColors(context).scaffold;

Color appCardColor(BuildContext context) => appColors(context).surface;

Color appCardElevated(BuildContext context) =>
    appColors(context).surfaceElevated;

Color appMutedTextColor(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);

Color appBorderColor(BuildContext context) =>
    Theme.of(context).dividerColor.withValues(alpha: 0.5);

Color appAccentTint(BuildContext context) =>
    Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);

Color appPrimaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

List<Color> appHeaderGradient(BuildContext context) =>
    appColors(context).headerGradient;

List<Color> appPromoGradient(BuildContext context) =>
    appColors(context).promoGradient;

List<Color> appProfileHeaderGradient(BuildContext context) =>
    appColors(context).profileHeaderGradient;

List<Color> appAuthGradient(BuildContext context) =>
    appColors(context).authGradient;

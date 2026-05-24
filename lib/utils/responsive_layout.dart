import 'package:flutter/material.dart';

/// Skala layout mengikuti lebar layar — HP kecil, standar, tablet.
class ResponsiveLayout {
  ResponsiveLayout(this._context);

  final BuildContext _context;

  static ResponsiveLayout of(BuildContext context) =>
      ResponsiveLayout(context);

  Size get size => MediaQuery.sizeOf(_context);
  double get width => size.width;
  double get height => size.height;
  EdgeInsets get padding => MediaQuery.paddingOf(_context);

  /// Layar sempit (≤360 dp), mis. iPhone SE / Android entry.
  bool get isCompact => width < 360;

  /// Layar lebar (≥600 dp), tablet / fold terbuka.
  bool get isExpanded => width >= 600;

  /// Padding horizontal konsisten di seluruh app.
  double get horizontalPadding {
    if (isExpanded) return 24;
    if (isCompact) return 12;
    return 16;
  }

  EdgeInsets get pageInsets => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      );

  /// Font dasar diskalakan ringan di layar kecil.
  double sp(double base) {
    if (isCompact) return base * 0.92;
    if (isExpanded) return base * 1.05;
    return base;
  }

  /// Lebar maks konten form/login di tablet.
  double get maxFormWidth {
    if (width >= 720) return 520;
    if (width >= 600) return 480;
    return width;
  }

  /// Lebar maks konten halaman umum (daftar, keranjang, dll.).
  double get pageMaxWidth {
    if (width >= 900) return 840;
    if (width >= 600) return 720;
    return width;
  }

  /// Tinggi area foto di detail produk.
  double get productHeroHeight {
    if (isCompact) return 260;
    if (isExpanded) return 360;
    return 300;
  }

  /// Tinggi baris produk di mode list (favorit).
  double get productListTileHeight {
    if (isCompact) return 118;
    if (isExpanded) return 148;
    return 132;
  }

  int productGridColumns({bool ecoMode = false}) {
    if (width >= 680) return ecoMode ? 2 : 3;
    return 2;
  }

  double productGridAspectRatio({bool ecoMode = false}) {
    if (isCompact) return ecoMode ? 0.74 : 0.7;
    if (isExpanded) return 0.82;
    return ecoMode ? 0.72 : 0.68;
  }

  double get categoryIconBox {
    if (isCompact) return 52;
    if (isExpanded) return 72;
    return 64;
  }

  double get sectionSpacing {
    if (isCompact) return 12;
    if (isExpanded) return 20;
    return 16;
  }

  SliverGridDelegate productGridDelegate({bool ecoMode = false}) {
    final gap = isCompact ? 10.0 : 14.0;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: productGridColumns(ecoMode: ecoMode),
      crossAxisSpacing: gap,
      mainAxisSpacing: gap,
      childAspectRatio: productGridAspectRatio(ecoMode: ecoMode),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount productGridDelegateFixed({
    bool ecoMode = false,
  }) {
    final gap = isCompact ? 10.0 : 14.0;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: productGridColumns(ecoMode: ecoMode),
      crossAxisSpacing: gap,
      mainAxisSpacing: gap,
      childAspectRatio: productGridAspectRatio(ecoMode: ecoMode),
    );
  }
}

extension ResponsiveContext on BuildContext {
  ResponsiveLayout get r => ResponsiveLayout.of(this);
}

/// Membatasi lebar konten di layar lebar (tablet).
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth,
  });

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final cap = maxWidth ?? r.maxFormWidth;
    if (r.width <= cap + 32) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cap),
        child: child,
      ),
    );
  }
}

/// Membatasi lebar isi halaman (bukan full-bleed seperti peta).
class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignTop = true,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool alignTop;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final cap = maxWidth ?? r.pageMaxWidth;
    Widget body = child;
    if (padding != null) {
      body = Padding(padding: padding!, child: body);
    }
    if (r.width <= cap + 8) return body;
    return Align(
      alignment: alignTop ? Alignment.topCenter : Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cap),
        child: body,
      ),
    );
  }
}

/// Scroll + padding horizontal responsif (form, keranjang, pengaturan).
class ResponsiveScrollPage extends StatelessWidget {
  const ResponsiveScrollPage({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.maxWidth,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return ResponsivePage(
      maxWidth: maxWidth,
      child: SingleChildScrollView(
        controller: controller,
        padding: padding ??
            EdgeInsets.fromLTRB(
              r.horizontalPadding,
              12,
              r.horizontalPadding,
              24 + r.padding.bottom,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

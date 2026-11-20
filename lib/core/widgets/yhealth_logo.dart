import 'package:flutter/material.dart';

/// The official YHealth Brand Symbol and Wordmark widget.
///
/// Implements the "VITA-Y" (Vitality Monogram) identity:
/// - Crisp clinical white/dark left wing (trust, medical clarity, endurance)
/// - Radiant vital emerald & mint right wing (vitality, cardio surge, life force)
/// - Precision cardio-diamond node in the nexus
/// - Grounded dual-tone vertical stem with precision negative-space seam
class YHealthLogo extends StatelessWidget {
  final double size;
  final bool showContainer;
  final bool showWordmark;
  final bool showTagline;
  final bool isDark;

  const YHealthLogo({
    super.key,
    this.size = 72.0,
    this.showContainer = true,
    this.showWordmark = false,
    this.showTagline = false,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = showContainer
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.235),
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0B2619), // Deep Forest Emerald
                        Color(0xFF04100B), // Obsidian Green
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF6FAF8),
                        Color(0xFFEAF2EE),
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0x33000000)
                      : const Color(0x1A10B981),
                  blurRadius: size * 0.16,
                  offset: Offset(0, size * 0.06),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? const Color(0x1FFFFFFF)
                    : const Color(0x2A10B981),
                width: 1.5,
              ),
            ),
            child: Center(
              child: CustomPaint(
                size: Size(size * 0.65, size * 0.65),
                painter: YHealthLogoPainter(isDark: isDark),
              ),
            ),
          )
        : CustomPaint(
            size: Size(size, size),
            painter: YHealthLogoPainter(isDark: isDark),
          );

    if (!showWordmark) {
      return symbol;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        symbol,
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Y',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF10B981),
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Health',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0B2619),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'INTELLIGENT VITALITY & WELLNESS',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark
                  ? const Color(0xFF34D399)
                  : const Color(0xFF10B981),
            ),
          ),
        ],
      ],
    );
  }
}

/// High-performance Vector CustomPainter for the YHealth VITA-Y Monogram.
class YHealthLogoPainter extends CustomPainter {
  final bool isDark;

  const YHealthLogoPainter({this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    // Canvas is normalized around center
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;

    // Design base scale is 560px total height, mapped to size.height
    final scale = size.height / 560.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(scale, scale);

    const stemW = 48.0;
    const gap = 7.0;
    const botY = 260.0;
    const juncY = -15.0;
    const botR = 24.0;

    // 1. Left Wing (Pure White in Dark mode, Deep Forest in Light mode)
    const outLX = -(gap + stemW);
    const inLX = -gap;

    final pathL = Path();
    pathL.moveTo(inLX, juncY);
    pathL.cubicTo(-70.0, -80.0, -140.0, -180.0, -172.0, -265.0);
    pathL.cubicTo(-192.0, -295.0, -238.0, -270.0, -232.0, -235.0);
    pathL.cubicTo(-165.0, -110.0, outLX, -20.0, outLX, juncY + 40.0);
    pathL.lineTo(outLX, botY - botR);
    pathL.arcToPoint(
      const Offset(outLX + botR, botY),
      radius: const Radius.circular(botR),
      clockwise: false,
    );
    pathL.lineTo(inLX, botY);
    pathL.lineTo(inLX, juncY);
    pathL.close();

    final paintL = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF0B2619)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(pathL, paintL);

    // 2. Right Wing (Vital Emerald to Mint Gradient)
    const outRX = gap + stemW;
    const inRX = gap;

    final pathR = Path();
    pathR.moveTo(inRX, juncY);
    pathR.cubicTo(70.0, -80.0, 140.0, -180.0, 172.0, -265.0);
    pathR.cubicTo(192.0, -295.0, 238.0, -270.0, 232.0, -235.0);
    pathR.cubicTo(165.0, -110.0, outRX, -20.0, outRX, juncY + 40.0);
    pathR.lineTo(outRX, botY - botR);
    pathR.arcToPoint(
      const Offset(outRX - botR, botY),
      radius: const Radius.circular(botR),
      clockwise: true,
    );
    pathR.lineTo(inRX, botY);
    pathR.lineTo(inRX, juncY);
    pathR.close();

    final gradientR = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF34D399), // Mint #34D399
        Color(0xFF10B981), // Emerald #10B981
      ],
    ).createShader(const Rect.fromLTWH(0.0, -295.0, 250.0, botY + 300.0));

    final paintR = Paint()
      ..shader = gradientR
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(pathR, paintR);

    // 3. Cardio Diamond Core (At the V-Junction)
    const diaSize = 18.0;
    const diaY = juncY - 14.0;

    final pathDia = Path();
    pathDia.moveTo(0.0, diaY - diaSize);
    pathDia.lineTo(diaSize, diaY);
    pathDia.lineTo(0.0, diaY + diaSize);
    pathDia.lineTo(-diaSize, diaY);
    pathDia.close();

    final gradientDia = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF34D399),
        Color(0xFF10B981),
      ],
    ).createShader(
      const Rect.fromLTWH(-diaSize, diaY - diaSize, diaSize * 2.0, diaSize * 2.0),
    );

    final paintDia = Paint()
      ..shader = gradientDia
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(pathDia, paintDia);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant YHealthLogoPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

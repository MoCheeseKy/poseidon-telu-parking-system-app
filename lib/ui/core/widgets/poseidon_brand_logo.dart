import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class PoseidonBrandLogo extends StatelessWidget {
  final double size;
  final double borderRadius;

  const PoseidonBrandLogo({
    super.key,
    this.size = 88.0,
    this.borderRadius = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.22),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _PoseidonMarkPainter(),
      ),
    );
  }
}

class _PoseidonMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final stemLeft = w * 0.31;
    final stemTop = h * 0.28;
    final stemBottom = h * 0.76;
    final stemWidth = w * 0.135;
    final bowlRight = w * 0.72;
    final bowlBottom = h * 0.59;
    final bowlRadius = (bowlBottom - stemTop) / 2;

    final outerPath = Path()
      ..moveTo(stemLeft, stemTop)
      ..lineTo(bowlRight - bowlRadius, stemTop)
      ..arcToPoint(
        Offset(bowlRight - bowlRadius, bowlBottom),
        radius: Radius.circular(bowlRadius),
        clockwise: true,
      )
      ..lineTo(stemLeft + stemWidth, bowlBottom)
      ..lineTo(stemLeft + stemWidth, stemBottom)
      ..lineTo(stemLeft, stemBottom)
      ..close();

    final innerInset = stemWidth * 0.85;
    final innerTop = stemTop + innerInset * 0.88;
    final innerBottom = bowlBottom - innerInset * 0.88;
    final innerRadius = (innerBottom - innerTop) / 2;
    final innerRight = bowlRight - innerInset * 0.88;

    final innerHole = Path()
      ..moveTo(stemLeft + stemWidth, innerTop)
      ..lineTo(innerRight - innerRadius, innerTop)
      ..arcToPoint(
        Offset(innerRight - innerRadius, innerBottom),
        radius: Radius.circular(innerRadius),
        clockwise: true,
      )
      ..lineTo(stemLeft + stemWidth, innerBottom)
      ..close();

    final pPath = Path.combine(PathOperation.difference, outerPath, innerHole);
    canvas.drawPath(pPath, whitePaint);

    final dotCenter = Offset(w * 0.755, h * 0.235);
    final dotRadius = w * 0.082;
    canvas.drawCircle(dotCenter, dotRadius, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


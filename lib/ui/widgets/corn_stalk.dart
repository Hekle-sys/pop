import 'package:flutter/material.dart';

class CornStalk extends StatefulWidget {
  final int grainsRemaining;
  final int totalPopCorns;
  final VoidCallback? onGrainDetached;
  final VoidCallback? onPopCornCreated;
  final bool isPopping;

  const CornStalk({
    super.key,
    required this.grainsRemaining,
    required this.totalPopCorns,
    this.onGrainDetached,
    this.onPopCornCreated,
    this.isPopping = false,
  });

  @override
  State<CornStalk> createState() => _CornStalkState();
}

class _CornStalkState extends State<CornStalk>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _poppingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _poppingAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CornStalk oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPopping && !oldWidget.isPopping) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Statistiques
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '${widget.grainsRemaining}/10',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const Text(
                  'grains',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${widget.totalPopCorns}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const Text(
                  'pop corns',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Épis animé
        ScaleTransition(
          scale: _poppingAnimation,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: GestureDetector(
              onTap: () {
                if (widget.grainsRemaining > 0) {
                  _showGrainDetachAnimation();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Corps de l'épis
                  CustomPaint(
                    size: const Size(120, 160),
                    painter: CornPainter(
                      grainCount: widget.grainsRemaining,
                      isPopping: widget.isPopping,
                    ),
                  ),

                  // Pop corns flottants
                  if (widget.totalPopCorns > 0)
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber[300]!),
                        ),
                        child: Text(
                          '🍿 ${widget.totalPopCorns}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGrainDetachAnimation() {
    // Animation simple pour l'instant
    // Sera remplacée par une animation plus complexe
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🌽 Grain créé!'),
        duration: Duration(milliseconds: 300),
      ),
    );
    widget.onGrainDetached?.call();
  }
}

// Peintre personnalisé pour dessiner l'épis
class CornPainter extends CustomPainter {
  final int grainCount;
  final bool isPopping;

  CornPainter({
    required this.grainCount,
    required this.isPopping,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Tige
    final stemPaint = Paint()
      ..color = Colors.green[600]!
      ..strokeWidth = 4;

    canvas.drawLine(
      Offset(center.dx, center.dy + 60),
      Offset(center.dx, size.height),
      stemPaint,
    );

    // Feuilles
    _drawLeaf(canvas, center, -30, Colors.green[700]!);
    _drawLeaf(canvas, center, 30, Colors.green[700]!);

    // Corps de l'épis (jaune/or)
    final cornBodyPaint = Paint()
      ..color = isPopping ? Colors.orange[400]! : Colors.amber[600]!
      ..style = PaintingStyle.fill;

    // Forme elliptique pour le corps
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 60,
        height: 80,
      ),
      cornBodyPaint,
    );

    // Dessiner les grains
    final grainRadius = 5.0;
    final grainPaint = Paint()
      ..color = Colors.yellow[700]!
      ..style = PaintingStyle.fill;

    int grainIndex = 0;
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 2; col++) {
        if (grainIndex < grainCount) {
          final x = center.dx - 15 + (col * 30);
          final y = center.dy - 30 + (row * 16);
          canvas.drawCircle(Offset(x, y), grainRadius, grainPaint);
          grainIndex++;
        }
      }
    }

    // Shine effect quand pop
    if (isPopping) {
      final shinePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - 15, center.dy - 20),
          width: 20,
          height: 30,
        ),
        shinePaint,
      );
    }
  }

  void _drawLeaf(Canvas canvas, Offset center, double angle, Color color) {
    final leafPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    leafPath.moveTo(center.dx, center.dy + 40);
    leafPath.quadraticBezierTo(
      center.dx + (angle > 0 ? 30 : -30),
      center.dy + 50,
      center.dx + (angle > 0 ? 35 : -35),
      center.dy + 70,
    );
    leafPath.quadraticBezierTo(
      center.dx + (angle > 0 ? 20 : -20),
      center.dy + 60,
      center.dx,
      center.dy + 40,
    );

    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(CornPainter oldDelegate) {
    return oldDelegate.grainCount != grainCount ||
        oldDelegate.isPopping != isPopping;
  }
}

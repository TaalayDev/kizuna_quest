import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedBackground extends StatefulWidget {
  final String backgroundAsset;
  final bool showParticles;
  final int particleCount;
  final bool? isDarkMode;

  const AnimatedBackground({
    super.key,
    required this.backgroundAsset,
    this.showParticles = true,
    this.particleCount = 30,
    this.isDarkMode,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    if (widget.showParticles) {
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    final random = math.Random();

    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1,
          speedFactor: random.nextDouble() * 0.5 + 0.1,
          opacity: random.nextDouble() * 0.7 + 0.3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = widget.isDarkMode ?? theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [
                      const Color(0xFF1A1F38),
                      const Color(0xFF332160),
                    ]
                  : [
                      const Color(0xFF8C9EFF),
                      const Color(0xFFB388FF),
                    ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: 0,
                  left: -(_controller.value * 30),
                  right: -(_controller.value * 30),
                  top: -(_controller.value * 30),
                  child: Image.asset(
                    widget.backgroundAsset,
                    fit: BoxFit.cover,
                  ),
                ),
                if (widget.showParticles)
                  CustomPaint(
                    painter: ParticlePainter(
                      _particles,
                      _controller.value,
                      isDarkMode,
                    ),
                    size: Size.infinite,
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDarkMode
                          ? [
                              theme.colorScheme.background.withOpacity(0.3),
                              theme.colorScheme.background.withOpacity(0.6),
                            ]
                          : [
                              const Color(0xFF8C9EFF).withOpacity(0.1),
                              const Color(0xFFB388FF).withOpacity(0.3),
                            ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ],
            );
          },
        ).animate().fadeIn(duration: 1500.ms, curve: Curves.easeOut),
      ],
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speedFactor;
  final double opacity;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedFactor,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final bool isDarkMode;

  ParticlePainter(this.particles, this.animationValue, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = (particle.x * size.width + animationValue * particle.speedFactor * 100) % size.width;
      final y = (particle.y * size.height - animationValue * particle.speedFactor * 50) % size.height;

      final paint = Paint()
        ..color = (isDarkMode ? Colors.white : Colors.purple.shade100).withOpacity(particle.opacity * 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

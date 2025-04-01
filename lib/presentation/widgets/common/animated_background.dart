import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated background widget with parallax effects and floating particles
class AnimatedBackground extends StatefulWidget {
  /// Path to the background image asset
  final String backgroundAsset;

  /// Whether to show the particle effect
  final bool showParticles;

  /// Number of particles to show
  final int particleCount;

  /// Creates an AnimatedBackground
  const AnimatedBackground({
    super.key,
    required this.backgroundAsset,
    this.showParticles = true,
    this.particleCount = 30,
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

    // Setup animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // Initialize particles
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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
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

        // Animated cityscape silhouette
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background city silhouette
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

                // Custom painter for particles
                if (widget.showParticles)
                  CustomPaint(
                    painter: ParticlePainter(
                      _particles,
                      _controller.value,
                      isDarkMode,
                    ),
                    size: Size.infinite,
                  ),

                // Gradient overlay for better text contrast
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.background.withOpacity(0.3),
                        theme.colorScheme.background.withOpacity(0.6),
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

/// Data class for a particle
class Particle {
  /// X position (0.0 - 1.0)
  final double x;

  /// Y position (0.0 - 1.0)
  final double y;

  /// Size of the particle
  final double size;

  /// Speed factor
  final double speedFactor;

  /// Opacity (0.0 - 1.0)
  final double opacity;

  /// Creates a particle
  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedFactor,
    required this.opacity,
  });
}

/// Custom painter for drawing particles
class ParticlePainter extends CustomPainter {
  /// The particles to draw
  final List<Particle> particles;

  /// Animation value (0.0 - 1.0)
  final double animationValue;

  /// Whether dark mode is enabled
  final bool isDarkMode;

  /// Creates a ParticlePainter
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

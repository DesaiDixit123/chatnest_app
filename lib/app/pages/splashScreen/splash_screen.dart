import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/app/utils/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    // Logo: fade + scale in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text: slide up + fade in (delayed)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Pulse ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Sequence: logo → text
    _logoController.forward().then((_) => _textController.forward());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E), // deep navy
                  Color(0xFF16213E), // dark blue-navy
                  Color(0xFF0F3460), // rich dark blue
                ],
              ),
            ),
            child: Stack(
              children: [
                // ── Decorative blobs ──────────────────────────────────────
                Positioned(
                  top: -80,
                  right: -60,
                  child: _GlowBlob(
                    color: const Color(0xFF34D058).withOpacity(0.18),
                    size: 260,
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -80,
                  child: _GlowBlob(
                    color: const Color(0xFF7B61FF).withOpacity(0.18),
                    size: 300,
                  ),
                ),

                // ── Main content ──────────────────────────────────────────
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pulsing logo container
                      ScaleTransition(
                        scale: _pulseScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF34D058),
                                    Color(0xFF7B61FF),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF34D058)
                                        .withOpacity(0.35),
                                    blurRadius: 32,
                                    spreadRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF7B61FF)
                                        .withOpacity(0.25),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                    offset: const Offset(8, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(22),
                              child: Image.asset(
                                AssetConstants.applogoimage,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App name + tagline slide up
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF34D058),
                                    Color(0xFF7B61FF),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'ChatNest',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Connect. Chat. Belong.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFB0B8CC),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bottom loading dots ───────────────────────────────────
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: const _LoadingDots(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Soft glowing circular blob used as background decoration
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

/// Three animated bouncing dots shown at the bottom
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _anims = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: -10).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    // Stagger start
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _anims[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == 0
                    ? const Color(0xFF34D058)
                    : i == 1
                        ? const Color(0xFF7B61FF).withOpacity(0.8)
                        : const Color(0xFFB0B8CC).withOpacity(0.5),
              ),
            ),
          ),
        );
      }),
    );
  }
}

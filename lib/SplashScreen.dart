import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:smart_mess_bill_calculator/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup ✨
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
       Get.to((HomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B6CB7), Color(0xFF182848)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pattern ✨
            Positioned.fill(
              child: Opacity(
                opacity: 0.07,
                child: Image.asset(
                  'assets/IconImages/Buffet.png', 
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Animated Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEEF2FF), Color(0xFFF7F9FB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.restaurant_menu_rounded,
                            color: Colors.indigo.shade700, size: 58),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // App Title
                    Text(
                      "Smart Mess Tracker",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      "Simplify your daily meal expenses",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Small bottom loader indicator ✨
            Positioned(
              bottom: screenHeight * 0.08,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 90,
                  child: LinearProgressIndicator(
                    color: Colors.white.withOpacity(0.85),
                    backgroundColor: Colors.white.withOpacity(0.25),
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

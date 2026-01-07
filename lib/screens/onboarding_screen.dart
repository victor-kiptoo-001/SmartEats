import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Save Food",
      "text": "1/3 of all food is wasted. Help us rescue fresh meals from local shops and markets.",
      // 1. FRESH PRODUCE MARKET (Scott Warman)
      "image": "https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&q=80&w=1000" 
    },
    {
      "title": "Save Money",
      "text": "Get quality food for 50% off. Shops recover costs, you get a bargain. Everyone wins.",
      // 2. YOUR EXACT IMAGE (Pickled Vegetables / Healthy Food - Brooke Lark)
      "image": "https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?auto=format&fit=crop&q=80&w=1000"
    },
    {
      "title": "Help the Planet",
      "text": "Every meal saved fights climate change. Let's keep Kenya green.",
      // 3. PLANTATION / GREEN ROAD (Studio Dekorasyon)
      "image": "https://images.unsplash.com/photo-1420593248178-d88870618ca0?auto=format&fit=crop&q=80&w=1000"
    }
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MainScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _pages[index]["image"]!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loading) {
                      if (loading == null) return child;
                      return Container(
                        color: Colors.black, 
                        child: const Center(child: CircularProgressIndicator(color: Colors.green))
                      );
                    },
                    errorBuilder: (context, error, stack) => Container(color: Colors.grey[900]),
                  ),
                  
                  // 2. GRADIENT OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // 3. TEXT CONTENT
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pages[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]["text"]!,
                          style: const TextStyle(
                            fontSize: 18, 
                            color: Colors.white70, 
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // 4. BOTTOM CONTROLS
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFF4CAF50) : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _finishOnboarding();
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? "GET STARTED" : "NEXT",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
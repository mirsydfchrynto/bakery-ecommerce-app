import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=1000&auto=format&fit=crop",
      "title": "Freshness\nRedefined",
      "desc": "Discover the art of baking with our daily fresh artisan breads."
    },
    {
      "image": "https://images.unsplash.com/photo-1495147466023-ac5c588e2e40?q=80&w=1000&auto=format&fit=crop",
      "title": "Exquisite\nPastries",
      "desc": "Indulge in our delicate, handcrafted pastries made with premium ingredients."
    },
    {
      "image": "https://images.unsplash.com/photo-1587241321921-91a834d6d191?q=80&w=1000&auto=format&fit=crop",
      "title": "Delivered\nTo You",
      "desc": "Experience the aroma of fresh baking delivered right to your doorstep."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: const Color(0xFF0A0A0A)),
                    errorWidget: (context, url, error) => Container(color: const Color(0xFF0A0A0A)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          const Color(0xFF0A0A0A),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _onboardingData[_currentPage]['title']!,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _onboardingData[_currentPage]['desc']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA3A3A3),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 6,
                            width: _currentPage == index ? 24 : 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        onPressed: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            Get.offAllNamed(Routes.login);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                        child: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_1/presentation/theme/app_theme.dart';
import 'dart:convert';
import '../../../../data/models/barbershop.dart';
import 'recommended_barbershop_card.dart';

class MostRecommendedWidget extends StatefulWidget {
  const MostRecommendedWidget({super.key});

  @override
  State<MostRecommendedWidget> createState() => _MostRecommendedWidgetState();
}

class _MostRecommendedWidgetState extends State<MostRecommendedWidget> {
  final PageController _pageController = PageController();
  List<Barbershop> recommendedBarbershops = [];
  bool isLoading = true;
  String? error;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadRecommendedBarbershops();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadRecommendedBarbershops() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/main.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> recommendedList = jsonData['most_recommended'] as List;
      
      setState(() {
        recommendedBarbershops = recommendedList
            .map((json) => Barbershop.fromJson(json as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error loading data: $error'));
    }

    if (recommendedBarbershops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this to ensure minimum height
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Most recommended',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentPage + 1}/${recommendedBarbershops.length}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 320, // Reduced height
          child: PageView.builder(
            controller: _pageController,
            itemCount: recommendedBarbershops.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final barbershop = recommendedBarbershops[index];
              return RecommendedBarbershopCard(
                name: barbershop.name,
                location: barbershop.locationWithDistance,
                rating: barbershop.reviewRate,
                imageUrl: barbershop.image,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              recommendedBarbershops.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index 
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
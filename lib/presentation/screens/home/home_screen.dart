import 'package:flutter/material.dart';
import 'widgets/top_section.dart';
import 'widgets/nearest_barbershops_widget.dart';
import 'widgets/most_recommended_widget.dart';
import 'widgets/list_barbershops_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  TopSection(),
                  NearestBarbershopsWidget(),
                  MostRecommendedWidget(),
                  ListBarbershopsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
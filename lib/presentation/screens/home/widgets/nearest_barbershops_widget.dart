import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../data/models/barbershop.dart';
import '../../../theme/app_theme.dart';
import 'barbershop_card.dart';
import '../../all_barbershops/all_barbershops_screen.dart';

class NearestBarbershopsWidget extends StatefulWidget {
  const NearestBarbershopsWidget({super.key});

  @override
  State<NearestBarbershopsWidget> createState() => _NearestBarbershopsWidgetState();
}

class _NearestBarbershopsWidgetState extends State<NearestBarbershopsWidget> {
  List<Barbershop> barbershops = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadBarbershops();
  }

  Future<void> loadBarbershops() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/main.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> barbershopList = jsonData['nearest_barbershop'] as List;
      
      setState(() {
        barbershops = barbershopList
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

    final previewBarbershops = barbershops.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Nearest Babershop',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: previewBarbershops.length,
          itemBuilder: (context, index) {
            final barbershop = previewBarbershops[index];
            return BarbershopCard(
              name: barbershop.name,
              location: barbershop.locationWithDistance,
              rating: barbershop.reviewRate,
              imageUrl: barbershop.image,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllBarbershopsScreen(barbershops: barbershops),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('See All', style: TextStyle(color: AppTheme.primaryColor)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: AppTheme.primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
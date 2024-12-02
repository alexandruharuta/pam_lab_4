import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../data/models/barbershop.dart';
import 'barbershop_card.dart';

class ListBarbershopsWidget extends StatefulWidget {
  const ListBarbershopsWidget({super.key});

  @override
  State<ListBarbershopsWidget> createState() => _ListBarbershopsWidgetState();
}

class _ListBarbershopsWidgetState extends State<ListBarbershopsWidget> {
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
      final List<dynamic> barbershopList = jsonData['list'] as List;
      
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

    if (barbershops.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: barbershops.length,
      itemBuilder: (context, index) {
        final barbershop = barbershops[index];
        return BarbershopCard(
          name: barbershop.name,
          location: barbershop.locationWithDistance,
          rating: barbershop.reviewRate,
          imageUrl: barbershop.image,
        );
      },
    );
  }
}
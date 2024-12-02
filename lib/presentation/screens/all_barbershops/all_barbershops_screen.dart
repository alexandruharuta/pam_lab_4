import 'package:flutter/material.dart';
import '../../../data/models/barbershop.dart';
import '../home/widgets/barbershop_card.dart';
import '../../theme/app_theme.dart';

class AllBarbershopsScreen extends StatefulWidget {
  final List<Barbershop> barbershops;

  const AllBarbershopsScreen({
    super.key,
    required this.barbershops,
  });

  @override
  State<AllBarbershopsScreen> createState() => _AllBarbershopsScreenState();
}

class _AllBarbershopsScreenState extends State<AllBarbershopsScreen> {
  List<Barbershop> filteredBarbershops = [];
  String searchQuery = '';
  double? ratingFilter;
  double? maxDistanceFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBarbershops = widget.barbershops;
  }

  void _filterBarbershops() {
    setState(() {
      filteredBarbershops = widget.barbershops.where((barbershop) {
        // Filter by search query
        final nameMatches = barbershop.name.toLowerCase().contains(searchQuery.toLowerCase());
        
        // Filter by rating
        final ratingMatches = ratingFilter == null || barbershop.reviewRate >= ratingFilter!;
        
        // Filter by distance
        final distance = double.tryParse(
          barbershop.locationWithDistance.replaceAll(RegExp(r'[^0-9.]'), '')
        ) ?? 0.0;
        final distanceMatches = maxDistanceFilter == null || distance <= maxDistanceFilter!;

        return nameMatches && ratingMatches && distanceMatches;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? tempRating = ratingFilter;
        double? tempDistance = maxDistanceFilter;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Minimum Rating'),
                  Slider(
                    value: tempRating ?? 0,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: tempRating?.toStringAsFixed(1) ?? '0.0',
                    onChanged: (value) {
                      setState(() {
                        tempRating = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Maximum Distance (km)'),
                  Slider(
                    value: tempDistance ?? 20,
                    min: 0,
                    max: 20,
                    divisions: 20,
                    label: '${(tempDistance ?? 20).toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() {
                        tempDistance = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ratingFilter = tempRating;
                    maxDistanceFilter = tempDistance;
                    _filterBarbershops();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
                if (tempRating != null || tempDistance != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tempRating = null;
                        tempDistance = null;
                      });
                    },
                    child: const Text('Clear'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Barbershops'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search barber's, haircut ser...",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) {
                          searchQuery = value;
                          _filterBarbershops();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.tune, color: Colors.white),
                          onPressed: _showFilterDialog,
                        ),
                        if (ratingFilter != null || maxDistanceFilter != null)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Filtered Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found ${filteredBarbershops.length} barbershops',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (ratingFilter != null || maxDistanceFilter != null || searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          searchQuery = '';
                          ratingFilter = null;
                          maxDistanceFilter = null;
                          _searchController.clear();
                          _filterBarbershops();
                        });
                      },
                      child: const Text('Clear All Filters'),
                    ),
                ],
              ),
            ),

            // Barbershop List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: filteredBarbershops.length,
                itemBuilder: (context, index) {
                  final barbershop = filteredBarbershops[index];
                  return BarbershopCard(
                    name: barbershop.name,
                    location: barbershop.locationWithDistance,
                    rating: barbershop.reviewRate,
                    imageUrl: barbershop.image,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
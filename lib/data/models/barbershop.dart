class Barbershop {
  final String name;
  final String locationWithDistance;
  final String image;
  final double reviewRate;

  Barbershop({
    required this.name,
    required this.locationWithDistance,
    required this.image,
    required this.reviewRate,
  });

  factory Barbershop.fromJson(Map<String, dynamic> json) {
    return Barbershop(
      name: json['name'] as String,
      locationWithDistance: json['location_with_distance'] as String,
      image: json['image'] as String,
      reviewRate: (json['review_rate'] as num).toDouble(),
    );
  }
}
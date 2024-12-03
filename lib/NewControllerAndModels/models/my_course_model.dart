class MyCourseModel {
  final int id;
  final String title;
  final String image;
  final String thumbnail;
  final double price;
  final double discountPrice;
  final double purchasePrice;
  final String assignedInstructor;
  final int totalCompletePercentage;

  MyCourseModel({
    required this.id,
    required this.title,
    required this.image,
    required this.thumbnail,
    required this.price,
    required this.discountPrice,
    required this.purchasePrice,
    required this.assignedInstructor,
    required this.totalCompletePercentage,
  });

  factory MyCourseModel.fromJson(Map<String, dynamic> json) {
    return MyCourseModel(
      id: json['id'] ?? 0, // Default to 0 if null
      title: json['title'] ?? "Unknown Title", // Default title
      image: json['image'] ?? "", // Default to empty string
      thumbnail: json['thumbnail'] ?? "", // Default to empty string
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      discountPrice:
          (json['discount_price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      purchasePrice:
          (json['purchase_price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      assignedInstructor: json['assigned_instructor'] ??
          "Unknown Instructor", // Default instructor
      totalCompletePercentage:
          json['totalCompletePercentage'] ?? 0, // Default to 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'thumbnail': thumbnail,
      'price': price,
      'discount_price': discountPrice,
      'purchase_price': purchasePrice,
      'assigned_instructor': assignedInstructor,
      'totalCompletePercentage': totalCompletePercentage,
    };
  }
}

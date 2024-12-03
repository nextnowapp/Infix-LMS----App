// course_model.dart
class Course {
  final int id;
  final String title;
  final String image;
  final String thumbnail;
  final double price;
  final double discountPrice;
  final String assignedInstructor;
  final double purchasePrice;
  final int quizId;

  Course({
    required this.id,
    required this.title,
    required this.image,
    required this.thumbnail,
    required this.price,
    required this.discountPrice,
    required this.assignedInstructor,
    required this.purchasePrice,
    required this.quizId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'] ?? 'No Title', // Default value for title
      image: json['image'] ??
          'https://example.com/default_image.jpg', // Default image URL
      thumbnail: json['thumbnail'] ??
          'https://example.com/default_thumbnail.jpg', // Default thumbnail URL
      price: (json['price'] != null)
          ? json['price'].toDouble()
          : 0.0, // Default value for price
      discountPrice: (json['discount_price'] != null)
          ? json['discount_price'].toDouble()
          : 0.0, // Default value for discountPrice
      assignedInstructor: json['assigned_instructor'] ??
          'Unknown Instructor', // Default value for instructor
      purchasePrice: (json['purchase_price'] != null)
          ? json['purchase_price'].toDouble()
          : 0.0, // Default value for purchasePrice
      quizId: json['quiz_id'] ?? 0, // Default value for quizId
    );
  }
}

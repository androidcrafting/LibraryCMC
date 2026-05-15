class BookModel {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String publisher;
  final String theme;
  final String status; // 'Disponible', 'Réservé', 'Emprunté'
  final String? assignedTo; // User custom_id or profile id
  final String? imageUrl;
  final int qte;

  BookModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.publisher,
    required this.theme,
    required this.status,
    this.assignedTo,
    this.imageUrl,
    this.qte = 1,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'].toString(),
      isbn: json['isbn'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      publisher: json['publisher'] ?? '',
      theme: json['theme'] ?? '',
      status: json['status'] ?? 'Disponible',
      assignedTo: json['assigned_to'],
      imageUrl: json['image_url'],
      qte: json['qte'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'publisher': publisher,
      'theme': theme,
      'status': status,
      'assigned_to': assignedTo,
      'image_url': imageUrl,
      'qte': qte,
    };
  }
}

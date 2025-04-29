class Book {
  int? id;
  String title;
  String author;
  String genre;         // Menambahkan genre
  String description;   // Menambahkan deskripsi

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
  });

  factory Book.fromMap(Map<String, dynamic> map) => Book(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        genre: map['genre'],          // Ambil genre dari map
        description: map['description'],  // Ambil deskripsi dari map
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,             // Tambahkan genre ke map
        'description': description, // Tambahkan deskripsi ke map
      };
}

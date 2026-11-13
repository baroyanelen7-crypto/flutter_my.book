enum BookGenre {
  novel('Vep'),
  history('Patmutyun'),
  fantasy('Fantastika'),
  poetry('Banastexcutyun');

  final String label;
  const BookGenre(this.label);
}

class Book {
  final String id;
  final String title;
  final String author;
  final BookGenre genre;
  bool isRead;
  int rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.isRead = false,
    this.rating = 0,
  });
}
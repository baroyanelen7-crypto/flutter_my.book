import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/books_data.dart';
import '../widgets/book_tile.dart';
import '../widgets/genre_chips_widget.dart';
import 'book_details_screen.dart';

class BooksHomeScreen extends StatefulWidget {
  const BooksHomeScreen({super.key});

  @override
  State<BooksHomeScreen> createState() => _BooksHomeScreenState();
}

class _BooksHomeScreenState extends State<BooksHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  BookGenre? _selectedGenre;

  final List<Book> _books = initialBooks;

  List<Book> get _filteredBooks {
    return _books.where((book) {
      final matchesQuery = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == null || book.genre == _selectedGenre;
      return matchesQuery && matchesGenre;
    }).toList();
  }

  int get _readBooksCount {
    return _books.where((book) => book.isRead).length;
  }

  void _deleteBook(Book book) {
    final index = _books.indexOf(book);
    setState(() {
      _books.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('«${book.title}» գիրքը ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերադարձնել',
          onPressed: () {
            setState(() {
              _books.insert(index, book);
            });
          },
        ),
      ),
    );
  }

  Future<void> _openDetails(Book book) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );

    if (!mounted) return; 

    if (result != null) {
      setState(() {
        book.rating = result;
        book.isRead = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Իմ գրքերը (Կարդացված՝ $_readBooksCount)'), 
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Որոնել ըստ անվան կամ հեղինակի...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          GenreChipsWidget(
            selectedGenre: _selectedGenre,
            onGenreSelected: (genre) {
              setState(() {
                _selectedGenre = genre;
              });
            },
          ),
          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Որոնման արդյունքով գրքեր չեն գտնվել',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final book = filtered[index];
                      return Dismissible(
                        key: ValueKey(book.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteBook(book),
                        child: BookTile(
                          book: book,
                          onChanged: (value) {
                            setState(() {
                              book.isRead = value ?? false;
                            });
                          },
                          onTap: () => _openDetails(book),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
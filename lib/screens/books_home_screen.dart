import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';
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

  final List<Book> _books = [
    Book(id: '1', title: 'Verq Hayastani', author: 'Khachatur Abovyan', genre: BookGenre.history),
    Book(id: '2', title: 'Khachagoghi hishatakarany', author: 'Raffi', genre: BookGenre.novel),
    Book(id: '3', title: 'Anter mardik', author: 'Perch Proshyan', genre: BookGenre.novel),
    Book(id: '4', title: 'Gisherayin mtorumner', author: 'Vahan Teryan', genre: BookGenre.poetry),
    Book(id: '5', title: 'Alisy Hrashqneri asxarhum', author: 'Lyuis Qerol', genre: BookGenre.fantasy),
    Book(id: '6', title: 'Ceronin ev covy', author: 'Ernest Heminguei', genre: BookGenre.novel),
    Book(id: '7', title: 'Sherlok Holmsi arkacnery', author: 'Artur Konan Doyl', genre: BookGenre.novel),
    Book(id: '8', title: 'Matuk-Jarduky', author: 'Ernest Hofman', genre: BookGenre.fantasy),
    Book(id: '9', title: 'Evgeni Onegin', author: 'Aleksandr Pushkin', genre: BookGenre.poetry),
    Book(id: '10', title: 'Hayoc patmutyan drvagner', author: 'Mikael Chamchyan', genre: BookGenre.history),
  ];

  List<Book> get _filteredBooks {
    return _books.where((book) {
      final matchesQuery = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == null || book.genre == _selectedGenre;
      return matchesQuery && matchesGenre;
    }).toList();
  }

  void _deleteBook(Book book) {
    final index = _books.indexOf(book);
    setState(() {
      _books.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('«${book.title}» girqy jnjvec'),
        action: SnackBarAction(
          label: 'Veradardznel',
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
        title: const Text('Im grqery'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Voronel yst anvan kam hexinaki...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Bolory'),
                    selected: _selectedGenre == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedGenre = null;
                      });
                    },
                  ),
                ),
                ...BookGenre.values.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(genre.label),
                      selected: _selectedGenre == genre,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGenre = selected ? genre : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Voronman ardyunqov grqer chen gtnvel',
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
import 'package:flutter/material.dart';
import 'package:latihan2/pages/book_content.dart';
import 'package:provider/provider.dart';
import 'models/book.dart';
import 'providers/book_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookProvider()..fetchBooks(),
      child: MaterialApp(home: BookListPage()),
    ),
  );
}


class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Story Base',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                provider.setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.books.length,
              itemBuilder: (ctx, i) {
                final book = provider.books[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookContentPage(book: book),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${book.author} • ${book.genre}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(book.description),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (_) => BookFormPage(book: book),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                provider.deleteBook(book.id!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookFormPage()),
          );
        },
      ),
    );
  }
}


class BookFormPage extends StatefulWidget {
  final Book? book;
  BookFormPage({this.book});

  @override
  _BookFormPageState createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _genre;         // Menambahkan genre
  late String _description;   // Menambahkan deskripsi

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _genre = widget.book?.genre ?? '';            // Inisialisasi genre
    _description = widget.book?.description ?? ''; // Inisialisasi deskripsi
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.book == null ? 'Tambah Buku' : 'Edit Buku')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (val) => val!.isEmpty ? 'Judul wajib diisi' : null,
                onSaved: (val) => _title = val!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(labelText: 'Penulis'),
                validator: (val) => val!.isEmpty ? 'Penulis wajib diisi' : null,
                onSaved: (val) => _author = val!,
              ),
              TextFormField(
                initialValue: _genre,
                decoration: InputDecoration(labelText: 'Genre'),
                validator: (val) => val!.isEmpty ? 'Genre wajib diisi' : null,
                onSaved: (val) => _genre = val!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (val) => val!.isEmpty ? 'Deskripsi wajib diisi' : null,
                onSaved: (val) => _description = val!,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.book == null ? 'Simpan' : 'Update'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newBook = Book(
                      id: widget.book?.id,
                      title: _title,
                      author: _author,
                      genre: _genre,       
                      description: _description,
                    );
                    if (widget.book == null) {
                      provider.addBook(newBook);
                    } else {
                      provider.updateBook(newBook);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


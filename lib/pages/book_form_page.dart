import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class BookFormPage extends StatefulWidget {
  final Book? book;
  const BookFormPage({Key? key, this.book}) : super(key: key);

  @override
  _BookFormPageState createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _genre;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _genre = widget.book?.genre ?? '';
    _description = widget.book?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.book == null ? 'Tambah Buku' : 'Edit Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (val) => val!.isEmpty ? 'Judul wajib diisi' : null,
                onSaved: (val) => _title = val!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (val) => val!.isEmpty ? 'Penulis wajib diisi' : null,
                onSaved: (val) => _author = val!,
              ),
              TextFormField(
                initialValue: _genre,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (val) => val!.isEmpty ? 'Genre wajib diisi' : null,
                onSaved: (val) => _genre = val!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (val) => val!.isEmpty ? 'Deskripsi wajib diisi' : null,
                onSaved: (val) => _description = val!,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
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

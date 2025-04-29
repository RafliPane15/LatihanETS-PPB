import 'package:flutter/material.dart';
import '../models/book.dart';
import '../helpers/db_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  String _searchQuery = '';

  List<Book> get books {
    if (_searchQuery.isEmpty) return _books;
    return _books
        .where((book) =>
            book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.genre.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _books = await DBHelper().getBooks();
    print('Books fetched: $_books');
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await DBHelper().insertBook(book);
    print('Book added: ${book.title}');
    await fetchBooks();
  }

  Future<void> updateBook(Book book) async {
    await DBHelper().updateBook(book);
    await fetchBooks();
  }

  Future<void> deleteBook(int id) async {
    await DBHelper().deleteBook(id);
    await fetchBooks();
  }
}


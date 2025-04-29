import 'package:flutter/material.dart';
import '../models/book.dart';

class BookContentPage extends StatelessWidget {
  final Book book;

  const BookContentPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.yellowAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dari URL
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.imageUrl ?? 'https://via.placeholder.com/300x200.png?text=No+Image',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book.author,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Genre: ${book.genre}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              book.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

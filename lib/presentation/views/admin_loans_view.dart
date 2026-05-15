import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/core/services/book_service.dart';
import 'package:library_cmc/core/models/book_model.dart';

class AdminLoansView extends StatelessWidget {
  const AdminLoansView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookService bookService = BookService();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Livres Empruntés'),
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: bookService.getBorrowedBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun livre emprunté pour le moment'),
                ],
              ),
            );
          }

          final books = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.book, color: AppColors.primary, size: 32),
                  title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Emprunté par ID : ${book.assignedTo ?? "Inconnu"}'),
                  trailing: TextButton.icon(
                    onPressed: () async {
                      await bookService.assignBook(book.id, null);
                    },
                    icon: const Icon(Icons.assignment_return, color: AppColors.error, size: 20),
                    label: const Text('Rendu', style: TextStyle(color: AppColors.error)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

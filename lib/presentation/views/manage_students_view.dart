import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/core/services/book_service.dart';
import 'package:library_cmc/core/models/user_model.dart';
import 'package:library_cmc/core/models/book_model.dart';

class ManageStudentsView extends StatefulWidget {
  const ManageStudentsView({super.key});

  @override
  State<ManageStudentsView> createState() => _ManageStudentsViewState();
}

class _ManageStudentsViewState extends State<ManageStudentsView> {
  final BookService _bookService = BookService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Gestion Étudiants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Rechercher un étudiant...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserProfile>>(
              future: _bookService.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun étudiant trouvé'));
                }

                final students = snapshot.data!.where((s) => 
                  s.fullName.toLowerCase().contains(_searchQuery) || 
                  s.customId.toLowerCase().contains(_searchQuery)
                ).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return _buildStudentCard(student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(UserProfile student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(student.fullName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        title: Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('ID: ${student.customId}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Livres actuellement empruntés :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                FutureBuilder<List<BookModel>>(
                  future: _bookService.getBooksByBorrower(student.customId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Aucun livre emprunté', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
                    }
                    return Column(
                      children: snapshot.data!.map((book) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.book, size: 20, color: AppColors.primary),
                        title: Text(book.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.assignment_return, size: 20, color: AppColors.error),
                          onPressed: () async {
                            await _bookService.assignBook(book.id, null);
                            setState(() {});
                          },
                        ),
                      )).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/core/services/book_service.dart';
import 'package:library_cmc/core/models/book_model.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final BookService _bookService = BookService();
  String _selectedTheme = 'Tous';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Catalogue'),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: StreamBuilder<List<BookModel>>(
              stream: _bookService.getBooksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun livre trouvé'));
                }

                final allBooks = snapshot.data!;
                final filteredBooks = allBooks.where((book) {
                  final matchesTheme = _selectedTheme == 'Tous' || book.theme == _selectedTheme;
                  final matchesSearch = book.title.toLowerCase().contains(_searchQuery) || 
                                       book.author.toLowerCase().contains(_searchQuery);
                  return matchesTheme && matchesSearch;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return _buildBookCard(context, filteredBooks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Rechercher un livre ou auteur...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<String>>(
            future: _bookService.getThemes(),
            builder: (context, snapshot) {
              final themes = snapshot.data ?? ['Tous'];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: themes.map((theme) => _buildFilterChip(theme)).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String theme) {
    final isSelected = _selectedTheme == theme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(theme),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedTheme = theme);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withValues(alpha: 0.1),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BookModel book) {
    return InkWell(
      onTap: () => _showBookDetails(context, book),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'book_${book.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: book.imageUrl != null && book.imageUrl!.isNotEmpty
                      ? Image.network(
                          book.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: book.status == 'Disponible'
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.status,
                          style: TextStyle(
                            color: book.status == 'Disponible'
                                ? Colors.green.shade700
                                : AppColors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceContainerHighest,
      child: const Center(
        child: Icon(
          Icons.book,
          size: 40,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showBookDetails(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Élargit le dialogue
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: double.infinity, // Force la largeur maximale autorisée par insetPadding
          constraints: const BoxConstraints(maxWidth: 500), // Limite pour les tablettes
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network(
                        book.imageUrl ?? 'https://via.placeholder.com/300',
                        height: 280, // Un peu plus haut
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 12, top: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: book.status == 'Disponible' ? Colors.green.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(book.status, style: TextStyle(color: book.status == 'Disponible' ? Colors.green.shade700 : AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(book.author, style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                      const Divider(height: 40),
                      _buildInfoRow(Icons.category, 'Thème', book.theme),
                      _buildInfoRow(Icons.business, 'Éditeur', book.publisher),
                      _buildInfoRow(Icons.qr_code, 'ISBN', book.isbn),
                      _buildInfoRow(Icons.inventory, 'Quantité', book.qte.toString()),
                      const SizedBox(height: 32),
                      if (book.status == 'Disponible')
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande d\'emprunt envoyée !')));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Emprunter ce livre', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Bouton sans background en bas à droite
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Fermer',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

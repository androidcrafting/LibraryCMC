import 'package:flutter/material.dart';
import 'package:library_cmc/core/theme/app_theme.dart';
import 'package:library_cmc/core/services/book_service.dart';
import 'package:library_cmc/core/models/book_model.dart';

class BookFormView extends StatefulWidget {
  final BookModel? book;
  const BookFormView({super.key, this.book});

  @override
  State<BookFormView> createState() => _BookFormViewState();
}

class _BookFormViewState extends State<BookFormView> {
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _isbnController;
  late TextEditingController _publisherController;
  late TextEditingController _themeController;
  late TextEditingController _imageUrlController;
  late TextEditingController _qteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title);
    _authorController = TextEditingController(text: widget.book?.author);
    _isbnController = TextEditingController(text: widget.book?.isbn);
    _publisherController = TextEditingController(text: widget.book?.publisher);
    _themeController = TextEditingController(text: widget.book?.theme);
    _imageUrlController = TextEditingController(text: widget.book?.imageUrl);
    _qteController = TextEditingController(text: widget.book?.qte.toString() ?? '1');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _themeController.dispose();
    _imageUrlController.dispose();
    _qteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final book = BookModel(
        id: widget.book?.id ?? '',
        isbn: _isbnController.text,
        title: _titleController.text,
        author: _authorController.text,
        publisher: _publisherController.text,
        theme: _themeController.text,
        status: widget.book?.status ?? 'Disponible',
        imageUrl: _imageUrlController.text,
        assignedTo: widget.book?.assignedTo,
        qte: int.tryParse(_qteController.text) ?? 1,
      );
// ... existing save logic ...

      try {
        if (widget.book == null) {
          await _bookService.addBook(book);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Livre ajouté avec succès !'), backgroundColor: Colors.green),
            );
          }
        } else {
          await _bookService.updateBook(widget.book!.id, book);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Livre mis à jour !'), backgroundColor: Colors.green),
            );
          }
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.book == null ? 'Ajouter un Livre' : 'Modifier le Livre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Titre', _titleController, Icons.title, true, hint: 'Ex: Clean Code'),
              const SizedBox(height: 16),
              _buildTextField('Auteur(s)', _authorController, Icons.person, true, hint: 'Ex: Robert C. Martin'),
              const SizedBox(height: 16),
              _buildTextField('ISBN', _isbnController, Icons.qr_code, true, hint: 'Ex: 978-0132350884'),
              const SizedBox(height: 16),
              _buildTextField('Éditeur', _publisherController, Icons.business, false, hint: 'Ex: Pearson'),
              const SizedBox(height: 16),
              _buildTextField('Thème (Ouvrage)', _themeController, Icons.category, true, hint: 'Ex: Programmation'),
              const SizedBox(height: 16),
              _buildTextField('URL de l\'image (Optionnel)', _imageUrlController, Icons.image, false, hint: 'https://...'),
              const SizedBox(height: 16),
              _buildTextField('Quantité', _qteController, Icons.numbers, true, isNumber: true, hint: 'Ex: 5'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(widget.book == null ? 'Ajouter' : 'Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool required, {bool isNumber = false, String? hint}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        if (isNumber && value != null && int.tryParse(value) == null) {
          return 'Veuillez entrer un nombre valide';
        }
        return null;
      },
    );
  }
}

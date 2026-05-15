import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:library_cmc/core/models/book_model.dart';
import 'package:library_cmc/core/models/user_model.dart';

class BookService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all books as a stream for real-time updates
  Stream<List<BookModel>> getBooksStream() {
    return _supabase
        .from('books')
        .stream(primaryKey: ['id'])
        .order('title')
        .map((data) => data.map((json) => BookModel.fromJson(json)).toList());
  }

  // Add a new book
  Future<void> addBook(BookModel book) async {
    await _supabase.from('books').insert(book.toJson());
  }

  // Update a book
  Future<void> updateBook(String id, BookModel book) async {
    await _supabase.from('books').update(book.toJson()).eq('id', id);
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    await _supabase.from('books').delete().eq('id', id);
  }

  // Assign book to user
  Future<void> assignBook(String bookId, String? userId) async {
    await _supabase.from('books').update({
      'assigned_to': userId,
      'status': userId == null ? 'Disponible' : 'Emprunté',
    }).eq('id', bookId);
  }

  // Fetch all students for assignment
  Future<List<UserProfile>> getUsers() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'student')
        .order('full_name');
    
    return (response as List).map((json) => UserProfile.fromJson(json)).toList();
  }

  // Get unique themes from current books
  Future<List<String>> getThemes() async {
    final response = await _supabase
        .from('books')
        .select('theme');
    
    final themes = (response as List)
        .map((item) => item['theme'] as String)
        .where((theme) => theme.isNotEmpty)
        .toSet()
        .toList();
    
    themes.sort();
    return ['Tous', ...themes];
  }

  // Get only borrowed books for admin monitoring
  Stream<List<BookModel>> getBorrowedBooksStream() {
    return _supabase
        .from('books')
        .stream(primaryKey: ['id'])
        .eq('status', 'Emprunté')
        .map((data) => data.map((json) => BookModel.fromJson(json)).toList());
  }

  // Get books borrowed by a specific student
  Future<List<BookModel>> getBooksByBorrower(String customId) async {
    final response = await _supabase
        .from('books')
        .select()
        .eq('assigned_to', customId);
    return (response as List).map((json) => BookModel.fromJson(json)).toList();
  }

  // Get statistics counts
  Future<Map<String, int>> getStats() async {
    final allBooks = await _supabase.from('books').select('id');
    final borrowedBooks = await _supabase.from('books').select('id').eq('status', 'Emprunté');
    final students = await _supabase.from('profiles').select('id').eq('role', 'student');

    final int totalCount = (allBooks as List).length;
    final int borrowedCount = (borrowedBooks as List).length;
    final int studentCount = (students as List).length;

    return {
      'total_books': totalCount,
      'borrowed_books': borrowedCount,
      'students': studentCount,
      'available_books': totalCount - borrowedCount,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor GoogleFonts

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();
    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addBook(String title, String author, String description) async {
    try {
      await Supabase.instance.client.from('books').insert({
        'title': title,
        'author': author,
        'description': description,
      });
      fetchBooks(); // Refresh data setelah menambah buku
      Navigator.pop(context); // Tutup dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah buku: $error')),
      );
    }
  }

  Future<void> editBook(String bookId, String title, String author, String description) async {
    try {
      await Supabase.instance.client.from('books').update({
        'title': title,
        'author': author,
        'description': description,
      }).eq('id', bookId); // Update buku berdasarkan ID
      fetchBooks(); // Refresh data setelah mengedit buku
      Navigator.pop(context); // Tutup dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit buku: $error')),
      );
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await Supabase.instance.client.from('books').delete().eq('id', bookId); // Hapus buku berdasarkan ID
      fetchBooks(); // Refresh data setelah menghapus buku
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus buku: $error')),
      );
    }
  }

  void showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Tambah Buku Baru',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold), // Menggunakan font Lora untuk judul
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
                SizedBox(height: 10),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Penulis',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: GoogleFonts.roboto()), // Menggunakan font Roboto
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final author = authorController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && author.isNotEmpty && description.isNotEmpty) {
                  addBook(title, author, description);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua bidang harus diisi!')),
                  );
                }
              },
              child: Text('Tambah', style: GoogleFonts.roboto()), // Menggunakan font Roboto
            ),
          ],
        );
      },
    );
  }

  void showEditBookDialog(Map<String, dynamic> book) {
    final titleController = TextEditingController(text: book['title']);
    final authorController = TextEditingController(text: book['author']);
    final descriptionController = TextEditingController(text: book['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Buku',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold), // Menggunakan font Lora untuk judul
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
                SizedBox(height: 10),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Penulis',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.roboto(), // Menggunakan font Roboto
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: GoogleFonts.roboto()), // Menggunakan font Roboto
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final author = authorController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && author.isNotEmpty && description.isNotEmpty) {
                  editBook(book['id'], title, author, description); // Update buku berdasarkan ID
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua bidang harus diisi!')),
                  );
                }
              },
              child: Text('Simpan', style: GoogleFonts.roboto()), // Menggunakan font Roboto
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
  'Perpustakaan Digital',
  style: GoogleFonts.lora(
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 229, 216),  // Ganti dengan warna yang diinginkan
  ),
), // Menggunakan font Lora
        centerTitle: true,
        backgroundColor: Colors.brown[600],
      ),
      body: books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('Tidak ada buku tersedia',
                      style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey)), // Menggunakan font Roboto
                ],
              ),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'] ?? 'Judul tidak tersedia',
                          style: GoogleFonts.lora(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ), // Menggunakan font Lora untuk judul buku
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Penulis: ${book['author'] ?? 'Tidak diketahui'}',
                          style: GoogleFonts.roboto(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ), // Menggunakan font Roboto untuk penulis
                        ),
                        SizedBox(height: 5),
                        Text(
                          book['description'] ?? 'Deskripsi tidak tersedia',
                          style: GoogleFonts.roboto(fontSize: 14), // Menggunakan font Roboto untuk deskripsi
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showEditBookDialog(book);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteBook(book['id']); // Hapus buku berdasarkan ID
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
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBookDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[600],
      ),
    );
  }
}

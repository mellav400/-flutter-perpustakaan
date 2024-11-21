import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ynvyptqmnxdbvaczglnt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InludnlwdHFtbnhkYnZhY3pnbG50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTQwNTYsImV4cCI6MjA0NzEzMDA1Nn0.PZus8GBDqR3YdHTppzsCkiXycKvChMMqblxbBc1iDtA');
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Liblary',
      home: BookListPage(),
     debugShowCheckedModeBanner: false,
    );
  }
}


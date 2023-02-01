import 'package:flutter/material.dart';
import 'package:movie_plex/movie_plex/presentation/pages/movie_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Plex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieHomePage(),
    );
  }
}
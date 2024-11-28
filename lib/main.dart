import 'package:aifer_wallpaper/src/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/api/api_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WallpaperProvider()),
      ],
      child: MaterialApp(
        title: 'Aifer Wallpaper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}

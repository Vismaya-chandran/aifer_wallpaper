import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'wallpaper_response_model.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperService {
  final String accessKey = 'ShI6PyqP3P9k1Gkon-du8zn0f4IKWp5gGVEzKgU5H_A';
  final String baseUrl = 'https://api.unsplash.com';

  Future<List<UnsplashImage>> fetchImages(
      {int page = 1, int perPage = 6}) async {
    final url = Uri.parse('$baseUrl/photos?page=$page&per_page=$perPage');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );

    if (response.statusCode == 200) {
      log(response.body);
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => UnsplashImage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> downloadImage(
      BuildContext context, String imageUrl, String fileName) async {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Downloading...")));
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/$fileName';
      final dio = Dio();
      await dio.download(imageUrl, savePath);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Downloaded to $savePath")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to download image: $e")));
    }
  }
}

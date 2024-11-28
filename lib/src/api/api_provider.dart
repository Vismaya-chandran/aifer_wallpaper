import 'dart:developer';

import 'package:aifer_wallpaper/src/api/wallpaper_api.dart';
import 'package:flutter/material.dart';
import 'wallpaper_response_model.dart';

class WallpaperProvider with ChangeNotifier {
  final WallpaperService _service = WallpaperService();

  List<UnsplashImage> _images = [];
  bool _isLoading = false;
  int _page = 1;
  String? _error;

  List<UnsplashImage> get images => _images;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWallpapers({bool isLazyLoad = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final newImages = await _service.fetchImages(page: _page);
      if (isLazyLoad) {
        _images.addAll(newImages);
      } else {
        _images = newImages;
      }
      _page++;
    } catch (e) {
      log(e.toString());
      _error = 'Failed to fetch wallpapers. Please try again.';
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void clearWallpapers() {
    _images.clear();
    _page = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

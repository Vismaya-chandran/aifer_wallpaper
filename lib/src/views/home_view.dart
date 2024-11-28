import 'package:aifer_wallpaper/src/api/wallpaper_api.dart';
import 'package:aifer_wallpaper/src/api/wallpaper_response_model.dart';
import 'package:aifer_wallpaper/src/core/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../api/api_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    Provider.of<WallpaperProvider>(context, listen: false).fetchWallpapers();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<WallpaperProvider>(context, listen: false).fetchWallpapers();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
            child: Image.asset(
              AppImages.profile,
              fit: BoxFit.fill,
              height: 30,
            ),
          ),
          const SizedBox(width: 15),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Follow",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Consumer<WallpaperProvider>(
        builder: (context, wallpaperProvider, child) {
          if (wallpaperProvider.isLoading && wallpaperProvider.images.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wallpaperProvider.error != null &&
              wallpaperProvider.images.isEmpty) {
            return Center(
              child: Text(
                wallpaperProvider.error!,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final wallpapers = wallpaperProvider.images;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!wallpaperProvider.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                wallpaperProvider.fetchWallpapers(isLazyLoad: true);
              }
              return true;
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    TabBar(
                      padding: const EdgeInsets.only(left: 15),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.black,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      tabs: const [
                        Tab(child: Text("Activity")),
                        Tab(child: Text("Community")),
                        Tab(child: Text("Shop")),
                      ],
                    ),
                    const SizedBox(height: 45),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                "All Products",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 150,
                                clipBehavior: Clip.antiAlias,
                                width: kSize.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                    fit: BoxFit.cover,
                                    wallpapers.reversed.first.urls.regular),
                              ),
                              const SizedBox(height: 15),
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: kSize.height * .04,
                                children: wallpapers.reversed
                                    .skip(1)
                                    .map((wallpaper) {
                                  return StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: cardTile(
                                      MediaQuery.of(context).size,
                                      wallpaper,
                                    ),
                                  );
                                }).toList(),
                              ),
                              if (wallpaperProvider.isLoading)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cardTile(Size kSize, UnsplashImage wallpaper) {
    return InkWell(
      onTap: () async {
        await WallpaperService().downloadImage(
            context, wallpaper.urls.regular, 'wallpaper_${wallpaper.id}.jpg');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 170,
                width: 170,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Image.network(
                  wallpaper.urls.regular,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  wallpaper.likes.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  wallpaper.user.name,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }
}

class UnsplashImage {
  final String id;
  final String createdAt;
  final String updatedAt;
  final int width;
  final int height;
  final String color;
  final String blurHash;
  final int likes;
  final bool likedByUser;
  final String? description;
  final User user;
  final List<CurrentUserCollection> currentUserCollections;
  final Urls urls;
  final Links links;

  UnsplashImage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    required this.likes,
    required this.likedByUser,
    this.description,
    required this.user,
    required this.currentUserCollections,
    required this.urls,
    required this.links,
  });

  factory UnsplashImage.fromJson(Map<String, dynamic> json) {
    return UnsplashImage(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      width: json['width'],
      height: json['height'],
      color: json['color'],
      blurHash: json['blur_hash'],
      likes: json['likes'],
      likedByUser: json['liked_by_user'],
      description: json['description'],
      user: User.fromJson(json['user']),
      currentUserCollections: (json['current_user_collections'] as List)
          .map((item) => CurrentUserCollection.fromJson(item))
          .toList(),
      urls: Urls.fromJson(json['urls']),
      links: Links.fromJson(json['links']),
    );
  }
}

class User {
  final String id;
  final String username;
  final String name;
  final String? portfolioUrl;
  final String? bio;
  final String? location;
  final int totalLikes;
  final int totalPhotos;
  final int totalCollections;
  final String? instagramUsername;
  final String? twitterUsername;
  final ProfileImage profileImage;
  final Links links;

  User({
    required this.id,
    required this.username,
    required this.name,
    this.portfolioUrl,
    this.bio,
    this.location,
    required this.totalLikes,
    required this.totalPhotos,
    required this.totalCollections,
    this.instagramUsername,
    this.twitterUsername,
    required this.profileImage,
    required this.links,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      portfolioUrl: json['portfolio_url'],
      bio: json['bio'],
      location: json['location'],
      totalLikes: json['total_likes'],
      totalPhotos: json['total_photos'],
      totalCollections: json['total_collections'],
      instagramUsername: json['instagram_username'],
      twitterUsername: json['twitter_username'],
      profileImage: ProfileImage.fromJson(json['profile_image']),
      links: Links.fromJson(json['links']),
    );
  }
}

class ProfileImage {
  final String small;
  final String medium;
  final String large;

  ProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      small: json['small'],
      medium: json['medium'],
      large: json['large'],
    );
  }
}

class CurrentUserCollection {
  final int id;
  final String title;
  final String publishedAt;
  final String lastCollectedAt;
  final String updatedAt;

  CurrentUserCollection({
    required this.id,
    required this.title,
    required this.publishedAt,
    required this.lastCollectedAt,
    required this.updatedAt,
  });

  factory CurrentUserCollection.fromJson(Map<String, dynamic> json) {
    return CurrentUserCollection(
      id: json['id'],
      title: json['title'],
      publishedAt: json['published_at'],
      lastCollectedAt: json['last_collected_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Urls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  Urls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });

  factory Urls.fromJson(Map<String, dynamic> json) {
    return Urls(
      raw: json['raw'],
      full: json['full'],
      regular: json['regular'],
      small: json['small'],
      thumb: json['thumb'],
    );
  }
}

class Links {
  final String self;
  final String html;
  final String? download;
  final String? downloadLocation;

  Links({
    required this.self,
    required this.html,
    this.download,
    this.downloadLocation,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'],
      html: json['html'],
      download: json['download'],
      downloadLocation: json['download_location'],
    );
  }
}

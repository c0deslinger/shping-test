import 'package:shping_test/features/home/data/entities/photo.dart';

class UnsplashListPhotoResponse {
  String? id;
  String? createdAt;
  String? updatedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  int? likes;
  bool? likedByUser;
  String? description;
  User? user;
  List<CurrentUserCollections>? currentUserCollections;
  Urls? urls;
  Links? links;

  UnsplashListPhotoResponse(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.width,
      this.height,
      this.color,
      this.blurHash,
      this.likes,
      this.likedByUser,
      this.description,
      this.user,
      this.currentUserCollections,
      this.urls,
      this.links});

  UnsplashListPhotoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    blurHash = json['blur_hash'];
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
    description = json['description'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['current_user_collections'] != null) {
      currentUserCollections = <CurrentUserCollections>[];
      json['current_user_collections'].forEach((v) {
        currentUserCollections!.add(CurrentUserCollections.fromJson(v));
      });
    }
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['width'] = width;
    data['height'] = height;
    data['color'] = color;
    data['blur_hash'] = blurHash;
    data['likes'] = likes;
    data['liked_by_user'] = likedByUser;
    data['description'] = description;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (currentUserCollections != null) {
      data['current_user_collections'] =
          currentUserCollections!.map((v) => v.toJson()).toList();
    }
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }

  Photo toPhoto() {
    return Photo(
      id: id ?? '',
      url: urls?.regular ?? '',
      smallUrl: urls?.small ?? '',
      title: description ?? 'Untitled Photo',
      photographer: user?.name ?? 'Unknown',
      description: description ?? '',
      likes: likes ?? 0,
      createdAt:
          createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
    );
  }
}

class User {
  String? id;
  String? username;
  String? name;
  String? portfolioUrl;
  String? bio;
  String? location;
  int? totalLikes;
  int? totalPhotos;
  int? totalCollections;
  String? instagramUsername;
  String? twitterUsername;
  ProfileImage? profileImage;
  Links? links;

  User(
      {this.id,
      this.username,
      this.name,
      this.portfolioUrl,
      this.bio,
      this.location,
      this.totalLikes,
      this.totalPhotos,
      this.totalCollections,
      this.instagramUsername,
      this.twitterUsername,
      this.profileImage,
      this.links});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    portfolioUrl = json['portfolio_url'];
    bio = json['bio'];
    location = json['location'];
    totalLikes = json['total_likes'];
    totalPhotos = json['total_photos'];
    totalCollections = json['total_collections'];
    instagramUsername = json['instagram_username'];
    twitterUsername = json['twitter_username'];
    profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['location'] = location;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['total_collections'] = totalCollections;
    data['instagram_username'] = instagramUsername;
    data['twitter_username'] = twitterUsername;
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class ProfileImage {
  String? small;
  String? medium;
  String? large;

  ProfileImage({this.small, this.medium, this.large});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class Links {
  String? self;
  String? html;
  String? photos;
  String? likes;
  String? portfolio;

  Links({this.self, this.html, this.photos, this.likes, this.portfolio});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    photos = json['photos'];
    likes = json['likes'];
    portfolio = json['portfolio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['photos'] = photos;
    data['likes'] = likes;
    data['portfolio'] = portfolio;
    return data;
  }
}

class CurrentUserCollections {
  int? id;
  String? title;
  String? publishedAt;
  String? lastCollectedAt;
  String? updatedAt;
  String? coverPhoto;
  String? user;

  CurrentUserCollections(
      {this.id,
      this.title,
      this.publishedAt,
      this.lastCollectedAt,
      this.updatedAt,
      this.coverPhoto,
      this.user});

  CurrentUserCollections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    publishedAt = json['published_at'];
    lastCollectedAt = json['last_collected_at'];
    updatedAt = json['updated_at'];
    coverPhoto = json['cover_photo'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['published_at'] = publishedAt;
    data['last_collected_at'] = lastCollectedAt;
    data['updated_at'] = updatedAt;
    data['cover_photo'] = coverPhoto;
    data['user'] = user;
    return data;
  }
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;

  Urls({this.raw, this.full, this.regular, this.small, this.thumb});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['full'] = full;
    data['regular'] = regular;
    data['small'] = small;
    data['thumb'] = thumb;
    return data;
  }
}

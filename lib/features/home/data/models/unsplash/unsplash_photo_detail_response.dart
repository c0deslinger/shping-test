import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:shping_test/features/home/data/models/unsplash/unsplash_list_photo_response.dart';

class UnsplashPhotoDetailResponse {
  String? id;
  String? createdAt;
  String? updatedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  int? downloads;
  int? likes;
  bool? likedByUser;
  bool? publicDomain;
  String? description;
  Exif? exif;
  Location? location;
  List<Tags>? tags;
  List<CurrentUserCollections>? currentUserCollections;
  Urls? urls;
  Links? links;
  User? user;

  UnsplashPhotoDetailResponse({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.downloads,
    this.likes,
    this.likedByUser,
    this.publicDomain,
    this.description,
    this.exif,
    this.location,
    this.tags,
    this.currentUserCollections,
    this.urls,
    this.links,
    this.user,
  });

  UnsplashPhotoDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    blurHash = json['blur_hash'];
    downloads = json['downloads'];
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
    publicDomain = json['public_domain'];
    description = json['description'];
    exif = json['exif'] != null ? Exif.fromJson(json['exif']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    if (json['current_user_collections'] != null) {
      currentUserCollections = <CurrentUserCollections>[];
      json['current_user_collections'].forEach((v) {
        currentUserCollections!.add(CurrentUserCollections.fromJson(v));
      });
    }
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  /// **Method yang mengubah UnsplashPhotoDetailResponse menjadi Photo**
  Photo toPhoto() {
    return Photo(
      id: id ?? '',
      url: urls?.regular ?? '',
      smallUrl: urls?.small ?? '',
      title: description ?? 'Untitled Photo',
      photographer: user?.name ?? 'Unknown',
      description: description ?? '',
      photoProfile: user?.profileImage?.medium ?? urls?.small ?? '',
      likes: likes ?? 0,
      createdAt:
          createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),

      // Ambil tags dari List<Tags> lalu ubah menjadi List<String>
      tags: tags != null
          ? tags!
              .map((tag) => tag.title ?? '')
              .where((title) => title.isNotEmpty)
              .toList()
          : [],
    );
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
    data['downloads'] = downloads;
    data['likes'] = likes;
    data['liked_by_user'] = likedByUser;
    data['public_domain'] = publicDomain;
    data['description'] = description;
    if (exif != null) {
      data['exif'] = exif!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Exif {
  String? make;
  String? model;
  String? name;
  String? exposureTime;
  String? aperture;
  String? focalLength;
  int? iso;

  Exif({
    this.make,
    this.model,
    this.name,
    this.exposureTime,
    this.aperture,
    this.focalLength,
    this.iso,
  });

  Exif.fromJson(Map<String, dynamic> json) {
    make = json['make'];
    model = json['model'];
    name = json['name'];
    exposureTime = json['exposure_time'];
    aperture = json['aperture'];
    focalLength = json['focal_length'];
    iso = json['iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['make'] = make;
    data['model'] = model;
    data['name'] = name;
    data['exposure_time'] = exposureTime;
    data['aperture'] = aperture;
    data['focal_length'] = focalLength;
    data['iso'] = iso;
    return data;
  }
}

class Location {
  String? city;
  String? country;
  Position? position;

  Location({this.city, this.country, this.position});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    position =
        json['position'] != null ? Position.fromJson(json['position']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}

class Position {
  double? latitude;
  double? longitude;

  Position({this.latitude, this.longitude});

  Position.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Tags {
  String? title;

  Tags({this.title});

  Tags.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
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

  CurrentUserCollections({
    this.id,
    this.title,
    this.publishedAt,
    this.lastCollectedAt,
    this.updatedAt,
    this.coverPhoto,
    this.user,
  });

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

class Links {
  String? self;
  String? html;
  String? download;
  String? downloadLocation;

  Links({this.self, this.html, this.download, this.downloadLocation});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    download = json['download'];
    downloadLocation = json['download_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['download'] = download;
    data['download_location'] = downloadLocation;
    return data;
  }
}

// class User {
//   String? id;
//   String? updatedAt;
//   String? username;
//   String? name;
//   String? portfolioUrl;
//   String? bio;
//   String? location;
//   int? totalLikes;
//   int? totalPhotos;
//   int? totalCollections;
//   Links? links;

//   User({
//     this.id,
//     this.updatedAt,
//     this.username,
//     this.name,
//     this.portfolioUrl,
//     this.bio,
//     this.location,
//     this.totalLikes,
//     this.totalPhotos,
//     this.totalCollections,
//     this.links,
//   });

//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     updatedAt = json['updated_at'];
//     username = json['username'];
//     name = json['name'];
//     portfolioUrl = json['portfolio_url'];
//     bio = json['bio'];
//     location = json['location'];
//     totalLikes = json['total_likes'];
//     totalPhotos = json['total_photos'];
//     totalCollections = json['total_collections'];
//     links = json['links'] != null ? Links.fromJson(json['links']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['updated_at'] = updatedAt;
//     data['username'] = username;
//     data['name'] = name;
//     data['portfolio_url'] = portfolioUrl;
//     data['bio'] = bio;
//     data['location'] = location;
//     data['total_likes'] = totalLikes;
//     data['total_photos'] = totalPhotos;
//     data['total_collections'] = totalCollections;
//     if (links != null) {
//       data['links'] = links!.toJson();
//     }
//     return data;
//   }
// }

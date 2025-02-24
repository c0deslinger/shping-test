class Photo {
  /// Unique identifier for the photo
  final String id;

  /// Full-resolution image URL
  final String url;

  /// Smaller, optimized image URL for thumbnails
  final String smallUrl;

  /// Profile photo
  final String photoProfile;

  /// Title or description of the photo
  final String title;

  /// Name of the photographer
  final String photographer;

  /// Detailed description of the photo
  final String description;

  /// Number of likes the photo has received
  final int likes;

  /// Date when the photo was created
  final DateTime createdAt;

  /// List of tags associated with the photo
  final List<String> tags;

  /// Source of photo
  String? source;

  /// Constructor with named parameters and default values
  Photo(
      {required this.id,
      required this.url,
      required this.smallUrl,
      required this.title,
      required this.photoProfile,
      required this.photographer,
      this.description = '',
      this.likes = 0,
      required this.createdAt,
      this.source,
      this.tags = const []});

  /// Creates a Photo instance from a JSON map with flexible parsing
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      // Parse ID with fallback
      id: (json['id'] ?? json['photoId'] ?? '').toString(),

      // Parse URLs with multiple possible sources
      url: _parseUrl(json, ['url', 'urls', 'fullUrl'], 'regular'),
      smallUrl: _parseUrl(json, ['smallUrl', 'urls', 'small'], 'small'),

      // Parse title with multiple fallbacks
      title: _parseString(
          json,
          ['title', 'alt_description', 'description', 'name'],
          'Untitled Photo'),

      // Parse photographer name
      photographer: _parseString(
          json,
          ['photographer', 'user.name', 'author', 'creator'],
          'Unknown Photographer'),

      // Parse description
      description:
          _parseString(json, ['description', 'caption', 'alt_description'], ''),

      // Parse likes
      likes: _parseInt(json, ['likes', 'views', 'downloads'], 0),

      // Parse creation date
      createdAt:
          _parseDate(json, ['createdAt', 'created_at', 'uploadDate', 'date']),

      // Parse tags with flexible extraction
      tags: _parseTags(json),

      // Default favorite status
      source: json['source'],

      photoProfile: json['photoProfile'],
    );
  }

  /// Converts Photo instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'smallUrl': smallUrl,
      'title': title,
      'photographer': photographer,
      'description': description,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'isFavorite': source,
      'photoProfile': photoProfile
    };
  }

  /// Helper method to parse string values with multiple fallbacks
  static String _parseString(
      Map<String, dynamic> json, List<String> keys, String defaultValue) {
    for (final key in keys) {
      // Handle nested keys like 'user.name'
      dynamic value = json;
      final nestedKeys = key.split('.');

      for (final nestedKey in nestedKeys) {
        if (value is Map && value.containsKey(nestedKey)) {
          value = value[nestedKey];
        } else {
          value = null;
          break;
        }
      }

      if (value != null && value.toString().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return defaultValue;
  }

  /// Helper method to parse integer values
  static int _parseInt(
      Map<String, dynamic> json, List<String> keys, int defaultValue) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        return int.tryParse(value.toString()) ?? defaultValue;
      }
    }
    return defaultValue;
  }

  /// Helper method to parse URLs
  static String _parseUrl(
      Map<String, dynamic> json, List<String> keys, String defaultKey) {
    for (final key in keys) {
      dynamic value = json[key];

      // Handle nested URLs like 'urls.regular'
      if (value is Map && value.containsKey(defaultKey)) {
        value = value[defaultKey];
      }

      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  /// Helper method to parse date
  static DateTime _parseDate(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        try {
          return value is DateTime ? value : DateTime.parse(value.toString());
        } catch (_) {
          // Ignore parsing errors
        }
      }
    }
    return DateTime.now();
  }

  /// Flexible tag parsing from various possible sources
  static List<String> _parseTags(Map<String, dynamic> json) {
    final tagSources = ['tags', 'keywords', 'categories'];

    for (final source in tagSources) {
      final tags = json[source];

      if (tags != null) {
        if (tags is List) {
          // Handle list of strings or maps
          return tags
              .map((tag) => tag is Map
                  ? (tag['title'] ?? tag['name'] ?? '').toString()
                  : tag.toString())
              .where((tag) => tag.isNotEmpty)
              .toList();
        }

        if (tags is String) {
          // Handle comma-separated string
          return tags
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList();
        }
      }
    }

    return [];
  }

  /// Creates a copy of the photo with optional field overrides
  Photo copyWith(
      {String? id,
      String? url,
      String? smallUrl,
      String? title,
      String? photographer,
      String? description,
      String? source,
      int? likes,
      DateTime? createdAt,
      List<String>? tags,
      String? photoProfile}) {
    return Photo(
      id: id ?? this.id,
      url: url ?? this.url,
      smallUrl: smallUrl ?? this.smallUrl,
      title: title ?? this.title,
      photographer: photographer ?? this.photographer,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      photoProfile: photoProfile ?? this.photoProfile,
    );
  }
}

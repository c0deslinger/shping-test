class Photo {
  final String id;
  final String url;
  final String smallUrl;
  final String title;
  final String photographer;
  final String description;
  final int likes;
  final DateTime createdAt;
  final List<String> tags;

  Photo({
    required this.id,
    required this.url,
    required this.smallUrl,
    required this.title,
    required this.photographer,
    this.description = '',
    this.likes = 0,
    required this.createdAt,
    this.tags = const [],
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'] ?? json['urls']?['regular'] ?? '',
      smallUrl: json['smallUrl'] ?? json['urls']?['small'] ?? '',
      title: json['title'] ?? json['alt_description'] ?? 'Untitled Photo',
      photographer: json['photographer'] ?? json['user']?['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      likes: json['likes'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      tags: json['tags'] != null && json['tags'] is List
          ? (json['tags'] as List)
              .map((tag) {
                if (tag is String) return tag;
                if (tag is Map) return tag['title'] ?? '';
                return '';
              })
              .where((tag) => tag.isNotEmpty)
              .toList()
              .cast<String>()
          : [],
    );
  }

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
    };
  }
}

import 'package:shping_test/features/home/data/models/pixabay/pixabay_hits.dart';

class PixabayListPhotoResponse {
  int? total;
  int? totalHits;
  List<Hits>? hits;

  PixabayListPhotoResponse({this.total, this.totalHits, this.hits});

  PixabayListPhotoResponse.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalHits = json['totalHits'];
    if (json['hits'] != null) {
      hits = <Hits>[];
      json['hits'].forEach((v) {
        hits!.add(Hits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['totalHits'] = totalHits;
    if (hits != null) {
      data['hits'] = hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

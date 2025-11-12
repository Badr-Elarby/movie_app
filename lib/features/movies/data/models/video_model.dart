class VideoModel {
  VideoModel({
    required this.id,
    required this.iso6391,
    required this.iso31661,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
  });

  final String id;
  final String? iso6391;
  final String? iso31661;
  final String key;
  final String name;
  final String site;
  final int? size;
  final String type;

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String? ?? '',
      iso6391: json['iso_639_1'] as String?,
      iso31661: json['iso_3166_1'] as String?,
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      site: json['site'] as String? ?? '',
      size: (json['size'] as num?)?.toInt(),
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'iso_639_1': iso6391,
      'iso_3166_1': iso31661,
      'key': key,
      'name': name,
      'site': site,
      'size': size,
      'type': type,
    };
  }
}

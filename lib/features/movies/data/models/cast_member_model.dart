class CastMemberModel {
  CastMemberModel({
    required this.castId,
    required this.character,
    required this.name,
    required this.profilePath,
  });

  final int castId;
  final String character;
  final String name;
  final String? profilePath;

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      castId: json['cast_id'] as int? ?? 0,
      character: (json['character'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}

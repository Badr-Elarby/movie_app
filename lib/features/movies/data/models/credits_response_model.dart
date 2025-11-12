import 'cast_member_model.dart';

class CreditsResponseModel {
  CreditsResponseModel({required this.id, required this.cast});

  final int id;
  final List<CastMemberModel> cast;

  factory CreditsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? castJson = json['cast'] as List<dynamic>?;
    final List<CastMemberModel> castList = castJson != null
        ? castJson
              .map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <CastMemberModel>[];

    return CreditsResponseModel(id: json['id'] as int? ?? 0, cast: castList);
  }
}

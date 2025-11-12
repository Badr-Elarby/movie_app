import 'video_model.dart';

class VideosResponseModel {
  VideosResponseModel({required this.id, required this.results});

  final int id;
  final List<VideoModel> results;

  factory VideosResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? resultsJson = json['results'] as List<dynamic>?;
    return VideosResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: resultsJson != null
          ? resultsJson
                .map(
                  (dynamic e) => VideoModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : <VideoModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'results': results.map((VideoModel e) => e.toJson()).toList(),
    };
  }
}

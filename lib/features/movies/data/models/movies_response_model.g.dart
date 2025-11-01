// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoviesResponseModelAdapter extends TypeAdapter<MoviesResponseModel> {
  @override
  final int typeId = 1;

  @override
  MoviesResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoviesResponseModel(
      page: fields[0] as int,
      total_pages: fields[1] as int,
      results: (fields[2] as List).cast<MovieModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoviesResponseModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.total_pages)
      ..writeByte(2)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoviesResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

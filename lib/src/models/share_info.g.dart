// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareInfo _$ShareInfoFromJson(Map<String, dynamic> json) => ShareInfo(
      username: json['username'] as String,
      sharedScore: json['sharedScore'] as String,
      sharedScoreDate: DateTime.parse(json['sharedScoreDate'] as String),
    );

Map<String, dynamic> _$ShareInfoToJson(ShareInfo instance) => <String, dynamic>{
      'username': instance.username,
      'sharedScore': instance.sharedScore,
      'sharedScoreDate': instance.sharedScoreDate.toIso8601String(),
    };

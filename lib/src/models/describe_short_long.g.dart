// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescriptionShortLong _$DescriptionShortLongFromJson(
        Map<String, dynamic> json) =>
    DescriptionShortLong(
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
    );

Map<String, dynamic> _$DescriptionShortLongToJson(
        DescriptionShortLong instance) =>
    <String, dynamic>{
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
    };

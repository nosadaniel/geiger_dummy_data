// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      language: json['language'] as String? ?? "en",
      owner: json['owner'] as bool? ?? false,
      termsAndConditions: TermsAndConditions.fromJson(
          json['termsAndConditions'] as Map<String, dynamic>),
      consent: Consent.fromJson(json['consent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'language': instance.language,
      'owner': instance.owner,
      'termsAndConditions': instance.termsAndConditions.toJson(),
      'consent': instance.consent.toJson(),
    };

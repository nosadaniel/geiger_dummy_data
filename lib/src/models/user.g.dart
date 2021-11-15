// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      language: json['language'] as String? ?? "en",
      supervisor: json['supervisor'] as bool? ?? false,
      termsAndConditions: TermsAndConditions.fromJson(
          json['termsAndConditions'] as Map<String, dynamic>),
      consent: Consent.fromJson(json['consent'] as Map<String, dynamic>),
      deviceOwner: Device.fromJson(json['deviceOwner'] as Map<String, dynamic>),
      pairedDevices: (json['pairedDevices'] as List<dynamic>?)
          ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList(),
      shareInfo: json['shareInfo'] == null
          ? null
          : ShareInfo.fromJson(json['shareInfo'] as Map<String, dynamic>),
      mse: json['mse'] == null
          ? null
          : Mse.fromJson(json['mse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'language': instance.language,
      'supervisor': instance.supervisor,
      'termsAndConditions': instance.termsAndConditions.toJson(),
      'consent': instance.consent.toJson(),
      'deviceOwner': instance.deviceOwner.toJson(),
      'pairedDevices': instance.pairedDevices?.map((e) => e.toJson()).toList(),
      'shareInfo': instance.shareInfo?.toJson(),
      'mse': instance.mse?.toJson(),
    };

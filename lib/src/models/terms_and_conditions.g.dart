// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_and_conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsAndConditions _$TermsAndConditionsFromJson(Map<String, dynamic> json) =>
    TermsAndConditions(
      ageCompliant: json['ageCompliant'] as bool? ?? false,
      signedConsent: json['signedConsent'] as bool? ?? false,
      agreedPrivacy: json['agreedPrivacy'] as bool? ?? false,
    );

Map<String, dynamic> _$TermsAndConditionsToJson(TermsAndConditions instance) =>
    <String, dynamic>{
      'ageCompliant': instance.ageCompliant,
      'signedConsent': instance.signedConsent,
      'agreedPrivacy': instance.agreedPrivacy,
    };

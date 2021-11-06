import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms_and_conditions.g.dart';

@JsonSerializable(explicitToJson: true)
class TermsAndConditions extends Equatable {
  final bool ageCompliant;
  final bool signedConsent;
  final bool agreedPrivacy;

  TermsAndConditions(
      {this.ageCompliant: false,
      this.signedConsent: false,
      this.agreedPrivacy: false});

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return _$TermsAndConditionsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TermsAndConditionsToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"ageCompliant":$ageCompliant, "signedConsent":$signedConsent, "agreedPrivacy":$agreedPrivacy}';
  }

  @override
  List<Object> get props => [ageCompliant, signedConsent, agreedPrivacy];
}

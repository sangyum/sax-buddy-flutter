import '../../assessment/models/assessment_result.dart';

class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final bool hasActiveSubscription;
  final DateTime? trialEndsAt;
  final AssessmentResult? currentAssessment;
  final DateTime? lastAssessmentDate;
  final int assessmentCount;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.hasActiveSubscription,
    this.trialEndsAt,
    this.currentAssessment,
    this.lastAssessmentDate,
    this.assessmentCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      hasActiveSubscription: json['hasActiveSubscription'] as bool,
      trialEndsAt: json['trialEndsAt'] != null
          ? DateTime.parse(json['trialEndsAt'] as String)
          : null,
      currentAssessment: json['currentAssessment'] != null
          ? AssessmentResult.fromJson(json['currentAssessment'] as Map<String, dynamic>)
          : null,
      lastAssessmentDate: json['lastAssessmentDate'] != null
          ? DateTime.parse(json['lastAssessmentDate'] as String)
          : null,
      assessmentCount: json['assessmentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'hasActiveSubscription': hasActiveSubscription,
      'trialEndsAt': trialEndsAt?.toIso8601String(),
      'currentAssessment': currentAssessment?.toJson(),
      'lastAssessmentDate': lastAssessmentDate?.toIso8601String(),
      'assessmentCount': assessmentCount,
    };
  }

  bool get isTrialActive {
    if (trialEndsAt == null) return false;
    return DateTime.now().isBefore(trialEndsAt!);
  }

  bool get hasAccess {
    return hasActiveSubscription || isTrialActive;
  }

  bool get hasCompletedAssessment {
    return currentAssessment != null;
  }

  SkillLevel? get currentSkillLevel {
    return currentAssessment?.skillLevel;
  }
}
// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sax_buddy/features/assessment/bloc/assessment_complete_cubit.dart'
    as _i339;
import 'package:sax_buddy/features/assessment/domain/assessment_analyzer.dart'
    as _i641;
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart'
    as _i565;
import 'package:sax_buddy/features/assessment/services/audio_analysis_dataset_service.dart'
    as _i296;
import 'package:sax_buddy/features/auth/providers/auth_provider.dart' as _i536;
import 'package:sax_buddy/features/auth/repositories/user_repository.dart'
    as _i692;
import 'package:sax_buddy/features/auth/services/auth_service.dart' as _i640;
import 'package:sax_buddy/features/practice/repositories/practice_routine_repository.dart'
    as _i727;
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart'
    as _i678;
import 'package:sax_buddy/features/routines/providers/routines_provider.dart'
    as _i824;
import 'package:sax_buddy/injection_module.dart' as _i863;
import 'package:sax_buddy/services/audio_analysis_service.dart' as _i749;
import 'package:sax_buddy/services/audio_recording_service.dart' as _i415;
import 'package:sax_buddy/services/firebase_storage_service.dart' as _i174;
import 'package:sax_buddy/services/logger_service.dart' as _i266;
import 'package:sax_buddy/services/musicxml_service.dart' as _i686;
import 'package:sax_buddy/services/openai_service.dart' as _i993;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.factory<_i641.AssessmentAnalyzer>(() => _i641.AssessmentAnalyzer());
    gh.singleton<_i974.FirebaseFirestore>(() => injectionModule.firestore);
    gh.singleton<_i59.FirebaseAuth>(() => injectionModule.firebaseAuth);
    gh.singleton<_i266.LoggerService>(() => _i266.LoggerService());
    gh.singleton<_i640.AuthService>(
      () =>
          _i640.AuthService(gh<_i59.FirebaseAuth>(), gh<_i266.LoggerService>()),
    );
    gh.factory<_i692.UserRepository>(
      () => _i692.UserRepository(
        gh<_i974.FirebaseFirestore>(),
        gh<_i266.LoggerService>(),
      ),
    );
    gh.factory<_i727.PracticeRoutineRepository>(
      () => _i727.PracticeRoutineRepository(
        gh<_i974.FirebaseFirestore>(),
        gh<_i266.LoggerService>(),
      ),
    );
    gh.factory<_i824.RoutinesProvider>(
      () => _i824.RoutinesProvider(
        gh<_i266.LoggerService>(),
        gh<_i727.PracticeRoutineRepository>(),
      ),
    );
    gh.factory<_i536.AuthProvider>(
      () => _i536.AuthProvider(
        gh<_i640.AuthService>(),
        gh<_i692.UserRepository>(),
        gh<_i266.LoggerService>(),
      ),
    );
    gh.factory<_i415.AudioRecordingService>(
      () => _i415.AudioRecordingService(gh<_i266.LoggerService>()),
    );
    gh.factory<_i174.FirebaseStorageService>(
      () => _i174.FirebaseStorageService(gh<_i266.LoggerService>()),
    );
    gh.singleton<_i993.OpenAIService>(
      () => _i993.OpenAIService(gh<_i266.LoggerService>()),
    );
    gh.lazySingleton<_i296.AudioAnalysisDatasetService>(
      () => _i296.AudioAnalysisDatasetService(gh<_i266.LoggerService>()),
    );
    gh.lazySingleton<_i686.MusicXMLService>(
      () => _i686.MusicXMLService(gh<_i266.LoggerService>()),
    );
    gh.lazySingleton<_i749.AudioAnalysisService>(
      () => _i749.AudioAnalysisService(gh<_i266.LoggerService>()),
    );
    gh.lazySingleton<_i678.PracticeGenerationService>(
      () => _i678.PracticeGenerationService(
        gh<_i266.LoggerService>(),
        gh<_i993.OpenAIService>(),
        gh<_i296.AudioAnalysisDatasetService>(),
      ),
    );
    gh.factory<_i339.AssessmentCompleteCubit>(
      () => _i339.AssessmentCompleteCubit(
        gh<_i641.AssessmentAnalyzer>(),
        gh<_i678.PracticeGenerationService>(),
        gh<_i266.LoggerService>(),
      ),
    );
    gh.factory<_i565.AssessmentProvider>(
      () => _i565.AssessmentProvider(
        gh<_i266.LoggerService>(),
        gh<_i415.AudioRecordingService>(),
        gh<_i749.AudioAnalysisService>(),
        gh<_i174.FirebaseStorageService>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i863.InjectionModule {}

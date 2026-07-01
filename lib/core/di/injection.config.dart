// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tracker/application/projects/create_project_use_case.dart'
    as _i73;
import 'package:tracker/core/di/database_module.dart' as _i537;
import 'package:tracker/domain/repositories/project_repository.dart' as _i241;
import 'package:tracker/infrastructure/persistence/app_database.dart' as _i227;
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart'
    as _i835;
import 'package:tracker/infrastructure/repositories/project_repository_impl.dart'
    as _i706;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    await gh.lazySingletonAsync<_i227.AppDatabase>(
      () => databaseModule.database,
      preResolve: true,
    );
    gh.lazySingleton<_i835.ProjectDao>(
      () => databaseModule.projectDao(gh<_i227.AppDatabase>()),
    );
    gh.lazySingleton<_i241.IProjectRepository>(
      () => _i706.ProjectRepositoryImpl(gh<_i835.ProjectDao>()),
    );
    gh.factory<_i73.CreateProjectUseCase>(
      () => _i73.CreateProjectUseCase(gh<_i241.IProjectRepository>()),
    );
    return this;
  }
}

class _$DatabaseModule extends _i537.DatabaseModule {}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tracker/application/projects/create_project_use_case.dart'
    as _i73;
import 'package:tracker/application/projects/get_all_projects_use_case.dart'
    as _i711;
import 'package:tracker/core/di/database_module.dart' as _i537;
import 'package:tracker/core/di/network_module.dart' as _i456;
import 'package:tracker/core/seed/data_seeder.dart' as _i1031;
import 'package:tracker/domain/repositories/project_repository.dart' as _i241;
import 'package:tracker/infrastructure/datasources/project_remote_data_source.dart'
    as _i224;
import 'package:tracker/infrastructure/persistence/app_database.dart' as _i227;
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart'
    as _i835;
import 'package:tracker/infrastructure/repositories/project_repository_impl.dart'
    as _i706;
import 'package:tracker/infrastructure/seed/dev_data_seeder.dart' as _i583;
import 'package:tracker/infrastructure/seed/prod_data_seeder.dart' as _i5;

const String _prod = 'prod';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i227.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i835.ProjectDao>(
      () => databaseModule.projectDao(gh<_i227.AppDatabase>()),
    );
    gh.lazySingleton<_i224.IProjectRemoteDataSource>(
      () => _i224.ProjectRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i241.IProjectRepository>(
      () => _i706.ProjectRepositoryImpl(gh<_i835.ProjectDao>()),
    );
    gh.lazySingleton<_i1031.IDataSeeder>(
      () => _i5.ProdDataSeeder(),
      registerFor: {_prod},
    );
    gh.factory<_i73.CreateProjectUseCase>(
      () => _i73.CreateProjectUseCase(gh<_i241.IProjectRepository>()),
    );
    gh.factory<_i711.GetAllProjectsUseCase>(
      () => _i711.GetAllProjectsUseCase(gh<_i241.IProjectRepository>()),
    );
    gh.lazySingleton<_i1031.IDataSeeder>(
      () => _i583.DevDataSeeder(
        gh<_i241.IProjectRepository>(),
        gh<_i73.CreateProjectUseCase>(),
      ),
      registerFor: {_dev},
    );
    return this;
  }
}

class _$DatabaseModule extends _i537.DatabaseModule {}

class _$NetworkModule extends _i456.NetworkModule {}

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/repository/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {

  // Application Logic
  serviceLocator.registerFactory(() => AuthenticationCubit(
      createUser: serviceLocator(), getUsers: serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(() => CreateUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetUsers(serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(serviceLocator()));

  // DataSources
  serviceLocator.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImplementation(serviceLocator()));

  // External dependencies
  serviceLocator.registerLazySingleton(() => http.Client.new);
}

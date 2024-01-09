import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/repository/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImplementation;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      APIException(message: 'Unknown Error Occurred', statusCode: 500);

  group(
    'createUser',
    () {
      const createdAt = 'whatever.createdAt';
      const name = 'whatever.name';
      const avatar = 'whatever.avatar';
      test(
        'should call the [RemoteDataSource.createUser]'
        'and return the complete successfully when the call to the remote source is successful',
        () async {
          // Arrange
          when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'))).thenAnswer((_) => Future.value());

          // Act
          final result = await repositoryImplementation.createUser(
              createdAt: createdAt, name: name, avatar: avatar);

          // Assert
          expect(result, equals(const Right(null)));
          // check that remote source\s createUser gets called  and with the right data
          verify(() => remoteDataSource.createUser(
              createdAt: createdAt, name: name, avatar: avatar)).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'should return a [ServerFailure] when the call to the remote source is unsuccessful',
        () async {
          // Arrange
          when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'))).thenThrow(tException);

          // Act
          final result = await repositoryImplementation.createUser(
              createdAt: createdAt, name: name, avatar: avatar);
          expect(
              result,
              equals(Left(APIFailure(
                  message: tException.message,
                  statusCode: tException.statusCode))));
          verify(() => remoteDataSource.createUser(
              createdAt: createdAt, name: name, avatar: avatar)).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group('getUsers', () {
    test(
        'should call a [RemoteDataSource.getUsers] and return [List<User>] when call to remote source is successful',
        () async {
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

      // Act
      final result = await repositoryImplementation.getUsers();

      // Assert
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [ServerFailure] when the call to the remote source is unsuccessful',
        () async {
      when(() => remoteDataSource.getUsers()).thenThrow(tException);

      // Act
      final result = await repositoryImplementation.getUsers();

      // Assert
      expect(result, equals(Left(APIFailure.fromException(tException))));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions((remoteDataSource));
    });
  });
}

// what does the class depend on?
// Nothing the cla

// how can we create a fake version of the dependency?
// use Mocktail

// how do we control what our dependency does?
// using mocktail API

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  // 1. Make sure the class is a subclass of the entity
  test('should be a subclass of [User] entity', () {
    // Act
    // we don't need to Act

    // Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with correct data', () {
      // Arrange

      // Act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
      // Assert
    });
  });

  group('fromJason', () {
    test('should return a [UserModel] with correct data', () {
      // Arrange

      // Act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return [Map] with correct data', () {
      // Act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a correct [JSON]', () {
      // Act
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });
      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a correct Name after using [CopyWith]', () {
      // Act
      final result = tModel.copyWith(name: 'Paul');

      // Assert
      expect(result.name, equals('Paul'));
      expect(result.avatar, equals('_empty.avatar'));
      expect(result.id, equals('1'));
      expect(result != tModel, true);
    });
  });
}

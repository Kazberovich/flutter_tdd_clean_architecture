import 'dart:convert';

import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constants.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/users'; // - post
const kGetUsersEndpoint = '/users'; // - get

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // 1. check to make sure that it returns the right data when the status code is 200 or the proper response code
    // 2. check to make sure that it 'THROWS A CUSTOM EXCEPTION' with the right message when status code is the bad one

    try {
      final response = await _client.post(
        Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          avatar: avatar,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } catch (e) {
      // TODO: Stopped here...
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}

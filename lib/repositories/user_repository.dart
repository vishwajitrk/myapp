import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:myapp/models/user.dart';
import 'package:myapp/services/api_service.dart';

class UserRepository {
  static const baseUrl = "https://reqres.in";

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<User> users = User.fromJsonArray(data["data"]);
        return users;
      } else {
        throw Exception(json.decode(response.body)['error']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<User> addUser(dynamic body) async* {
    final response = await http.post(Uri.parse('$baseUrl/api/users/'),
        body: jsonEncode(body));
    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      var user = User(
        id: int.parse(data['id']),
        email: body['email'],
        name: body['first_name'],
        lastName: body['last_name'],
        avatar: body['avatar'],
        status: '',
        gender: '',
      );
      yield user;
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }

  // static addUser(dynamic body) async {
  //   final response = await http.post(Uri.parse('$baseUrl/api/users'),
  //       body: jsonEncode(body));
  //       print(response.statusCode);
  //   if (response.statusCode == 201) {
  //     var data = json.decode(response.body);
  //     print(data);
  //     body['id'] = data['id'];
  //     print(jsonEncode(body));
  //     User user = User.fromJSON(body);
  //     return user;
  //   } else {
  //     throw Exception(json.decode(response.body)['error']);
  //   }
  // }

  Stream<int> updateUser(int id, dynamic body) async* {
    final response = await http.put(Uri.parse('$baseUrl/api/users/$id'),
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      yield id;
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }

  Stream<int> deleteUser(int id) async* {
    final response = await http.delete(Uri.parse('$baseUrl/api/users/$id'));
    if (response.statusCode == 204) {
      yield id;
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
    // await Future.delayed(Duration(seconds: _next(1, 5)));
    // yield id;
  }

  final _random = Random();
  int _next(int min, int max) => min + _random.nextInt(max - min);
  Future<List<User>> getUser() async {
    await Future.delayed(Duration(seconds: _next(1, 5)));
    return List.of(_generateUsersList());
  }

  List<User> _generateUsersList() {
    final List<User> items = [];
    items.add(const User(id: 1, email: '', status: '', name: 'C', gender: 'C'));
    items.add(
        const User(id: 2, email: '', status: '', name: 'C++', gender: 'C'));
    items.add(const User(
        id: 3, email: '', status: '', name: 'DATA STRUCTURE', gender: 'C'));
    items.add(
        const User(id: 4, email: '', status: '', name: 'PHP', gender: 'C'));
    items.add(
        const User(id: 5, email: '', status: '', name: 'ANDROID', gender: 'C'));
    return items;
  }

  static APIService<User> getId(int id) {
    return APIService(
        url: Uri.http('reqres.in', "/api/users/" + id.toString()),
        parse: (response) {
          final parsed = json.decode(response.body);
          var data = User.fromJSON(parsed['data']);

          return data;
        });
  }
}

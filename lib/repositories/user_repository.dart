import 'dart:convert';
import 'dart:io';

import 'package:myapp/models/user.dart';
import 'package:myapp/services/api_service.dart';

class UserRepository{
  // https://reqres.in/
  static const baseUrl = "reqres.in";

  static APIService<User> getId(int id){
    return APIService(
      url: Uri.http(baseUrl, "/api/users/" + id.toString()),
      parse: (response){
        final parsed = json.decode(response.body);
        // final dataJson = ResultModel.fromJSON(parsed);
        var data = User.fromJSON(parsed['data']);

        return data;
      }
    );
  } 

  static APIService<int> update(dynamic body, File? file){
    List<File> _files = [];

    if(file != null){
      _files.add(file);
    }

    return APIService(
      url: Uri.http(baseUrl, "/api/users/" + body['id'].toString()),
      body: body,
      // files: _files,
      parse: (response){
        final parsed = json.decode(response.body);
        // final dataJson = ResultModel.fromJSON(parsed);
        var data = parsed;

        return data;
      }
    );

  }
}
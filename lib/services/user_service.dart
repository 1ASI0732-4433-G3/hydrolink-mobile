import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'base_service.dart';

class UserService extends BaseService<UserModel> {
  UserService(super.context)
      : super(
    resourceEndpoint: '/users',
    fromJson: (json) => UserModel.fromJson(json),
  );

  Future<UserModel> getByUsername(String username) async {
    final loading = getLoadingProvider();
    loading.start();

    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$resourcePath/$username'),
        headers: headers,
      );

      handleErrors(response);
      return fromJson(json.decode(response.body)); // También reusado
    } finally {
      loading.stop();
    }
  }

}

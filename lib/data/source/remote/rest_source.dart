import 'package:dio/dio.dart';
import 'package:estesis_tech/data/source/locale/secure_storage_source.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/domain/model/task/task.dart';
import 'package:estesis_tech/domain/model/user/user.dart';
import 'package:estesis_tech/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class RestSource {
  final Dio _dio;
  final SecureStorageSource _secureStorageSource;

  static const String _baseUrl = 'https://test-mobile.estesis.tech/api/v1';
  static const String _register = '/register';
  static const String _login = '/login';
  static const String _usersMe = '/users/me';
  static const String _tasks = '/tasks';
  static const String _refreshToken = '/refresh_token';
  static const String _tags = '/tags';

  RestSource._(
    this._dio,
    this._secureStorageSource,
  );

  @factoryMethod
  static RestSource create() {
    final dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
        connectTimeout: const Duration(seconds: 40),
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final secureStorage = getIt.get<SecureStorageSource>();
    return RestSource._(
      dio,
      secureStorage,
    );
  }

  Future<User> signUp(
    String name,
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      _register,
      data: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
    return User.fromJson(response.data);
  }

  Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      _login,
      data: {
        'grant_type': 'password',
        'username': email,
        'password': password,
        'scope': '',
        'client_id': 'string',
        'client_secret': 'string',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    return response.data;
  }

  Future<User> getUserMe() async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      final response = await _dio.get(
        _usersMe,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return User.fromJson(response.data);
    } on DioException catch (_) {
      _updateToken();
      final user = await getUserMe();
      return user;
    }
  }

  Future<List<Task>> getTasks({
    required int limit,
    required int offset,
    String? maxCreatedDate,
    String? minCreatedDate,
  }) async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      final response = await _dio.get(
        _tasks,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (maxCreatedDate != null) 'maxCreatedDate': maxCreatedDate,
          if (minCreatedDate != null) 'minCreatedDate': minCreatedDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final List<Task> listTasks = (response.data['items'] as List<dynamic>)
          .map((e) => Task.fromMap(e))
          .toList();
      return listTasks;
    } on DioException catch (_) {
      await _updateToken();
      final listTasks = await getTasks(limit: limit, offset: offset);
      return listTasks;
    }
  }

  Future<List<Tag>> getTags() async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      final response = await _dio.get(
        _tags,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final listTags = (response.data['items'] as List<dynamic>)
          .map(
            (e) => Tag.fromMap(e),
          )
          .toList();
      return listTags;
    } on DioException catch (e) {
      await _updateToken();
      final listTags = await getTags();
      return listTags;
    }
  }

  Future<Task> createTask({
    required String tagSid,
    required String title,
    required String text,
    required String finishAt,
    required int priority,
  }) async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      final response = await _dio.post(
        _tasks,
        data: {
          "tagSid": tagSid,
          "title": title,
          "text": text,
          "finishAt": finishAt,
          "priority": priority,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return Task.fromMap(response.data);
    } on DioException catch (e) {
      Logger().e(e.message);
      await _updateToken();
      final task = await createTask(
        tagSid: tagSid,
        title: title,
        text: text,
        finishAt: finishAt,
        priority: priority,
      );
      return task;
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      final response = await _dio.put(
        _tasks,
        data: {
          "title": task.title,
          "text": task.text,
          "finishAt": task.finishAt,
          "priority": task.priority,
          "tagSid": task.tag.sid,
          "isDone": true,
          "sid": task.sid
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return Task.fromMap(response.data);
    } on DioException catch (_) {
      await _updateToken();
      return await updateTask(task);
    }
  }

  Future<void> removeTask({required String taskSid}) async {
    try {
      final accessToken = await _secureStorageSource.getAccessToken();
      await _dio.delete(
        _tasks,
        queryParameters: {
          'taskSid': taskSid,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (_) {
      await _updateToken();
      await removeTask(taskSid: taskSid);
    }
  }

  Future<void> _updateToken() async {
    final refreshToken = await _secureStorageSource.getRefreshToken();
    final response = await _dio.post(
      _refreshToken,
      queryParameters: {
        'refresh_token': refreshToken,
      },
    );
    await _secureStorageSource.setAccessToken(response.data['access_token']);
    await _secureStorageSource.setRefreshToken(response.data['refresh_token']);
  }
}

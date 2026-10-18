import 'package:cloud_functions/cloud_functions.dart';

import '../core/errors/app_error.dart';

/// Thin wrapper over callable Cloud Functions with consistent error mapping.
class FunctionsService {
  FunctionsService(this._functions);
  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> call(String name, [Map<String, dynamic> data = const {}, Duration? timeout]) async {
    try {
      final callable = _functions.httpsCallable(name, options: HttpsCallableOptions(timeout: timeout ?? const Duration(seconds: 70)));
      final res = await callable.call<Object?>(data);
      final v = res.data;
      return v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
    } catch (e) {
      throw AppError.from(e);
    }
  }
}

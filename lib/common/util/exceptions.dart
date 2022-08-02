import 'dart:async';

//import 'package:appwrite/appwrite.dart';
//import 'package:google_docs_clone/app/utils.dart';
import 'logger.dart';

class CretaException implements Exception {
  const CretaException({required this.message, this.exception, this.stackTrace});

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return "CretaException: ($message)";
  }
}

mixin CretaExceptionMixin {
  Future<T> exceptionHandler<T>(
    FutureOr computation, {
    String unkownMessage = 'Creta Exception',
  }) async {
    try {
      return await computation;
      // } on AppwriteException catch (e) {
      //   trace.warning(e.message, e);
      //   throw RepositoryException(message: e.message ?? 'An undefined error occured');
    } on Exception catch (e, st) {
      logger.severe(unkownMessage, e, st);
      throw CretaException(message: unkownMessage, exception: e, stackTrace: st);
    }
  }
}

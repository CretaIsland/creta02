abstract class AbsFunction {
  void initialize();
  Future<String> execute({required String functionId, String? params, bool isAsync = true});
}

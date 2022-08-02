abstract class AbsDatabase {
  void initialize();

  Future<Map<String, dynamic>> getData(String collectionId, String key);
  Future<List> getAllData(String collectionId);
  Future<List> queryData(String collectionId,
      {required String name,
      required String value,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset});
  Future<void> setData(String collectionId, String key, Map<dynamic, dynamic> data);
  Future<void> createData(String collectionId, String? key, Map<dynamic, dynamic> data);
  Future<bool> removeData(String collectionId, String? key);
}

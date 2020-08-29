import 'package:zyuedu/data/net/dio_utils.dart';

class Sources {
  ///获取首页小说列表
  Future<Map> search(queryParameters, data, method) async {
    return await DioUtils().request<String>(
      "http://www.xbiquge.la/modules/article/waps.php",
      queryParameters: queryParameters,
      method: Method.post,
      data: data,
    );
  }
}
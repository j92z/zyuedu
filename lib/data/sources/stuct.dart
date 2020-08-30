import 'package:dio/dio.dart';
import 'package:zyuedu/data/net/dio_utils.dart';

class Sources {
  ///获取首页小说列表
  Future<Map> search(url, {queryParameters, data, method}) async {
    return await DioUtils().request<String>(
      url,
      queryParameters: queryParameters == null ? Map<String, dynamic>() : queryParameters,
      method: method == null ? Method.get : method,
      data: data == null ? FormData(): data,
    );
  }

  ///获取小说详细信息
  Future<Map> detail(url, {queryParameters, data, method}) async {
    return await DioUtils().request<String>(
      url,
      queryParameters: queryParameters == null ? Map<String, dynamic>() : queryParameters,
      method: method == null ? Method.get : method,
      data: data == null ? FormData(): data,
    );
  }
}
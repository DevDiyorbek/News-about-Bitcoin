import 'dart:convert';
import 'dart:io';
import 'package:bitcoin_news/models/news_model.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'http_helper.dart';

class Network {
  static bool isTester = true;
  static String SERVER_DEV = "newsapi.org";
  static String SERVER_PROD = "newsapi.org";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String getServer() {
    if (isTester) return SERVER_DEV;
    return SERVER_PROD;
  }

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  /* Http Apis*/
  static String API_NEWS_LIST = "/api";

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  //limit=20&page=0&order=DESC
  static Map<String, String> paramsNewsList(int page) {
    Map<String, String> params = {};
    params.addAll({'results': "20", 'page': page.toString()});
    return params;
  }

/* Http Parsing */

  static ListOfNews parseNewsList(String response) {
    dynamic json = jsonDecode(response);
    return ListOfNews.fromJson(json);
  }
}
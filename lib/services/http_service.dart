import 'dart:convert';
import 'dart:io';
import 'package:bitcoin_news/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'http_helper.dart';

class Network {
  static bool isTester = true;
  static const String SERVER_DEV = "newsapi.org";
  static const String SERVER_PROD = "newsapi.org";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String getServer() {
    return isTester ? SERVER_DEV : SERVER_PROD;
  }

  /* Http Requests */
  static Future<String?> getRequest(String api, Map<String, String> params) async {
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
    return null;
  }

  static void _throwException(http.Response response) {
    String reason = response.reasonPhrase ?? 'Unknown error';
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

  /* Http Apis */
  static const String API_NEWS_LIST = "/v2/everything";

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    return {};
  }

  static Map<String, String> paramsNewsList(int page) {
    return {'pageSize': "20", 'page': page.toString(), 'q': 'bitcoin', 'apiKey': '544169807a4045e0ba3be4055e8af97e'};
  }

  /* Http Parsing */
  static ListOfNews parseNewsList(String response) {
    dynamic json = jsonDecode(response);
    return ListOfNews.fromJson(json);
  }
}

import 'dart:convert';

import 'package:tuite/model/home_list_model.dart';

// dart文件可以不取类名只写方法，由调用方自定义类名
import 'package:http/http.dart' as httpPlugin;
import 'home_timeline_data.dart' as homeTimeLineData;
import 'package:crypto/crypto.dart';

const BASE_DOMAIN = 'https://api.twitter.com';
const HOME_TIMELINE_URL = "/1.1/statuses/home_timeline.json";

class NetService {
  static String get authParams {
    String timeStamp = new DateTime.now().microsecondsSinceEpoch.toString();
    print('timeStamp == ' + timeStamp);
    return 'oauth_consumer_key=08uIIOBhb01ajxoLSiYskmK9L&'
        'oauth_nonce=NDMyNTk4NzM0MjUwOTgzNDc1ODM5ODU3NjQ3NTY4MzQ&'
        'oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timeStamp&'
        'oauth_token=736198546236411905-kx70ljMQ1oXbqEX2zuFgtuFw1EoLY3W&'
        'oauth_version=1.0&screen_name=QoogZuwdghUwO6h&tweet_mode=extended&'
        'include_entities=true';
  }

  String get authInfo {
    String timeStamp = new DateTime.now().microsecondsSinceEpoch.toString();
    print('timeStamp == ' + timeStamp);
    String authInfo =
        'OAuth oauth_consumer_key="08uIIOBhb01ajxoLSiYskmK9L", oauth_nonce="NDMyNTk4NzM0MjUwOTgzNDc1ODM5ODU3NjQ3NTY4MzQ", oauth_signature="WSh37hgBX1m7Sc%2Bu40YW4PhWmvk%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp=${timeStamp}, oauth_token="736198546236411905-kx70ljMQ1oXbqEX2zuFgtuFw1EoLY3W", oauth_version="1.0"';
  }

  /// Future表示未来的一个返回值，即await延迟执行的结果；
  ///
  /// async表示函数是一个异步函数，返回值为Future类型，Dart规定有async标记的函数，
  /// 只能由await来调用，例如：String data = await getData()；
  ///
  /// 在Dart中，有await标记的运算，其结果值都是一个Future对象，要使用await，
  /// 必须在有async标记的函数中运行，否则这个await会报错
  static Future<HomeListModel> getHomeList(
      int pageIndex, String userName) async {
    String signBase = Uri.encodeComponent('GET') + '&' +Uri.decodeComponent(BASE_DOMAIN + HOME_TIMELINE_URL) +
    '&' + Uri.decodeComponent(authParams);
    String signKey = 's7H38rTHA0yjvYlBl4q3eCGb7159XypW7YldqT5qS6vBbN1XOg&VcuAtbaluIgEsZwUMPBG0pjNEUeFo8JKeewSevCKk7Nsn';

    // map是可选参数
    var uri =
        Uri.https(BASE_DOMAIN, HOME_TIMELINE_URL, {'screen_name': userName});
    var response =
        await httpPlugin.get(uri, headers: {'Authorization': '12312'});
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
    } else {
      throw Exception('Failed to getHomeList');
    }

    return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
  }
}

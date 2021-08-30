import 'dart:convert';

import 'package:tuite/model/home_list_model.dart';

// dart文件可以不取类名只写方法，由调用方自定义类名
import 'package:http/http.dart' as httpPlugin;
import 'home_timeline_data.dart' as homeTimeLineData;
import 'package:crypto/crypto.dart';

const BASE_DOMAIN = 'api.twitter.com';
const apiKey = 'pSrO11kSygw7Lot2lFHtnD9df';
const apiSecretKey = 'hokhAxCucTkLvSZvXQXndPoHnaVsWHI76dwCpzRQ3FGqgAUXwo';
const accessToken = '736198546236411905-1MaDM9paBpRf8FKv20AYk8R2R7sofJp';
const accessTokenSecret = 'OkB9OVP2UnHin5aNIGW5Rr52eNpSep2j3ZOCmaRTR5A8U';

class NetService {
  /// Future表示未来的一个返回值，即await延迟执行的结果；
  ///
  /// async表示函数是一个异步函数，返回值为Future类型，Dart规定有async标记的函数，
  /// 只能由await来调用，例如：String data = await getData()；
  ///
  /// 在Dart中，有await标记的运算，其结果值都是一个Future对象，要使用await，
  /// 必须在有async标记的函数中运行，否则这个await会报错
  static Future<HomeListModel> getHomeList(
      int pageIndex, String userName) async {
    String requestUrl = "/1.1/statuses/home_timeline.json";
    int timeStampValue = new DateTime.now().millisecondsSinceEpoch;
    String timeStamp = '1630330713';
    String oauthNonce = 'NDMyNTk4NzM0MjUwOTgzNDc1ODM5ODU3NjQ3NTY4MzK';

    String authParams = 'oauth_consumer_key=$apiKey&'
        'oauth_nonce=$oauthNonce&'
        'oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timeStamp&'
        'oauth_token=$accessToken&'
        'oauth_version=1.0&screen_name=$userName&tweet_mode=extended';

    print('timeStamp == ' + timeStamp);
    // 签名base：请求方式&url&参数
    String baseString = Uri.encodeComponent('GET') +
        '&' +
        Uri.decodeComponent('https://api.twitter.com' + requestUrl) +
        '&' +
        Uri.decodeComponent(authParams);
    print('baseString == ' + baseString);
    // 签名密钥
    String signingKey = '$apiSecretKey&$accessTokenSecret';
    print('signingKey == ' + signingKey);
    var hMac = Hmac(sha1, signingKey.codeUnits);
    String signResult = Uri.encodeComponent(
        base64Encode(hMac.convert(baseString.codeUnits).bytes));
    print('signResult == ' + signResult);
    String authInfo = 'OAuth oauth_consumer_key="$apiKey", '
        'oauth_nonce="$oauthNonce", '
        'oauth_signature=$signResult, '
        'oauth_signature_method="HMAC-SHA1", '
        'oauth_timestamp="$timeStamp", '
        'oauth_token="$accessToken", '
        'oauth_version="1.0"';

    // map是可选参数
    var uri = Uri.https(BASE_DOMAIN, requestUrl,
        {'screen_name': userName, 'tweet_mode': 'extended'});
    var response =
        await httpPlugin.get(uri, headers: {'Authorization': authInfo});
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeListModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to getHomeList, code == ${response.statusCode}, '
          'error == ${response.reasonPhrase}');
    }

    return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
  }
}

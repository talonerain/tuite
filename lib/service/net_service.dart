import 'dart:convert';

import 'package:tuite/model/home_list_model.dart';

// dart文件可以不取类名只写方法，由调用方自定义类名
import 'package:http/http.dart';
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
    int timeStampValue = (new DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    String timeStamp = timeStampValue.toString();
    String oauthNonce = 'NDMyNTk4NzM0MjUwOTgzNDc1ODM5ODU3NjQ3NTY4MzK';
    // 认证参数：用于构建签名base
    String authParams = 'oauth_consumer_key=$apiKey&'
        'oauth_nonce=$oauthNonce&'
        'oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timeStamp&'
        'oauth_token=$accessToken&'
        'oauth_version=1.0&screen_name=$userName&tweet_mode=extended';
    // 签名base：请求方式&url&认证参数
    String baseString = Uri.encodeComponent('GET') +
        '&' +
        Uri.encodeComponent('https://api.twitter.com' + requestUrl) +
        '&' +
        Uri.encodeComponent(authParams);
    // 签名密钥
    String signingKey = '$apiSecretKey&$accessTokenSecret';
    // 签名
    var hMac = Hmac(sha1, signingKey.codeUnits);
    String signResult = Uri.encodeComponent(
        base64Encode(hMac.convert(baseString.codeUnits).bytes));
    // 认证信息，请求头带到后端
    String authInfo = 'OAuth oauth_consumer_key="$apiKey", '
        'oauth_nonce="$oauthNonce", '
        'oauth_signature=$signResult, '
        'oauth_signature_method="HMAC-SHA1", '
        'oauth_timestamp="$timeStamp", '
        'oauth_token="$accessToken", '
        'oauth_version="1.0"';
    print('authInfo == $authInfo');
    // 构建url，map是可选参数
    Uri uri = Uri.https(BASE_DOMAIN, requestUrl,
        {'screen_name': userName, 'tweet_mode': 'extended'});
    var response = await get(uri, headers: {'Authorization': authInfo});
    print('response.statusCode == ${response.statusCode}');
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
      //return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
      return HomeListModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to getHomeList, error == ${response.reasonPhrase}, , url == $uri');
    }
  }

  static Future<bool> postFavCreate(String tweetId) async {
    print('tweetId == $tweetId');
    String requestUrl = "/1.1/favorites/create.json";
    int timeStampValue = (new DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    String timeStamp = timeStampValue.toString();
    String oauthNonce = 'NDMyNTk4NzM0MjUwOTgzNDc1ODM5ODU3NjQ3NTY4MzK';
    // 认证参数：用于构建签名base
    String authParams = 'oauth_consumer_key=$apiKey&'
        'oauth_nonce=$oauthNonce&'
        'oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timeStamp&'
        'oauth_token=$accessToken&'
        'oauth_version=1.0&id=$tweetId';
    // 签名base：请求方式&url&认证参数
    String baseString = Uri.encodeComponent('POST') +
        '&' +
        Uri.encodeComponent('https://api.twitter.com' + requestUrl) +
        '&' +
        Uri.encodeComponent(authParams);
    print('baseString == $baseString');
    // 签名密钥
    String signingKey = '$apiSecretKey&$accessTokenSecret';
    // 签名
    var hMac = Hmac(sha1, signingKey.codeUnits);
    String signResult = Uri.encodeComponent(
        base64Encode(hMac.convert(baseString.codeUnits).bytes));
    // 认证信息，请求头带到后端
    String authInfo = 'OAuth oauth_consumer_key="$apiKey", '
        'oauth_nonce="$oauthNonce", '
        'oauth_signature=$signResult, '
        'oauth_signature_method="HMAC-SHA1", '
        'oauth_timestamp="$timeStamp", '
        'oauth_token="$accessToken", '
        'oauth_version="1.0"';
    print('authInfo == $authInfo');
    Uri uri = Uri.https(BASE_DOMAIN, requestUrl, {'id': tweetId});
    var response = await post(uri, headers: {'Authorization': authInfo});
    print('response.statusCode == ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

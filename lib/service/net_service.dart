import 'dart:convert';

import 'package:tuite/model/home_list_model.dart';

// dart文件可以不取类名只写方法，由调用方自定义类名
import 'package:http/http.dart' as httpPlugin;
import 'home_timeline_data.dart' as homeTimeLineData;

const BASE_DOMAIN = 'api.twitter.com';
const HOME_TIMELINE_URL = "/1.1/statuses/home_timeline.json";

class NetService {
  /// Future表示未来的一个返回值，即await延迟执行的结果；
  ///
  /// async表示函数是一个异步函数，返回值为Future类型，Dart规定有async标记的函数，
  /// 只能由await来调用，例如：String data = await getData()；
  ///
  /// 在Dart中，有await标记的运算，其结果值都是一个Future对象，要使用await，
  /// 必须在有async标记的函数中运行，否则这个await会报错
  static Future<HomeListModel> getHomeList(int pageIndex, String userName) async {
    // map是可选参数
    /*var uri =
        Uri.https(BASE_DOMAIN, HOME_TIMELINE_URL, {'screen_name': userName});
    var response = await httpPlugin.get(uri);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
    } else {
      throw Exception('Failed to getHomeList');
    }*/

    return HomeListModel.fromJson(homeTimeLineData.homeTimeLineList);
  }
}

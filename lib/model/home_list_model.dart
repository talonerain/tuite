import 'home_item_model.dart';

class HomeListModel {
  final List<HomeItemModel> homeListModel;

  HomeListModel(this.homeListModel);

  factory HomeListModel.fromJson(List homeListJson) {
    List<HomeItemModel> homeList =
        homeListJson.map((e) => HomeItemModel.fromJson(e)).toList();
    return HomeListModel(homeList);
  }
}

class ContentTextModel {
  String text;
  // 是否是可点击的话题
  bool isSubject;

  ContentTextModel(text, {isSubject = false}) {
    this.text = text;
    this.isSubject = isSubject;
  }
}

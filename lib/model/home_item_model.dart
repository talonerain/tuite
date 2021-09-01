class HomeItemModel {
  final String createdTime;
  final int id;
  final String idStr;
  final String text;
  final bool truncated;

  // 图片信息
  final Entity entities;

  // 视频信息，先判断extendedEntities中的media数组，expanded_url不为空则播放视频。
  // 此时media_url_https为封面图片
  final Entity extendedEntities;
  final String source;
  final int inReplyToStatusId;
  final String inReplyToStatusIdStr;
  final int inReplyToUserId;
  final String inReplyToUserIdStr;
  final String inReplyToScreenName;
  final User user;
  final bool isQuoteStatus;
  final int retweetCount;
  final int favoriteCount;

  // 是否已喜欢
  final bool favorited;

  // 是否已转发
  final bool retweeted;
  final bool possiblySensitive;
  final bool possiblySensitiveAppealable;
  final String lang;

  HomeItemModel(
      {this.createdTime,
      this.id,
      this.idStr,
      this.text,
      this.truncated,
      this.source,
      this.entities,
      this.extendedEntities,
      this.inReplyToStatusId,
      this.inReplyToStatusIdStr,
      this.inReplyToUserId,
      this.inReplyToUserIdStr,
      this.inReplyToScreenName,
      this.user,
      this.isQuoteStatus,
      this.retweetCount,
      this.favoriteCount,
      this.favorited,
      this.retweeted,
      this.possiblySensitive,
      this.possiblySensitiveAppealable,
      this.lang});

  factory HomeItemModel.fromJson(Map<String, dynamic> json) {
    return HomeItemModel(
        user: User.fromJson(json['user']),
        createdTime: json['created_at'],
        id: json['id'],
        idStr: json['id_str'],
        text: json['full_text'],
        truncated: json['truncated'],
        source: json['source'],
        inReplyToStatusId: json['in_reply_to_status_id'],
        inReplyToStatusIdStr: json['in_reply_to_status_id_str'],
        inReplyToUserId: json['in_reply_to_user_id'],
        inReplyToUserIdStr: json['in_reply_to_user_id_str'],
        inReplyToScreenName: json['in_reply_to_screen_name'],
        isQuoteStatus: json['is_quote_status'],
        retweetCount: json['retweet_count'],
        favoriteCount: json['favorite_count'],
        favorited: json['favorited'],
        retweeted: json['retweeted'],
        possiblySensitive: json['possibly_sensitive'],
        possiblySensitiveAppealable: json['possibly_sensitive_appealable'],
        lang: json['lang'],
        entities: Entity.fromJson(
          json['entities'],
        ),
        extendedEntities: Entity.fromJson(json['extended_entities']));
  }

  String get content {
    String result = text;
    if (text.contains('https')) {
      result = text.substring(0, text.indexOf('https'));
      result = result.trim();
    }
    return result;
  }
}

class User {
  final int id;
  final String idStr;
  final String name;
  final String screenName;
  final String location;
  final String description;
  final String url;

  //final Entities entities;
  final bool protected;
  final int followersCount;
  final int friendsCount;
  final int listedCount;
  final String createAt;
  final int favouritesCount;
  final bool geoEnabled;
  final bool verified;
  final String profileBackgroundColor;
  final String profileBackgroundImageUrl;
  final String profileBackgroundImageUrlHttps;
  final bool profileBackgroundTitle;
  final String profileImageUrl; //用户头像
  final String profileImageUrlHttps;
  final String profileBannerUrl;
  final String profileLinkColor;
  final String profileSidebarBorderColor;
  final String profileSidebarFillColor;
  final String profileTextColor;
  final bool profileUseBackgroundImage;
  final bool hasExtendedProfile;
  final bool defaultProfile;
  final bool defaultProfileImage;

  // 是否关注
  final bool following;
  final bool followRequestSent;
  final bool notifications;
  final String translatorType;

  User(
      {this.id,
      this.idStr,
      this.name,
      this.screenName,
      this.location,
      this.description,
      this.url,
      this.protected,
      this.followersCount,
      this.friendsCount,
      this.listedCount,
      this.createAt,
      this.favouritesCount,
      this.geoEnabled,
      this.verified,
      this.profileBackgroundColor,
      this.profileBackgroundImageUrl,
      this.profileBackgroundImageUrlHttps,
      this.profileBackgroundTitle,
      this.profileImageUrl,
      this.profileImageUrlHttps,
      this.profileBannerUrl,
      this.profileLinkColor,
      this.profileSidebarBorderColor,
      this.profileSidebarFillColor,
      this.profileTextColor,
      this.profileUseBackgroundImage,
      this.hasExtendedProfile,
      this.defaultProfile,
      this.defaultProfileImage,
      this.following,
      this.followRequestSent,
      this.notifications,
      this.translatorType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      idStr: json['id_str'],
      screenName: json['screen_name'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      url: json['url'],
      protected: json['protected'],
      followersCount: json['followers_count'],
      friendsCount: json['friends_count'],
      listedCount: json['listed_count'],
      createAt: json['created_at'],
      favouritesCount: json['favourites_count'],
      geoEnabled: json['geo_enabled'],
      verified: json['verified'],
      profileBackgroundColor: json['profile_background_color'],
      profileBackgroundImageUrl: json['profile_background_image_url'],
      profileBackgroundImageUrlHttps:
          json['profile_background_image_url_https'],
      profileBackgroundTitle: json['profile_background_tile'],
      profileImageUrlHttps: json['profile_image_url_https'],
      profileBannerUrl: json['profile_banner_url'],
      profileImageUrl: json['profile_image_url'],
      profileLinkColor: json['profile_link_color'],
      profileSidebarBorderColor: json['profile_sidebar_border_color'],
      profileSidebarFillColor: json['profile_sidebar_fill_color'],
      profileTextColor: json['profile_text_color'],
      profileUseBackgroundImage: json['profile_use_background_image'],
      hasExtendedProfile: json['has_extended_profile'],
      defaultProfile: json['default_profile'],
      following: json['following'],
      followRequestSent: json['follow_request_sent'],
      notifications: json['notifications'],
      translatorType: json['translator_type'],
    );
  }
}

class Entity {
  List<Media> _media;

  Entity(this._media);

  factory Entity.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    List<Media> mediaList;
    if (json['media'] != null) {
      print(json['media']);
      // map是List的方法，as的作用是将json['media']转换为List使用
      var mediaJson = json['media'] as List;
      mediaList = mediaJson.map((e) => Media.fromJson(e)).toList();
    }
    return Entity(mediaList);
  }

  List<Media> getMediaList() {
    return _media ?? [];
  }
}

class Media {
  int id;

  // 图片地址
  String mediaUrl;
  String mediaUrlHttps;

  // 视频地址（推测，未验证）
  String expandedUrl;

  Media({this.id, this.mediaUrl, this.mediaUrlHttps, this.expandedUrl});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
        id: json['id'],
        mediaUrl: json['media_url'],
        mediaUrlHttps: json['media_url_https'],
        expandedUrl: json['expanded_url']);
  }
}

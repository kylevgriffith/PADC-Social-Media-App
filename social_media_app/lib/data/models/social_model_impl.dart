import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Zaw Htet Naing",
      postImage: "",
      description: description,
      profilePicture:
          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    );
    return mDataAgent.addNewPost(newPost);
  }
}

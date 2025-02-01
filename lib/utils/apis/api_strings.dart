class ApiStrings {
  static const String serverURl = 'http://16.171.146.189:8001/';
  // static const String serverURl = 'https://9a67-110-39-187-178.ngrok-free.app/';

  static const String baseURl = serverURl + 'api/v1/';
  static const String socket = serverURl;
  static const String terms = serverURl + 'terms';
  static const String privacy = serverURl + 'privacy-policy';
  static const String mediaURl = 'https://d1pi76jwqujuc3.cloudfront.net/';

  static const String gifKey = 'Fwqcj9yGBZV20kAZbxvmBUOhouhBhuGq';
  static const String headerKey = 'Authorization';
  static const String headerValue = 'AVISEaZFcaISZMHGrpEjxpQj3bzK57202gNuPETS';

  //feedV1
  static const String postfeed = 'post-feed';
  static const String likefeed = 'like-feed';
  static const String favfeed = 'fav-feed';
  static const String feedComment = 'feed-comment';
  static const String reportfeed = 'report-feed';
  static const String likefeedComment = 'like-feed-comment';
  static const String events = baseURl +'events/pets';
  static const String feeds = 'feeds';
  static const String feed = 'feed';
  static const String feedComments = 'feed-comments';
  static const String feedLikes = 'feed-likes';
  static const String deleteFeed = 'delete-feed';
  static const String deleteFeedComment = 'delete-feed-comment';

  //feedV2
  static const String postfeedV2 = 'post-feedV2';
  static const String feedsV2 = 'feedsV2';
  static const String feedV2 = 'feedV2';
  static const String createPost = 'post';
  static const String getAllFeed = 'user/get-all-feed';

  // POST METHODS
  static const String signup = 'auth/signup';
  static const String emailOtp = 'request-email-otp';
  static const String resendOTP = 'auth/resend-otp';
  static const String addAnimal = 'animal/add-animal';
  static const String updateAnimal = 'animal/update-animal';
  static const String login = 'auth/login';
  static const String verifyOtp = 'auth/verify';
  static const String forgotPasswordOtp = 'auth/verify-forgot-password';
  static const String socialLogin = 'auth/social-login';
  static const String forgotPassword = 'auth/forgot-password';
  static const String logout = 'logout';
  static const String chats = 'chats';
  static const String contactUs = 'contact-us';
  static const String followUnfollowUser = 'follow-unfollow-user';
  static const String upload = 'upload';
  static const String uploadImage = 'upload-image';
  static const String postChatImage = upload + '/post-chat-image';
  static const String readNotification = 'read_notification';
  static const String clearConversation = 'clear-conversation';
  static const String blockUnblockUser = 'block-unblock-user';
  static const String deleteChat = 'delete-chat';
  static const String addForumTopic = 'add-forum-topic';
  static const String replyForumTopic = 'reply-forum-topic';
  static const String replyForumTopicReply = 'edit-forum-topic-reply';
  static const String likeForumReply = 'like-forum-reply';
  static const String enableDisableForumNotification =
      'enable-disable-forum-notification';

  // PUT METHODS
  static const String changePassword = 'change-password';
  static const String resetPassword = 'auth/reset-password';

  static const String updateProfile = 'update-profile';
  static const String updateProfilePicture = 'update-profile-picture';

  //GET METHODS
  static const String global = 'global-settings';
  static const String profile = 'profile';
  static const String gamification = 'gamification-badges';
  static const String pointHistory = 'point-history';
  static const String ranking = 'leaderboards';
  static const String myAnimals = 'animal/get-all-animal';
  static const String myAnimalsNew = 'animal/get-animals-by-user';
  static const String animalById = 'animal/get-animal';

  static const String departments = 'departments';
  static const String faqs = 'faqs';
  static const String criterias = 'faqs';
  static const String categories = 'categories';
  static const String product_brands = 'product-brands';
  static const String subCategories = 'sub-categories';
  static const String followersFollowing = 'followers-following';
  static const String allUsers = 'users';
  static const String allUsersDiscussion = 'user';
  static const String groups = 'groups';
  static const String messages = 'messages';
  static const String individual = 'individual';
  static const String group = 'group';
  static const String userAllChats = chats + '/user-all-chats';
  static const String userIndividualMessages = chats + '/user-individual-messages';
  static const String userGroupChats = chats + '/user-groups';
  static const String fetchOnlineStores = 'location/fetch-online-stores';
  static const String groupMessages = chats + '/$groups';
  static const String notifications = 'notifications';
  static const String getFollowingUsers = 'user/get-following-user';
  static const String getFollowerUsers = 'user/get-follower-user';
  static const String followUser = 'user/follow';
  static const String suggestedFriends = 'suggested-friends';
  static const String forums = 'forums';
  static const String forumTopics = 'forum-topics';
  static const String forumTopicReplies = 'forum-topic-replies';
  static const String myForumReplies = 'my-forum-replies';
  static const String forumCategories = 'forum-categories';
  static const String dogBreeds = 'breeds/dog-breeds';
  static const String catBreeds = 'breeds/cat-breeds';
  static const String getAllCategories = 'category';
  static const String review = 'review/';
  static const String getPostReviewsById = review + 'get-post-reviews-by-id/';
  static const String getPostReviewsByPostId = review + 'get-post-reviews-by-postId/';

  //DELETE
  static const String deleteAccount = 'delete-account';
  static const String deactivateAccount = 'deactivate-account';
  static const String deleteAnimal = 'animal/delete-animal';
  static const String removeFollowing = 'remove-following';
  static const String deleteForumReply = 'delete-forum-reply';
  static const String deleteForumTopic = 'delete-forum-topic';

  //Location

  static const String getLocationByNameAndAddress =
      'location/fetch-by-name-or-address';
}

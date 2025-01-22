import 'package:avispets/splash_screen.dart';
import 'package:avispets/ui/boarding_screens/onboarding.dart';
import 'package:avispets/ui/login_signup/forget_password_otp.dart';
import 'package:avispets/ui/login_signup/forgot_password.dart';
import 'package:avispets/ui/login_signup/login_screen.dart';
import 'package:avispets/ui/login_signup/new_password.dart';
import 'package:avispets/ui/login_signup/otp_screen.dart';
import 'package:avispets/ui/login_signup/select_animal.dart';
import 'package:avispets/ui/login_signup/signup_screen.dart';
import 'package:avispets/ui/main_screen/addPost/add_post.dart';
import 'package:avispets/ui/main_screen/addPost/add_post_details.dart';
import 'package:avispets/ui/main_screen/chats/all_messages.dart';
import 'package:avispets/ui/main_screen/chats/chat_screen.dart';
import 'package:avispets/ui/main_screen/chats/create_group.dart';
import 'package:avispets/ui/main_screen/chats/create_group2.dart';
import 'package:avispets/ui/main_screen/chats/group_info.dart';
import 'package:avispets/ui/main_screen/chats/review.dart';
import 'package:avispets/ui/main_screen/filter_reviews.dart';
import 'package:avispets/ui/main_screen/filter_screen.dart';
import 'package:avispets/ui/main_screen/friends/friends_screen.dart';
import 'package:avispets/ui/main_screen/home/comment_screen.dart';
import 'package:avispets/ui/main_screen/home/create_post.dart';
import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/ui/main_screen/home/reply_screen.dart';
import 'package:avispets/ui/main_screen/main_page.dart';
import 'package:avispets/ui/main_screen/map/map_page.dart';
import 'package:avispets/ui/main_screen/notification/animal_breeds.dart';
import 'package:avispets/ui/main_screen/notification/create_animal.dart';
import 'package:avispets/ui/main_screen/notification/edit_animal.dart';
import 'package:avispets/ui/main_screen/notification/my_animals.dart';
import 'package:avispets/ui/main_screen/notification/notification_screen.dart';
import 'package:avispets/ui/main_screen/profile/badges.dart';
import 'package:avispets/ui/main_screen/profile/change_password.dart';
import 'package:avispets/ui/main_screen/profile/contact_us.dart';
import 'package:avispets/ui/main_screen/profile/edit_profile.dart';
import 'package:avispets/ui/main_screen/profile/faqs.dart';
import 'package:avispets/ui/main_screen/profile/followers.dart';
import 'package:avispets/ui/main_screen/profile/game_info.dart';
import 'package:avispets/ui/main_screen/profile/my_profile.dart';
import 'package:avispets/ui/main_screen/profile/policy.dart';
import 'package:avispets/ui/main_screen/profile/ranking.dart';
import 'package:avispets/ui/main_screen/profile/statistics.dart';
import 'package:avispets/ui/main_screen/profile/terms_cond.dart';
import 'package:avispets/ui/main_screen/reviews/add_review.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/thanks.dart';
import 'package:flutter/material.dart';
import '../../models/follower_following_model.dart';
import '../../ui/main_screen/chats/forums/create_forum.dart';
import '../../ui/main_screen/chats/forums/forum_question.dart';
import '../../ui/main_screen/chats/forums/forum_reply.dart';
import '../../ui/main_screen/chats/forums/forums.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreen());

      case RoutesName.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.signupScreen:
        Map<String, dynamic> value = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                SignupScreen(languageFormat: value));

      case RoutesName.otpScreen:
        Map<String, String> value = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
            builder: (BuildContext context) => OtpScreen(data: value));

      case RoutesName.forgetPasswordOtpScreen:
        Map<String, String> value = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ForgetPasswordOtpScreen(data: value));

      case RoutesName.forgotPassword:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgotPassword());

      case RoutesName.thanks:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Thanks());

      case RoutesName.addReview:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AddReview());

      case RoutesName.selectAnimal:
        Map<String, dynamic> mapData =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => SelectAnimal(mapData: mapData));

      case RoutesName.mainPage:
        var values = int.parse(settings.arguments.toString());
        return MaterialPageRoute(
            builder: (BuildContext context) => MainPage(index: values));

      case RoutesName.editProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EditProfile());
      case RoutesName.changePassword:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ChangePassword());
      case RoutesName.newPassword:
        Map<String, String> value = settings.arguments as Map<String, String>;

        return MaterialPageRoute(
            builder: (BuildContext context) => NewPassword(data: value));
      case RoutesName.contactUs:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ContactUs());
      case RoutesName.notification:
        // 0 : main bottomSheet , 1 : profile page
        int value = int.parse(settings.arguments.toString());
        return MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen(from: value));
      case RoutesName.myAnimal:
        int value = int.parse(settings.arguments.toString());
        return MaterialPageRoute(
            builder: (BuildContext context) => MyAnimals(from: value));

      case RoutesName.friends:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FriendsScreen());
      case RoutesName.createAnimal:
        print('APP-ROUTE(CREATE_ANIMAL) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateAnimal(mapData: mapData));
      case RoutesName.messagesScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MessagesScreen());
      case RoutesName.chatScreen:
        print('APP-ROUTE(CHAT_SCREEN) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(mapData: mapData));

      case RoutesName.reviewScreen:
        print('APP-ROUTE(CHAT_SCREEN) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => Review(mapData: mapData));

      case RoutesName.createGroup:
        print('APP-ROUTE(CHAT_SCREEN) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateGroup(mapData: mapData));

      case RoutesName.createGroup2:
        List<FollowingFollowerBody> mapData =
            settings.arguments as List<FollowingFollowerBody>;
        print('APP-ROUTE(CREATE-GROUP 2) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateGroup2(mapData: mapData));

      case RoutesName.editAnimal:
        print('APP-ROUTE(EDIT_ANIMAL) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => EditAnimal(mapData: mapData));

      case RoutesName.animalBreed:
        print('APP-ROUTE(EDIT_ANIMAL) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => AnimalBreeds(mapData: mapData));

      case RoutesName.faqs:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Faqs());
      case RoutesName.terms:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Terms());
      case RoutesName.privacy:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Privacy());
      case RoutesName.map:
        return MaterialPageRoute(
            builder: (BuildContext context) => MapScreen());

      case RoutesName.myProfile:
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print(
            'APP-ROUTE(MY_PROFILE_ANIMAL) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => MyProfile(mapData: mapData));

      case RoutesName.forum:
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print(
            'APP-ROUTE(MY_PROFILE_ANIMAL) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => Forums(mapData: mapData));

      case RoutesName.statistics:
        return MaterialPageRoute(
            builder: (BuildContext context) => Statistics());

      case RoutesName.ranking:
        return MaterialPageRoute(builder: (BuildContext context) => Ranking());

      case RoutesName.badges:
        return MaterialPageRoute(builder: (BuildContext context) => Badges());
      case RoutesName.forumQuestion:
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print(
            'APP-ROUTE(MY_PROFILE_ANIMAL) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => ForumQuestion(mapData: mapData));

      case RoutesName.forumReply:
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print(
            'APP-ROUTE(MY_PROFILE_ANIMAL) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => ForumReply(mapData: mapData));

      case RoutesName.createForum:
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print(
            'APP-ROUTE(MY_PROFILE_ANIMAL) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateForum(mapData: mapData));

      //////////////////////////////////////////////////////////////////////////////////
      case RoutesName.addPostScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => AddPostScreen());
      case RoutesName.postDetail:
        print('APP-ROUTE(POST_DETAILS) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => PostDetail(mapData: mapData));
      case RoutesName.filterScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FiltersScreen());
      case RoutesName.filterReviews:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FilterReviews());
      case RoutesName.addPostDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AddPostDetails());
      case RoutesName.replyScreen:
        print('APP-ROUTE(CREATE_ANIMAL) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => ReplyScreen(mapData: mapData));

      //////////////////////////////////////////////////////////////////////////////////////
      /* case RoutesName.follower:
        int value = int.parse(settings.arguments.toString());
        return MaterialPageRoute(
            builder: (BuildContext context) => Followers(tab : value));
         case RoutesName.commentScreen:
        print('APP-ROUTE(CREATE_ANIMAL) ::  ${settings.arguments.toString()}');
        Map<String,dynamic>? mapData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (BuildContext context) => CommentScreen(mapData : mapData));
            case RoutesName.GroupInfoScreen:
        print('APP-ROUTE(CHAT_SCREEN) ::  ${settings.arguments.toString()}');
        Map<String, dynamic>? mapData =
            settings.arguments as Map<String, dynamic>?;
        print('APP-ROUTE(CREATE-GROUP 2) ::  ${settings.arguments.toString()}');
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                GroupInfoScreen(mapData: mapData));
             case RoutesName.gameInfo:
        return MaterialPageRoute(builder: (BuildContext context) => GameInfo());


            */
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Thanks());
    }
  }
}

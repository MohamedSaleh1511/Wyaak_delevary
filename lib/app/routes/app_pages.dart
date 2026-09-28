import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:wayaak_delivery/app/modules/auth/pages/reset_password.dart';
import 'package:wayaak_delivery/app/modules/home/bindings/guest_binding.dart';
import 'package:wayaak_delivery/app/modules/home/views/guest_view.dart';
import 'package:wayaak_delivery/app/modules/order_details/bindings/order_details_binding.dart';
import 'package:wayaak_delivery/app/modules/order_details/views/goodealz_details_view.dart';
import 'package:wayaak_delivery/app/modules/order_details/views/order_details_view.dart';
import 'package:wayaak_delivery/app/modules/orders_history/bindings/orders_history_binding.dart';
import 'package:wayaak_delivery/app/modules/orders_history/views/orders_history_view.dart';
import 'package:wayaak_delivery/app/modules/profile/views/change_pass.dart';
import 'package:wayaak_delivery/app/modules/requests/views/waiting_view.dart';
import 'package:wayaak_delivery/app/modules/static_pages/bindings/static_pages_binding.dart';
import 'package:wayaak_delivery/app/modules/static_pages/pages/about_us_page.dart';
import 'package:wayaak_delivery/app/modules/static_pages/pages/privacy_policy_page.dart';
import 'package:wayaak_delivery/app/modules/static_pages/pages/terms_conditions_page.dart';
import 'package:wayaak_delivery/app/modules/support/views/add_ticket_view.dart';
import 'package:wayaak_delivery/app/modules/support/views/faqs_view.dart';
import 'package:wayaak_delivery/app/modules/support/views/ticket_chat_view.dart';
import 'package:wayaak_delivery/app/modules/support/views/tickets_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/pages/forget_pass.dart';
import '../modules/auth/pages/login.dart';
import '../modules/auth/pages/otp_code.dart';
import '../modules/auth/pages/select_your_location.dart';
import '../modules/auth/pages/signup.dart';
import '../modules/auth/pages/upload_pages/upload_car_photo_view.dart';
import '../modules/auth/pages/upload_pages/upload_license_back_view.dart';
import '../modules/auth/pages/upload_pages/upload_license_front_view.dart';
import '../modules/auth/pages/upload_pages/upload_user_photo_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_messages_view.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/new_requests_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profits/bindings/profits_binding.dart';
import '../modules/profits/views/profits_view.dart';
import '../modules/requests/bindings/requests_binding.dart';
import '../modules/reviews/bindings/reviews_binding.dart';
import '../modules/reviews/views/reviews_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/view/splash_page.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.setLocation,
      page: () => const SelectYourLocation(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.uploadUserImage,
      page: () => const UploadUserImageView(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.uploadCarImage,
      page: () => const UploadCarImageView(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.uploadLicenseFront,
      page: () => const UploadLicenseView(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.uploadLicenseBack,
      page: () => const UploadLicenseBackView(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.forgetPass,
      page: () => const ForgetPassPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.resetPass,
      page: () => const ResetPassword(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.otpCode,
      page: () => const OtpCodePage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.main,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        StaticPagesBinding(),
        SupportBinding(),
        RequestsBinding(),
        OrderDetailsBinding(),
        ChatBinding(),
      ],
    ),
    GetPage(
      name: Routes.newRequests,
      page: () => const NewRequestsView(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.chatMessages,
      page: () => const ChatMessagesView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      bindings: [
        AuthBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: Routes.changePass,
      page: () => const ChangesPassword(),
      bindings: [
        AuthBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: Routes.ordersHistory,
      page: () => const OrdersHistoryView(),
      bindings: [
        OrdersHistoryBinding(),
      ],
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      bindings: [
        NotificationBinding(),
        OrderDetailsBinding(),
        HomeBinding(),
        SupportBinding(),
      ],
    ),
    GetPage(
      name: Routes.reviews,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: Routes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.profits,
      page: () => const ProfitsView(),
      binding: ProfitsBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfitsBinding(),
    ),
    GetPage(
      name: Routes.orderDetails,
      page: () => const OrderDetailsView(),
      bindings: [OrderDetailsBinding(), ChatBinding()],
    ),
    GetPage(
      name: Routes.goodealzDetails,
      page: () => const GoodealzDetailsView(),
      bindings: [OrderDetailsBinding(), ChatBinding()],
    ),
    GetPage(
      name: Routes.ticketChat,
      page: () => const TicketChatView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutUsPage(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.terms,
      page: () => const TermsAndConditions(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.privacy,
      page: () => const PrivacyPolicy(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.addTicket,
      page: () => const AddTicketView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.tickets,
      page: () => const TicketsView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.faq,
      page: () => const FaqsView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.waiting,
      page: () => const WaitingView(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: Routes.guest,
      page: () => const GuestView(),
      binding: GuestBinding(),
    ),
  ];
}

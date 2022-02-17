import 'package:devkitflutter/ui/feature/app_theme/app_theme_list.dart';
import 'package:devkitflutter/ui/feature/auto_complete/auto_complete_list.dart';
import 'package:devkitflutter/ui/feature/banner_slider/banner_slider_list.dart';
import 'package:devkitflutter/ui/feature/barcode_scanner/barcode_scanner_list.dart';
import 'package:devkitflutter/ui/feature/bottom_navigation/bottom_navigation_list.dart';
import 'package:devkitflutter/ui/feature/bottom_sheet/bottom_sheet_list.dart';
import 'package:devkitflutter/ui/feature/category_menu/category_menu_list.dart';
import 'package:devkitflutter/ui/feature/custom_icon/custom_icon.dart';
import 'package:devkitflutter/ui/feature/interactive_chat/chat_list.dart';
import 'package:devkitflutter/ui/feature/interactive_chip/interactive_chip_list.dart';
import 'package:devkitflutter/ui/feature/multi_language/multi_language_list.dart';
import 'package:devkitflutter/ui/feature/page_route_animation/page_route_animation_list.dart';
import 'package:devkitflutter/ui/feature/pick_crop_image/pick_crop_image.dart';
import 'package:devkitflutter/ui/feature/press_back_2_times/press_back_2_times.dart';
import 'package:devkitflutter/ui/feature/rating/rating_list.dart';
import 'package:devkitflutter/ui/feature/shimmer_loading/dart/shimmer_loading_list.dart';
import 'package:devkitflutter/ui/feature/signature/signature_list.dart';
import 'package:devkitflutter/ui/feature/sliver_tab_bar/sliver_tabbar_list.dart';
import 'package:devkitflutter/ui/feature/tutorial_highlighter/tutorial_highlighter.dart';
import 'package:devkitflutter/ui/feature/url_launcher/url_launcher_list.dart';
import 'package:devkitflutter/ui/feature/webview/webview_list.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class FeatureTabPage extends StatefulWidget {
  @override
  _FeatureTabPageState createState() => _FeatureTabPageState();
}

class _FeatureTabPageState extends State<FeatureTabPage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  int number = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: ListView(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
        children: [
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.table_chart,
              title: 'Sliver Tab Bar',
              desc: 'Tab bar animation with sliver',
              page: SliverTabbarListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.invert_colors_on,
              title: 'App Theme (Light Theme / Dark Theme / Custom Theme)',
              page: AppThemeListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.keyboard_tab,
              title: 'Page Route Animation',
              desc: 'Used to animate transition when change between screen',
              page: PageRouteAnimationListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.slideshow,
              title: 'Banner Slider',
              desc: 'Image Slideshow',
              page: BannerSliderListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.call_to_action,
              title: 'Bottom Navigation',
              desc: 'Used to navigate between page using bottom navigation',
              page: BottomNavigationListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.category,
              title: 'Category Menu',
              desc: 'Used to list all category of the apps',
              page: CategoryMenuListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.open_in_browser,
              title: 'Bottom Sheet Featured',
              desc: 'Slide from bottom',
              page: BottomSheetListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.image,
              title: 'Pick & Crop Image',
              desc: 'Used to change picture',
              page: PickCropImagePage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.language,
              title: 'Multi Language',
              desc: 'Used to define more than 1 language',
              page: MultiLanguageListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.search,
              title: 'Auto Complete',
              desc: 'Auto Complete Search',
              page: AutoCompleteListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.blur_linear_sharp,
              title: 'Shimmer Loading',
              desc: 'Used to shown loading when fetching data',
              page: ShimmerLoadingListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.message,
              title: 'Interactive Chat',
              desc: 'Interactive chat used for messaging',
              page: ChatListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.launch,
              title: 'URL Launcher',
              desc: 'Launching a URL in the mobile platform (Website, Email, Phone Number, SMS)',
              page: UrlLauncherListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.web_asset,
              title: 'Webview',
              desc: 'Webview on mobile platform',
              page: WebviewListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.highlight_alt,
              title: 'Tutorial Highlighter',
              desc: 'Used to show tutorial',
              page: TutorialHighlighterPage()
          ),
          // _globalWidget.screenTabList(
          //     context: context,
          //     id: number++,
          //     icon: Icons.qr_code,
          //     title: 'Barcode Scanner',
          //     desc: 'Barcode Scanner for Normal Barcode or QR Code',
          //     page: BarcodeScannerListPage()
          // ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.edit,
              title: 'Signature',
              desc: 'Digital Signature',
              page: SignatureListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.label,
              title: 'Interactive Chip',
              desc: 'Nice interactive chip used for input, choice, filter and action',
              page: InteractiveChipListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.notifications,
              title: 'Custom Icon',
              desc: 'Custom icon with label',
              page: CustomIconPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.star,
              title: 'Rating',
              desc: 'Feature for rate / review',
              page: RatingListPage()
          ),
          _globalWidget.screenTabList(
              context: context,
              id: number++,
              icon: Icons.arrow_back,
              title: 'Press Back 2 Times',
              desc: 'Usually used to exit applications',
              page: PressBack2TimesPage()
          ),
        ],
      ),
    );
  }
}

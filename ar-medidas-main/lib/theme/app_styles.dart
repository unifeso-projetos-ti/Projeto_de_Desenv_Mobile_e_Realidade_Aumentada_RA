import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../theme/app_colors.dart';

class AppStyles {
  static TextStyle fadedText(BuildContext context) => TextStyle(
    fontFamily: 'GoogleAcme',
    fontSize: 18,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase.withAlpha((0.6 * 255).toInt())
        : AppColors.bambooBase.withAlpha((0.6 * 255).toInt()),
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'GoogleAcme',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle containerText(BuildContext context) => TextStyle(
    fontFamily: 'GoogleAcme',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase.withAlpha((0.6 * 255).toInt())
        : AppColors.bambooBase.withAlpha((0.6 * 255).toInt()),
  );

  static TextStyle listTileTitle(BuildContext context) => TextStyle(
    fontFamily: 'GoogleAcme',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase
        : AppColors.bambooBase,
  );

  static TextStyle listTileSubtitle(BuildContext context) => TextStyle(
    fontFamily: 'GoogleAcme',
    fontSize: 14,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase.withAlpha((0.6 * 255).toInt())
        : AppColors.bambooBase.withAlpha((0.6 * 255).toInt()),
  );

  static Icon arrowDownIcon(BuildContext context) => Icon(
    FeatherIcons.chevronDown,
    size: 25,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase
        : AppColors.bambooBase,
  );

  static Icon arrowUpIcon(BuildContext context) => Icon(
    FeatherIcons.chevronUp,
    size: 25,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase
        : AppColors.bambooBase,
  );

  static const Icon backIcon = Icon(FeatherIcons.arrowLeft, size: 38);
  static const Icon cancelIcon = Icon(FeatherIcons.x, size: 30);
  static const Icon cameraIcon = Icon(FeatherIcons.camera, size: 30);
  static const Icon deleteIcon = Icon(FeatherIcons.trash, size: 30);
  static const Icon deleteForeverIcon = Icon(FeatherIcons.trash2, size: 30);
  static Icon historyIcon = Icon(FeatherIcons.clock);
  static const Icon screenShotIcon = Icon(FeatherIcons.aperture, size: 36);
  static Icon straightenIcon(BuildContext context) => Icon(
    FeatherIcons.slash,
    size: 30,
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black,
  );
  static const Icon undoIcon = Icon(FeatherIcons.cornerDownLeft, size: 36);
  static Icon warningIcon(BuildContext context) => Icon(
    FeatherIcons.alertTriangle,
    size: 38,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase
        : AppColors.bambooBase,
  );
  static Icon infoIcon(BuildContext context) => Icon(
    FeatherIcons.info,
    size: 60,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.oregonBase.withAlpha((0.6 * 255).toInt())
        : AppColors.bambooBase.withAlpha((0.6 * 255).toInt()),
  );

  static const EdgeInsetsGeometry paddingBig = EdgeInsets.all(24);
  static const EdgeInsetsGeometry paddingMedium = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );
  static const EdgeInsetsGeometry paddingSmall = EdgeInsets.all(16);

  static const double spacingLarge = 24;
  static const double spacingMedium = 20;
  static const double spacingNormal = 12;

  static InputDecorationTheme inputDecoration(BuildContext context) =>
      InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.caperBase.withAlpha((0.8 * 255).toInt())
            : AppColors.caperShades[8].withAlpha((0.8 * 255).toInt()),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints.tightFor(height: 42),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      );

  static MenuStyle menu(BuildContext context) => MenuStyle(
    backgroundColor: WidgetStatePropertyAll(
      Theme.of(context).brightness == Brightness.light
          ? AppColors.caperBase.withAlpha((0.6 * 255).toInt())
          : AppColors.caperShades[8].withAlpha((0.6 * 255).toInt()),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
    ),
    maximumSize: WidgetStatePropertyAll(Size(300, double.infinity)),
    elevation: WidgetStatePropertyAll(4),
    shadowColor: WidgetStatePropertyAll(
      Theme.of(context).brightness == Brightness.light
          ? Colors.black.withAlpha((0.2 * 255).toInt())
          : Colors.white.withAlpha((0.2 * 255).toInt()),
    ),
  );

  static Widget materialCard({
    required Widget child,
    required BuildContext context,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Theme.of(context).brightness == Brightness.light
          ? Colors.black.withAlpha((0.2 * 255).toInt())
          : Colors.white.withAlpha((0.2 * 255).toInt()),
      child: child,
    );
  }

  static Widget avatar({required BuildContext context, required Widget child}) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.robinEggBase
          : AppColors.robinEggShades[8],
      child: child,
    );
  }
}

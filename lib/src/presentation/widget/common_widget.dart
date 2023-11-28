
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../styles/color_styles.dart';


InputDecoration inputDecoration(BuildContext context,
    {Widget? suffixIcon,
    Widget? prefixIcon,
    String? labelText,
    double? borderRadius,
    String? errorText,
    String? hintText}) {
  return InputDecoration(
    counterText: '',
    errorText: errorText,
    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: ColorAppStyle.greyD8, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 1.0),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}

Widget CommonButton(
    {String? buttonText,
    Function()? onTap,
    double? width,
    double? height,
    double? margin,
    Color color = Colors.deepPurpleAccent}) {
  return AppButton(
    onTap: onTap,
    height: height,
    width: width,
    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.symmetric(horizontal: margin.validate()),
    color: color,
    padding: const EdgeInsets.symmetric(vertical: 16),
    child:
        Text(buttonText.validate(), style: boldTextStyle(color: Colors.white)),
  );
}

// extension strEtx on String {
//   Widget iconImage({double? size, Color? color, BoxFit? fit}) {
//     return Image.asset(
//       this,
//       height: size ?? 24,
//       width: size ?? 24,
//       fit: fit ?? BoxFit.cover,
//       color: color ?? (gray.withOpacity(0.6)),
//       errorBuilder: (context, error, stackTrace) {
//         return Image.asset(Assets.iconIcMessage,
//             height: size ?? 24, width: size ?? 24);
//       },
//     );
//   }
// }

// Widget CommonCachedNetworkImage(
//   String? url, {
//   double? height,
//   double? width,
//   BoxFit? fit,
//   AlignmentGeometry? alignment,
//   bool usePlaceholderIfUrlEmpty = true,
//   double? radius,
//   Color? color,
// }) {
//   if (url!.validate().isEmpty) {
//     return placeHolderWidget(
//         height: height,
//         width: width,
//         fit: fit,
//         alignment: alignment,
//         radius: radius);
//   } else if (url.validate().startsWith('http')) {
//     print(url);
//     return CachedNetworkImage(
//       imageUrl: url,
//       height: height,
//       width: width,
//       fit: fit,
//       color: color,
//       alignment: alignment as Alignment? ?? Alignment.center,
//       errorWidget: (_, s, d) {
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//       placeholder: (_, s) {
//         if (!usePlaceholderIfUrlEmpty) return const SizedBox();
//         return placeHolderWidget(
//             height: height,
//             width: width,
//             fit: fit,
//             alignment: alignment,
//             radius: radius);
//       },
//     );
//   } else {
//     return Image.asset(url,
//             height: height,
//             width: width,
//             fit: fit,
//             color: color,
//             alignment: alignment ?? Alignment.center)
//         .cornerRadiusWithClipRRect(radius ?? defaultRadius);
//   }
// }

// Widget placeHolderWidget(
//     {double? height,
//     double? width,
//     BoxFit? fit,
//     AlignmentGeometry? alignment,
//     double? radius}) {
//   return Image.asset(Assets.imLogoBellsi,
//           height: height,
//           width: width,
//           fit: fit ?? BoxFit.cover,
//           alignment: alignment ?? Alignment.center)
//       .cornerRadiusWithClipRRect(radius ?? defaultRadius);
// }

Widget settingIconWidget({IconData? icon}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(color: Colors.deepPurpleAccent, shape: BoxShape.circle),
    child: Icon(icon, color: white, size: 20),
  );
}

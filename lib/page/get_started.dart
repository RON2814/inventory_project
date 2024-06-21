import 'package:flutter/material.dart';
import 'package:again_inventory_project/page/login.dart';

class CustomElevatedButton extends StatelessWidget {
  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String text;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final Alignment? alignment;
  final TextStyle? buttonTextStyle;
  final bool? isDisabled;
  final double? height;
  final double? width;

  const CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.margin,
    this.onPressed,
    this.buttonStyle,
    this.alignment,
    this.buttonTextStyle,
    this.isDisabled,
    this.height,
    this.width,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = Container(
      height: height ?? 60.0,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            Text(
              text,
              style: buttonTextStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
            if (rightIcon != null) rightIcon!,
          ],
        ),
      ),
    );

    if (alignment != null) {
      return Align(
        alignment: alignment!,
        child: buttonWidget,
      );
    } else {
      return buttonWidget;
    }
  }
}

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.maxFinite,
          padding:
              const EdgeInsets.symmetric(horizontal: 18.0, vertical: 116.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildGochisouBimiSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGochisouBimiSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        children: [
          const CustomImageView(
            imagePath: 'lib/asset/images/logo.png',
            height: 210.0,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 34.0),
          ),
          const SizedBox(height: 24.0),
          Text(
            "GOCHISOU BIMI",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Manage your Inventory!",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.red[900],
            ),
          ),
          const SizedBox(height: 174.0),
          CustomElevatedButton(
            text: "Get Started",
            onPressed: () {
              onTapGetStarted(context);
            },
            buttonStyle: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 16.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapGetStarted(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}

class CustomImageView extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final EdgeInsets? margin;

  const CustomImageView({
    Key? key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      child: Image.asset(imagePath),
    );
  }
}

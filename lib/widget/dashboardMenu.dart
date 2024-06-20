import 'package:flutter/material.dart';

class DashboardMenu extends StatelessWidget {
  final String text;
  final String imagePath;

  const DashboardMenu({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffB73030),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: () {
            // Handle onTap action if needed


          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  Image.asset(
                    imagePath,
                    width: 58,
                    height: 58,
                  ),
                  SizedBox(height: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
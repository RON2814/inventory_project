import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final Function(int) onAccountClick;
  const AccountPage({super.key, required this.onAccountClick});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void _onAccMenuClicked(int index) {
    setState(() {
      widget.onAccountClick(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('lib/asset/images/image.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Administrator',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            itemProfile('Edit Personal Details', Icons.person, 6),
            const SizedBox(height: 20),
            itemProfile('View Products', Icons.folder, 1),
            const SizedBox(height: 20),
            itemProfile('History', Icons.history, 2),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: const Color(0xFFB73030),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemProfile(String title, IconData iconData, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 180, 6, 6).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onAccMenuClicked(index),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
            ),
          ),
          leading: Icon(iconData),
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromARGB(255, 73, 73, 73)),
          tileColor: Colors.white,
        ),
      ),
    );
  }
}

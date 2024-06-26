import 'package:again_inventory_project/database/account.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function(bool) onLoginClick;
  const Login({super.key, required this.onLoginClick});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Account account = Account();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool access = false;

  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void _onLoginPressed(bool validAcc) {
    if (validAcc) {
      widget.onLoginClick(validAcc);
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      FocusScope.of(context).unfocus();
    });

    try {
      Map<String, dynamic> result = await account.login(
        _usernameController.text,
        _passwordController.text,
      );
      _onLoginPressed(result['access']);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          content: Text("${result['request']}\n\nclick anywhere to continue."),
        ),
      );
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildLoginForm(),
              ],
            ),
          ),
          if (_isLoading) _buildLoadingIndicator()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('lib/asset/images/bg.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.red.withOpacity(0.8),
            BlendMode.darken,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(
                Icons.food_bank,
                size: 48,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
              child: Text(
                'GOCHISOU BIMI',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Text(
                'Inventory',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Color(0xFFB73030),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to your account',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 30),
            _buildInputField('Username', Icons.person, _usernameController,
                false, isObscure, _togglePasswordVisibility),
            const SizedBox(height: 15),
            _buildInputField('Password', Icons.lock, _passwordController, true,
                isObscure, _togglePasswordVisibility),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB73030),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
      String label,
      IconData iconData,
      TextEditingController controller,
      bool isPwdField,
      bool isObscure,
      VoidCallback togglePasswordVisibility) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          obscureText: isPwdField ? isObscure : false,
          controller: controller,
          onSubmitted: (String value) => _login,
          decoration: InputDecoration(
            hintText: label,
            border: InputBorder.none,
            prefixIcon: Icon(
              iconData,
              color: const Color(0xFF888888),
            ),
            suffixIcon: isPwdField
                ? IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

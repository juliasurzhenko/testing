import 'package:flutter/material.dart';
import 'package:test/controllers/auth_service.dart';
import 'package:test/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image.network(
            //   'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExaTBraWhzdXd1cDZsZ2k1NHYxeTdsd3FyYzAzbTNxMnltOHdpaWk1OSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/ALqpkXs9oWtvLUTHBr/giphy.webp',
            //   // Use a specific height and width if necessary
            //   height: 300,
            //   width: 300,
            // ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixText: '+380',
                    labelText: "Enter your phone number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32))),
                validator: (value) {
                  if (value!.length != 9) return "Invalid phone number";
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print("Send button pressed");
                  if (_formKey.currentState!.validate()) {
                    print("Phone number validated: ${_phoneController.text}");
                    await AuthService.sentOtp(
                      phone: _phoneController.text,
                      errorStep: () {
                        print("Error sending OTP");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error sending OTP",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      nextStep: () {
                        print("OTP sent successfully");
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("OTP Verification"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Enter 6 digits"),
                                const SizedBox(height: 12),
                                Form(
                                  key: _formKey1,
                                  child: TextFormField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Enter your OTP",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length != 6) {
                                        return "Invalid OTP";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (_formKey1.currentState!.validate()) {
                                    AuthService.loginWithOtp(
                                            otp: _otpController.text)
                                        .then((value) {
                                      print("Login with OTP result: $value");
                                      if (value == "Success") {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              value,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                child: const Text("Submit"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black),
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

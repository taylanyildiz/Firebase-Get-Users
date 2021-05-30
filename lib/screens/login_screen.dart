import 'package:firebase_sign_api/services/fire_base_auth_service.dart';
import 'package:firebase_sign_api/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _inputReady();
  }

  @override
  void dispose() {
    _errorController.dispose();
    for (var i = 0; i < 2; i++) {
      _nodes[i].dispose();
    }
    super.dispose();
  }

  void _inputReady() {
    _errorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _errorAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _errorController,
        curve: Curves.linear,
      ),
    );
    _errorController.addListener(_errorListener);
    _formKey = GlobalKey();
    for (var i = 0; i < 2; i++) {
      _textControllers.add(TextEditingController());
      _nodes.add(FocusNode());
    }
  }

  void _errorListener() async {
    if (_errorController.status == AnimationStatus.completed) {
      await Future.delayed(Duration(seconds: 2));
      _errorController.reverse();
    }
  }

  FireBaseAuthService _service = FireBaseAuthService();

  late AnimationController _errorController;
  late Animation<double> _errorAnimation;

  final _textControllers = <TextEditingController>[];
  final _nodes = <FocusNode>[];
  final _labels = <String>['E-mail', 'Password'];
  late GlobalKey<FormState> _formKey;

  String? _email;
  String? _password;
  String? _error;

  Widget _errorWidget() {
    return AnimatedBuilder(
      animation: _errorController,
      builder: (context, child) => Positioned(
        left: 0.0,
        right: 0.0,
        child: Container(
          height: _errorAnimation.value,
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            '${_error}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    final check = _formKey.currentState!.validate();
    _email = _textControllers[0].text;
    _password = _textControllers[1].text;
    if (_email!.isNotEmpty && _password!.isEmpty) {
      _nodes[1].requestFocus();
    } else if (_email!.isEmpty && _password!.isNotEmpty) {
      _nodes[0].requestFocus();
    } else if (_email!.isEmpty && _password!.isEmpty) {
      _nodes[0].requestFocus();
    } else if (check) {
      String? error =
          await _service.registerEmailandPassword(_email!, _password!);
      if (error!.isNotEmpty) {
        _error = error;
        _errorController.forward();
      }
    }
  }

  void _googleSign() async {
    print('ok');
    await _service.googleSign();
  }

  void _facebookSign() async {
    // _service.signInWithFacebook();
  }

  void _appleSign() async {
    /// apple sign
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title!),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _errorWidget(),
            Positioned(
              top: 80.0,
              left: 20.0,
              right: 0.0,
              child: Text(
                'Welcome\nThe Cutfinger',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InputText(
              formKey: _formKey,
              textControllers: _textControllers,
              nodes: _nodes,
              labels: _labels,
            ),
            Positioned(
              bottom: 200.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  SizedBox(
                    width: size.width * .8,
                    child: AnimButton(
                      onPressed: () => print(''),
                      label: 'Login',
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: size.width * .65,
                    child: AnimButton(
                      onPressed: () => _register(),
                      label: 'Register',
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 100.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconApiButton(
                    icon: FaIcon(FontAwesomeIcons.google),
                    onPressed: () => _googleSign(),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  IconApiButton(
                    icon: FaIcon(FontAwesomeIcons.apple),
                    onPressed: () => _appleSign(),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  IconApiButton(
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    onPressed: () => _facebookSign(),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

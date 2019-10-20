import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exceptions.dart';
import '../providers/auth_provider.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Oky'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_authFormKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _authFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signUp(_formData['email'], _formData['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Este email já foi usado';
      } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'O seu email está bloqueado';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Muitos pedidos ao mesmot tempo. Tente mais tarde';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email não encontrado.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'A password introduzida não é valida.';
      } else if (error.toString().contains('USER_DISABLED')) {
        errorMessage = 'A sua conta foi desabilitada';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      var errorMessage =
          'Não foi possivel autenticar-lo. Por favor tente novamente!';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 700.0 : deviceWidth * .95;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Hero(
              tag: 'nelson',
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: _buildBackgroundGradient()),
              ),
            ),
            Positioned(
              height: 80,
              width: 80,
              top: 100,
              child: Image.asset('assets/absa.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _authFormKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              /* onPressed: () {
                          Navigator.of(context).pushNamed(
                            RegistrationPage.routeName,
                          );
                        }, */
                              onPressed: _submit,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Colors.white,
                            child: Text('Google'),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: FlatButton(
                            color: Colors.white,
                            child: Text('Microsoft'),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(Function login) {
    if (!_authFormKey.currentState.validate()) {
      return;
    }
    _authFormKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
        obscureText: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            errorStyle: TextStyle(color: Colors.white),
            labelText: 'Palavra passe',
            labelStyle:
                TextStyle(color: Colors.white.withOpacity(.75), fontSize: 16),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.white.withOpacity(.75),
            ),
            filled: true,
            fillColor: Colors.black26),
        onSaved: (String value) {
          _formData['password'] = value;
        },
        validator: (String value) {
          if (value.isEmpty || value.length <= 7) {
            return 'A sua password não é valida';
          }
          return null;
        });
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          labelText: 'Email',
          labelStyle:
              TextStyle(color: Colors.white.withOpacity(.75), fontSize: 16),
          hintText: 'Introduza um email valido',
          hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.white.withOpacity(.75),
          ),
          filled: true,
          fillColor: Colors.black26),
      onSaved: (String value) {
        _formData['email'] = value;
      },
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$")
                .hasMatch(value)) {
          return 'Verifique o email introduzido';
        }
        return null;
      },
    );
  }
/* 
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  } */

  LinearGradient _buildBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFFBE0028), const Color(0xFF2E071B)],
      tileMode: TileMode.clamp,
    );
  }
}

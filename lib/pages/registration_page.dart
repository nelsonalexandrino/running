import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/athlete.dart';
import '../utils/style.dart';
import '../providers/registration_provider.dart';
import '../widgets/custom_dialog.dart';

class RegistrationPage extends StatefulWidget {
  static String routeName = '/registration-page';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _completeNameController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _idPassportController = TextEditingController();
  final _mileageController = TextEditingController();

  List<FilterChipWidget> _choiceWidgest = [
    FilterChipWidget(
      'Masculino',
      ['Masculino', 'Feminino'],
    ),
    FilterChipWidget(
      '21 Km',
      ['21 Km', '5 Km'],
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate;

  //nome completo,
//nacionalidade,
//data de nascimento
//telefone
//Email
//N BI, PAssporte, Citizen Card
//sexo
//quilometragem 21Km ou 5km

  var _athlete = Athlete();
  var _isLoading = false;

  Future<void> _registerAthlete() async {
    if (Platform.isAndroid) {
      final bool validation = _formKey.currentState.validate();

      if (!validation) {
        return;
      }
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    _athlete = Athlete(
      name: _completeNameController.text,
      nationality: _nationalityController.text,
      birthday: DateFormat('dd/MM/yyyy').parse(_dateOfBirthController.text),
      phone: _phoneController.text,
      email: _emailController.text,
      idNumber: _idPassportController.text,
      gender: _choiceWidgest[0].option,
      mileage: _choiceWidgest[1].option,
    );

    try {
      await Provider.of<Registrations>(context).registerAthlete(_athlete);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ups'),
          content: Text('Algo inesperado aconteceu. $error'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Sucesso',
        description:
            'Acaba de submeter com sucesso os seus dados para a inscrição na 2º Maratona internacional de Maputo. A seguir receberá um email com todas as instruções. Vemo-nos na pista!',
        buttonText: 'Ok',
      ),
    );
    Navigator.of(context).pop();
  }

  var isGenderSelected = [true, false];
  var isRouteSelected = [true, false];

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: GestureDetector(
          onTap: _registerAthlete,
          child: Text(
            'Registar',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      child: CupertinoScrollbar(
        child: ListView(
          //padding: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: MediaQuery.of(context).padding.top + 56),
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            CupertinoTextField(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              controller: _completeNameController,
              prefix: Icon(CupertinoIcons.person),
              placeholder: 'Nome do completo',
              padding: EdgeInsets.all(10),
            ),
            _spacer(),
            CupertinoTextField(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              controller: _nationalityController,
              prefix: Icon(CupertinoIcons.flag),
              placeholder: 'Nacionalidade',
              padding: EdgeInsets.all(10),
            ),
            _spacer(),
            GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        child: CupertinoDatePicker(
                          onDateTimeChanged: (selectedDate) {
                            setState(() {
                              _dateOfBirthController.text =
                                  DateFormat('dd MMMM yyyy')
                                      .format(selectedDate);
                            });
                          },
                          mode: CupertinoDatePickerMode.date,
                          maximumYear: DateTime.now().year - 17,
                          maximumDate: DateTime.now().subtract(
                            Duration(days: 356 * 17),
                          ),
                          initialDateTime: DateTime.now().subtract(
                            Duration(days: 365 * 17),
                          ),
                        ),
                      );
                    });
              },
              child: AbsorbPointer(
                child: CupertinoTextField(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(.3)))),
                  controller: _dateOfBirthController,
                  prefix: Icon(CupertinoIcons.time),
                  placeholder: 'Data de nascimento',
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            _spacer(),
            CupertinoTextField(
              controller: _phoneController,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              prefix: Icon(CupertinoIcons.phone),
              placeholder: 'Telefone',
              padding: EdgeInsets.all(10),
              keyboardType: TextInputType.phone,
            ),
            _spacer(),
            CupertinoTextField(
              controller: _emailController,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              prefix: Icon(CupertinoIcons.mail),
              placeholder: 'Email',
              padding: EdgeInsets.all(10),
              keyboardType: TextInputType.emailAddress,
            ),
            _spacer(),
            CupertinoTextField(
              controller: _idPassportController,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              prefix: Icon(
                FontAwesomeIcons.idCard,
                size: 20,
              ),
              placeholder: 'Número de BI ou passporte',
              padding: EdgeInsets.all(10),
              keyboardType: TextInputType.text,
            ),
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gênero'),
                ToggleButtons(
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Masculino', style: TextStyle(fontSize: 12)),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Feminino', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isGenderSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isGenderSelected[buttonIndex] = true;
                        } else {
                          isGenderSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isGenderSelected,
                )
              ],
            ),
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Corida'),
                ToggleButtons(
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        'Meia maratona',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Familia', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isRouteSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isRouteSelected[buttonIndex] = true;
                        } else {
                          isRouteSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isRouteSelected,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox _spacer() {
    return SizedBox(
      height: 15,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registar-se'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ImageIcon(
            AssetImage('assets/absa.png'),
            size: 24,
          ),
        ),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          //color: Colors.grey[100],
          child: ListView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            children: <Widget>[
              _buildTextFormField(
                controller: _completeNameController,
                labelText: 'Nome completo',
                hintText: 'Nome que constará da lista de participantes',
                validatorMessage: 'Por favor, preencha um nome valido',
                icon: Icon(
                  Icons.person,
                  //color: Colors.white,
                ),
              ),
              _spacer(),
              _buildTextFormField(
                controller: _nationalityController,
                labelText: 'Nacionalidade',
                hintText: 'Qual é sua nacionalidade?',
                validatorMessage: 'Por favor, indique a sua nacionalidade',
                icon: Icon(
                  Icons.flag,
                  //color: Colors.white,
                ),
              ),
              _spacer(),
              _builBirthDayTextFormField(),
              _spacer(),
              _buildTextFormField(
                controller: _phoneController,
                labelText: 'Telefone',
                hintText: 'Número de telefone',
                validatorMessage: 'Por favor, indique um número de telefone',
                textInputType: TextInputType.numberWithOptions(signed: true),
                icon: Icon(
                  Icons.phone,
                  //color: Colors.white,
                ),
              ),
              _spacer(),
              _buildEmailTextField(),
              _spacer(),
              _buildTextFormField(
                controller: _idPassportController,
                labelText: 'Número do BI ou Passaporte',
                hintText: 'Preencha com o número do seu documento?',
                validatorMessage:
                    'Por favor, indique o número do seu documento de identificação',
                icon: Icon(
                  FontAwesomeIcons.idCard,
                  //color: Colors.white,
                ),
              ),
              _spacer(),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Gênero',
                        style: AbsaStyle.headingStyle2
                            .copyWith(fontSize: 15, color: Color(0xFF2d2323)),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: _choiceWidgest[0])
                ],
              ),
              _spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Percurso',
                        style: AbsaStyle.headingStyle2
                            .copyWith(fontSize: 15, color: Color(0xFF2d2323)),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: _choiceWidgest[1])
                ],
              ),
              _spacer(),
              _isLoading
                  ? SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Submeter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: _registerAthlete,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  WidgetBuilder androidBuilder;
  WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    androidBuilder = _buildAndroid;
    iosBuilder = _buildIos;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return null;
    }
  }

  /*
  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ImageIcon(
            AssetImage('assets/absa.png'),
            size: 20,
          ),
        ),
        title: Text('Registar-se'),
      ),
      body: Hero(
        tag: 'nelson',
        child: Container(
          //color: Colors.amber,
          // decoration: BoxDecoration(
          //   gradient: _buildBackgroundGradient(),
          // ),
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          _buildTextFormField(
                            controller: _completeNameController,
                            labelText: 'Nome completo',
                            hintText:
                                'Nome que constará da lista de participantes',
                            validatorMessage:
                                'Por favor, preencha um nome valido',
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildTextFormField(
                            controller: _nationalityController,
                            labelText: 'Nacionalidade',
                            hintText: 'Qual é sua nacionalidade?',
                            validatorMessage:
                                'Por favor, indique a sua nacionalidade',
                            icon: Icon(
                              Icons.flag,
                              color: Colors.white,
                            ),
                          ), terminei aqui
                          SizedBox(
                            height: 10,
                          ),
                          //data de nascimento,
                          _builBirthDayTextFormField(),
                          SizedBox(
                            height: 10,
                          ),
                          _buildTextFormField(
                            controller: _phoneController,
                            labelText: 'Telefone',
                            hintText: 'Número de telefone',
                            validatorMessage:
                                'Por favor, indique um número de telefone',
                            textInputType:
                                TextInputType.numberWithOptions(signed: true),
                            icon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildEmailTextField(),

                          SizedBox(
                            height: 10,
                          ),
                          _buildTextFormField(
                              controller: _idPassportController,
                              labelText: 'Número do BI ou Passaporte',
                              hintText:
                                  'Preencha com o número do seu documento?',
                              validatorMessage:
                                  'Por favor, indique o número do seu documento de identificação',
                              icon: Icon(
                                Icons.tag_faces,
                                color: Colors.white,
                              ),),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Gênero',
                                    style: AbsaStyle.headingStyle2.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: _choiceWidgest[0])
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Percurso',
                                    style: AbsaStyle.headingStyle2.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: _choiceWidgest[1])
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _isLoading
                              ? SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      'Submeter',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onPressed: _registerAthlete,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
  */

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      //style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Color(0xFFCC3333)),
        //border: InputBorder.none,
        labelText: 'Email',
        //labelStyle:
        //    TextStyle(color: Colors.white.withOpacity(.75), fontSize: 16),
        hintText: 'Introduza um email valido',
        hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
        //filled: true,
        //fillColor: Colors.black26,
        prefixIcon: Icon(
          Icons.email,
          //color: Colors.white,
        ),
      ),
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

  void _selectFutureDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dateOfBirthController.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    });
  }

  Widget _builBirthDayTextFormField() {
    return InkWell(
      onTap: _selectFutureDate,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateOfBirthController,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Color(0xFFCC3333)),
            //border: InputBorder.none,
            labelText: 'Data de nascimento',
            //labelStyle: TextStyle(color: Colors.white, fontSize: 16),
            hintText: 'Qual é a sua data de nascimentp',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
            //filled: true,
            //fillColor: Colors.black26,
            prefixIcon: Icon(
              Icons.date_range,
              //color: Colors.white,
            ),
          ),
          keyboardType: TextInputType.datetime,
          readOnly: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Por favor, indique a sua data de nascimento';
            }
            return null;
          },
          onSaved: (value) {
            DateFormat format = DateFormat('dd/MM/yyyy');
          },
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    TextEditingController controller,
    String labelText,
    String hintText,
    String validatorMessage,
    TextInputType textInputType = TextInputType.text,
    Widget icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      //style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Color(0xFFCC3333)),
        //border: InputBorder.none,
        labelText: labelText,
        //labelStyle: TextStyle(color: Colors.white, fontSize: 16),
        hintText: hintText,
        prefixIcon: icon,
        //hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
        //filled: true,
        //fillColor: Colors.black26,
      ),
      onSaved: (String value) {},
      validator: (String value) {
        if (value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  LinearGradient _buildBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFFBE0028), const Color(0xFF2E071B)],
      tileMode: TileMode.clamp,
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  String option;
  List<String> _options = [];

  FilterChipWidget(this.option, this._options);
  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List<Widget>.generate(
        2,
        (int index) {
          return ChoiceChip(
            padding: EdgeInsets.all(7),
            selectedColor: Theme.of(context).primaryColor,
            label: Text(
              widget._options[index],
              style: TextStyle(color: Colors.grey),
            ),
            labelStyle: TextStyle(color: Colors.white),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                if (index == 0) {
                  widget.option = widget._options[0];
                  print(widget._options[0]);
                } else if (index == 1) {
                  widget.option = widget._options[1];
                  print(widget._options[1]);
                }
                _value = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }
}

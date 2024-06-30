import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const CovidForm());
}

class CovidForm extends StatelessWidget {
  const CovidForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstname;
  String? lastname;
  int? age;

  String? selectedGender;

  bool _isOption1 = false;
  bool _isOption2 = false;
  bool _isOption3 = false;

  List<String> selectedOptions = [];

  void _onRadioButtonChange(String? value) {
    setState(() {
      selectedGender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text('First-name'),
                  TextFormField(
                    onSaved: (value) => setState(() {
                      firstname = value;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const Text('Last-name'),
                  TextFormField(
                    onSaved: (value) => setState(() {
                      lastname = value;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const Text('Age'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) => setState(() {
                      age = value != null ? int.tryParse(value) : null;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const Text('Gender'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Male'),
                      Radio<String>(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (value) => _onRadioButtonChange(value),
                      ),
                      const Text('Female'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (value) => _onRadioButtonChange(value),
                      ),
                    ],
                  ),
                  const Text('Symptoms'),
                  Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('ไอ'),
                        value: _isOption1,
                        onChanged: (val) {
                          setState(() {
                            _isOption1 = !_isOption1;
                            if (_isOption1) {
                              selectedOptions.add('ไอ');
                            } else {
                              selectedOptions.remove('ไอ');
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('เจ็บคอ'),
                        value: _isOption2,
                        onChanged: (val) {
                          setState(() {
                            _isOption2 = !_isOption2;
                            if (_isOption2) {
                              selectedOptions.add('เจ็บคอ');
                            } else {
                              selectedOptions.remove('เจ็บคอ');
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('มีไข้'),
                        value: _isOption3,
                        onChanged: (val) {
                          setState(() {
                            _isOption3 = !_isOption3;
                            if (_isOption3) {
                              selectedOptions.add('มีไข้');
                            } else {
                              selectedOptions.remove('มีไข้');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Page1(
                              firstname: firstname!,
                              lastname: lastname!,
                              age: age!,
                              gender: selectedGender!,
                              symptoms: selectedOptions,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
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

class Page1 extends StatelessWidget {
  const Page1({
    Key? key, // เพิ่มพารามิเตอร์ key ที่นี่
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.gender,
    required this.symptoms,
  }) : super(key: key); // ส่ง key ไปยัง super constructor

  final String firstname;
  final String lastname;
  final int age;
  final String gender;
  final List<String> symptoms;

  final String description = 'Hello World';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_v1.png',
              key: const Key('covid-image-tag'),
              width: 300,
              height: 300,
            ),
            covidDetect(symptoms),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Page2(
              description: description,
            ),
          ),
        ),
        child: const Text('confirm'),
      ),
    );
  }

  Widget covidDetect(List<String> symptoms) {
    if (symptoms.length == 3) {
      return SizedBox(
        width: 300,
        height: 300,
        child: Center(
          child: Text('คุณ $firstname $lastname, อายุ $age ปี : เป็นโควิด'),
        ),
      );
    } else {
      return SizedBox(
        width: 300,
        height: 300,
        child: Center(
          child: Text('คุณ $firstname $lastname, อายุ $age ปี : ไม่เป็นโควิด'),
        ),
      );
    }
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key, required this.description}) : super(key: key);
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: Center(
        child: Text(description),
      ),
    );
  }
}

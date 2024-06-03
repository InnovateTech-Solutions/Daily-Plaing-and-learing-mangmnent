import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderForm(),
    );
  }
}

class ReminderForm extends StatefulWidget {
  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reminderNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        "id": 0,
        "remindername": _reminderNameController.text,
        "startDate": _startDateController.text,
        "endDate": _endDateController.text,
        "userEmail": _userEmailController.text,
      };

      final String apiUrl = 'https://emailapitest.azurewebsites.net/api/sendEmailForUser';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form submitted successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit form')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reminderNameController,
                decoration: InputDecoration(labelText: 'Reminder Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reminder name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userEmailController,
                decoration: InputDecoration(labelText: 'User Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

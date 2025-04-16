import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/request_controller.dart';
import 'package:flutter_application/models/form_model.dart';
import 'package:flutter_application/utils/validators.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:flutter_application/widgets/loading_overlay.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String gender = "";
  String eventType = "";
  bool isLoading = false;
  final RequestController _requestController = RequestController();

  void submitForm() async {
    if (formKey.currentState!.validate() && validateGender()) {
      setState(() {
        isLoading = true;
      });

      try {
        //  form model with all the data
        FormModel formData = FormModel(
          fullName: fullNameController.text,
          email: emailController.text,
          eventType: eventType,
          gender: gender,
        );

        //  API Call
        final result = await _requestController.saveData(formData: formData);
        
        setState(() {
          isLoading = false;
        });
        
        if (result.isNotEmpty) {
          // Show success dialog with form data
          showFormDataDialog();
        } else {
          _showErrorSnackBar("Failed to submit form. Please try again.");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar("Error: ${e.toString()}");
      }
    }
  }

  bool validateGender() {
    if (gender.isEmpty) {
      _showErrorSnackBar("Please select your gender");
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }

  void showFormDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registration Successful"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name: ${fullNameController.text}"),
            SizedBox(height: 8),
            Text("Email: ${emailController.text}"),
            SizedBox(height: 8),
            Text("Event Type: $eventType"),
            SizedBox(height: 8),
            Text("Gender: $gender"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetForm();
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void resetForm() {
    fullNameController.clear();
    emailController.clear();
    setState(() {
      gender = "";
      eventType = "";
    });
    formKey.currentState?.reset();
  }

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registration'),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Registration Form", 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: fullNameController,
                    label: "Full Name",
                    prefixIcon: Icons.person,
                    validator: (val) => Validators.validateRequired(val, "name"),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Gender", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                  ),
                  RadioListTile(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (val) {
                      setState(() {
                        gender = val!;
                      });
                    },
                    title: Text("Male"),
                    activeColor: Colors.deepPurple,
                  ),
                  RadioListTile(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (val) {
                      setState(() {
                        gender = val!;
                      });
                    },
                    title: Text("Female"),
                    activeColor: Colors.deepPurple,
                  ),
                  RadioListTile(
                    value: "Other",
                    groupValue: gender,
                    onChanged: (val) {
                      setState(() {
                        gender = val!;
                      });
                    },
                    title: Text("Other"),
                    activeColor: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Event Type",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Workshop",
                        child: Text("Workshop"),
                      ),
                      DropdownMenuItem(
                        value: "Seminar",
                        child: Text("Seminar"),
                      ),
                      DropdownMenuItem(
                        value: "Webinar",
                        child: Text("Webinar"),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        eventType = val!;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please select an event type";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
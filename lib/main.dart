import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PatientVitalsApp());
}

class PatientVitalsApp extends StatelessWidget {
  const PatientVitalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Vitals',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

// 🔐 Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      print("Validation failed");
      return;
    }

    setState(() => _isLoading = true);
    try {
      print("Attempting login for ${_emailController.text}");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Login success, navigating...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DoctorVitalsScreen()),
      );
    } catch (e) {
      print("Login failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🩺 Doctor Vitals Screen
class DoctorVitalsScreen extends StatefulWidget {
  const DoctorVitalsScreen({super.key});

  @override
  State<DoctorVitalsScreen> createState() => _DoctorVitalsScreenState();
}

class _DoctorVitalsScreenState extends State<DoctorVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bpController = TextEditingController();
  final _pulseController = TextEditingController();
  final _sugarController = TextEditingController();
  final _weightController = TextEditingController();
  final _cholesterolController = TextEditingController();

  void _saveVitals() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('patient_vitals').add({
          'blood_pressure': _bpController.text,
          'pulse': _pulseController.text,
          'sugar': _sugarController.text,
          'weight': _weightController.text,
          'cholesterol': _cholesterolController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vitals saved to cloud')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
      }
    }
  }

  @override
  void dispose() {
    _bpController.dispose();
    _pulseController.dispose();
    _sugarController.dispose();
    _weightController.dispose();
    _cholesterolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Patient Vitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField('Blood Pressure', _bpController),
              _buildField('Pulse', _pulseController),
              _buildField('Blood Sugar', _sugarController),
              _buildField('Weight (kg)', _weightController),
              _buildField('Cholesterol', _cholesterolController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVitals,
                child: const Text('Save Vitals'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Saved Vitals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('patient_vitals')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final vitals = snapshot.data!.docs;

                  return Column(
                    children:
                        vitals.map((doc) {
                          final rawData = doc.data();
                          if (rawData is! Map<String, dynamic>) {
                            return const SizedBox(); // Skip bad data
                          }
                          final data = rawData;

                          return Card(
                            child: ListTile(
                              title: Text(
                                "BP: ${data['blood_pressure']} | Pulse: ${data['pulse']}",
                              ),
                              subtitle: Text(
                                "Sugar: ${data['sugar']}, Weight: ${data['weight']}, Chol: ${data['cholesterol']}",
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      controller: controller,
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}

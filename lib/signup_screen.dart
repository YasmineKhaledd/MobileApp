import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muproject/DBHelper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _companySize = 'None';
  final List<String> _companyIndustries = [];
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();



  final List<String> _availableCompanyIndustries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Retail',
    'Manufacture',
    'Education',
    'Other',
  ];
 






 String? _pickupLocation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _getCurrentLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // User denied the request for location permission
      return;
    }

    // Get the device's current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Use the position to set the pickup location variable
    setState(() {
      _pickupLocation =
          "${position.latitude.toString()}, ${position.longitude.toString()}";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Container(
        child: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.all(16.0),
          child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [




              TextFormField(
                controller: _companyNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactPersonNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact person name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Contact Person Name',
                ),
              ),
              
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  String pattern = r'^\+?\d{9,15}$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  String pattern =
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company address';
                  }
                  return null;
                },
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                ),
              ),


              const SizedBox(height: 16.0),

   //sssssssssssssssss


              Row(
                children: <Widget>[

                  Expanded(
                    child: TextFormField(
                        validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please pickup your location';
                }
                },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _pickupLocation ?? '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Pickup Location',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),




      ElevatedButton(
        
        onPressed: () async {
        _getCurrentLocation();
  
  },
  child: Text('pick up loc '),
),

                ],
              ),



   //sssssssssssssssssssssss
                const SizedBox(height: 16.0),


                DropdownButtonFormField<String>(
                value: _companySize,
                onChanged: (value) {
                setState(() {
                _companySize = value!;
                });
                },
                items: ['None', 'Micro', 'Small', 'Mini', 'Large']
                .map((size) => DropdownMenuItem<String>(
                value: size,
                child: Text(size),
                ))
                .toList(),
                decoration: const InputDecoration(
                labelText: 'Company Size (optional)',
                ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                controller: _passwordController,
                validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter password';
                }
                if (value.length < 8) {
                return 'Password must be at least 8 characters';
                }
                return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                labelText: 'Password',
                ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                controller: _confirmPasswordController,
                validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter confirm password';
                }
                if (value != _passwordController.text) {
                return 'Passwords do not match';
                }
                return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                labelText: 'Confirm Password',
                ),
                ),

              const SizedBox(height: 25.0),
              
              Text('Company Industry (optional)'),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 8.0,

                children: _availableCompanyIndustries.map((industry) 
                { 
                  return CheckboxListTile(
                    title: Text(industry),
                    value: _companyIndustries.contains(industry),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value) {
                          _companyIndustries.add(industry);
                        } else {
                          _companyIndustries.remove(industry);
                        }
                      });
                    },
                  );
                }).toList(),
              ),



                const SizedBox(height: 16.0),

                SizedBox(
                width: double.infinity,
                
                child: ElevatedButton(
                onPressed: () async {
                if (_formKey.currentState!.validate()) {
                // Form validation successful, proceed with signup
                if (_companyIndustries.isEmpty) {
                _companyIndustries.add('None'); // Add a default value if no industry is selected
                }

                Map<String, dynamic> user = {
                    DBHelper.COMPANY_NAME: _companyNameController.text.trim(),
                    DBHelper.CONTACT_PERSON_NAME:_contactPersonNameController.text.trim(),
                    DBHelper.COMPANY_INDUSTRY: _companyIndustries.join(','),
                    DBHelper.PHONE_NUMBER: _phoneNumberController.text.trim(),
                    DBHelper.EMAIL: _emailController.text.trim(),
                    DBHelper.ADDRESS: _addressController.text.trim(),
                    DBHelper.LOCATION: _locationController.text.trim(),
                    DBHelper.COMPANY_SIZE: _companySize,
                    DBHelper.PASSWORD: _passwordController.text.trim(),
                  };
                  int insertCount =
                      await DBHelper.insertUser(user);
                  if (insertCount > 0) {
                    Fluttertoast.showToast(
                        msg: 'Sign up successful, please login');
                    Navigator.pop(context, true); // Return signup success
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Sign up failed, please try again');
                  }
                }
              },
              child: const Text('Sign Up'),
              
            ),
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
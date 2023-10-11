import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:muproject/DBHelper.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

 File? _image;

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void uploadImage(File image) async {
    final response = await http.post(
      Uri.parse('https://example.com/upload-image'), // replace with your own API endpoint
      body: {'image': image.path},
    );

    // handle response
  }






  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameController;
  late TextEditingController _contactPersonNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _locationController;
  late String _companySize;
  late List<String> _companyIndustries;
  late String _logoUrl;
  late File? _logoFile;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController();
    _contactPersonNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _locationController = TextEditingController();
    _companySize = 'None';
    _companyIndustries = [];
    _logoUrl = '';
    _logoFile = null;

    // Load user data from the database
    String email = 'example@example.com';
    DBHelper.getUser(email).then((user) {
      setState(() {
        _companyNameController.text = user[DBHelper.COMPANY_NAME] ?? '';
        _contactPersonNameController.text = user[DBHelper.CONTACT_PERSON_NAME] ?? '';
        _phoneNumberController.text = user[DBHelper.PHONE_NUMBER] ?? '';
        _emailController.text = user[DBHelper.EMAIL] ?? '';
        _addressController.text = user[DBHelper.ADDRESS] ?? '';
        _locationController.text = user[DBHelper.LOCATION] ?? '';
        _companySize = user[DBHelper.COMPANY_SIZE] ?? 'None';
        _companyIndustries = (user[DBHelper.COMPANY_INDUSTRY] ?? '').split(',');
        _logoUrl = user[DBHelper.LOGO_URL] ?? '';
      });
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _logoFile = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected');
      }
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Form validation successful, proceed with update
      if (_companyIndustries.isEmpty) {
        _companyIndustries.add('None'); // Add a default value if no industry is selected
      }

      String logoUrl = '';
      if (_logoFile != null) {
        // Upload logo to server if it was changed
        final response = await http.post(
          Uri.parse('https://example.com/upload_logo'),
          body: {'logo': base64Encode(_logoFile!.readAsBytesSync())},
        );
        if (response.statusCode == 200) {
          logoUrl = response.body;
        } else {
          Fluttertoast.showToast(msg: 'Failed to upload logo');
          return;
        }
      }


      Map<String, dynamic> user = {
        DBHelper.COMPANY_NAME: _companyNameController.text.trim(),
        DBHelper.CONTACT_PERSON_NAME: _contactPersonNameController.text.trim(),
        DBHelper.COMPANY_INDUSTRY: _companyIndustries.join(','),
        DBHelper.PHONE_NUMBER: _phoneNumberController.text.trim(),
        DBHelper.EMAIL: _emailController.text.trim(),
        DBHelper.ADDRESS: _addressController.text.trim(),
        DBHelper.LOCATION: _locationController.text.trim(),
        DBHelper.COMPANY_SIZE: _companySize,
        DBHelper.LOGO_URL: logoUrl,
      };

      void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedUser = {
        DBHelper.COMPANY_NAME: _companyNameController.text,
        DBHelper.CONTACT_PERSON_NAME: _contactPersonNameController.text,
        DBHelper.COMPANY_INDUSTRY: _companyIndustries.toList(),
        DBHelper.PHONE_NUMBER: _phoneNumberController.text,
        DBHelper.EMAIL: _emailController.text,
        DBHelper.ADDRESS: _addressController.text,
        DBHelper.LOCATION: _locationController.text,
        DBHelper.COMPANY_SIZE: _companySize.isEmpty,
      };
    }
      }
      int updateCount = await DBHelper.updateUser(user);
      if (updateCount > 0) {
        Fluttertoast.showToast(msg: 'Profile updated successfully');
        Navigator.pop(context); // Return to previous screen
      } else {
        Fluttertoast.showToast(msg: 'Profile update failed, please try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final image = await getImageFromCamera();
                                uploadImage(image);
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.camera_alt),
                            ),
                            SizedBox(height: 8),
                            Text('Camera'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final image = await getImageFromGallery();
                                uploadImage(image);
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.photo_library),
                            ),
                            SizedBox(height: 8),
                            Text('Gallery'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null ? Icon(Icons.person) : null,
            ),
          ),
                ),
                
                SizedBox(height: 16.0),
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
                  validator : (value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                  }
                  if (value.length < 10) {
                  return 'Phone number must be at least 10 digits';
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
                  if (!value.contains('@')) {
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
                  return 'Please enter address';
                  }
                  return null;
                  },
                  decoration: const InputDecoration(
                  labelText: 'Address',
                  ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                  controller: _locationController,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter company location';
                  }
                  return null;
                  },
                  decoration: const InputDecoration(
                  labelText: 'Company Location [Long. – Lat.]',
                  ),
                  ),
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
                  const Text('Company Industry (optional)'),
                  const SizedBox(height: 8.0),
                  Wrap(
                  spacing: 8.0,
                  children: [
                  FilterChip(
                  label: const Text('IT'),
                  onSelected: (selected) {
                  setState(() {
                  if (selected) {
                  _companyIndustries.add('IT');
                  } else {
                  _companyIndustries.remove('IT');
                  }
                  });
                  },
                  selected: _companyIndustries.contains('IT'),
                  ),
                  FilterChip(
                  label: const Text('Finance'),
                  onSelected: (selected) {
                  setState(() {
                  if (selected) {
                  _companyIndustries.add('Finance');
                  } else {
                  _companyIndustries.remove('Finance');
                  }
                  });
                  },
                  selected: _companyIndustries.contains('Finance'),
                  ),
                  FilterChip(
                  label: const Text('Education'),
                  onSelected: (selected) {
                  setState(() {
                  if (selected) {
                  _companyIndustries.add('Education');
                  } else {
                  _companyIndustries.remove('Education');
                  }
                  });
                  },
                  selected: _companyIndustries.contains('Education'),
                  ),
                  FilterChip(
                  label: const Text('Healthcare'),
                  onSelected: (selected) {
                  setState(() {
                  if (selected) {
                  _companyIndustries.add('Healthcare');
                  } else {
                  _companyIndustries.remove('Healthcare');
                  }
                  });
                  },
                  selected: _companyIndustries.contains('Healthcare'),
                  ),
                  ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Save Changes'),
),
  ),
    ],

),
  ),
    ),
       ),
         );
}
}
  
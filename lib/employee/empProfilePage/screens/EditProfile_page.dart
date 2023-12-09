import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../empDashboard/models/user_model.dart';
import '../../empDashboard/models/user_repository.dart';
import '../bloc/EmpEditProfileApiFiles/emp_edit_profile_bloc.dart';
import '../models/EmpEditProfileRepository.dart';
import '../models/empEditProfileModel.dart';

class EmpEditProfilePage extends StatefulWidget {
  const EmpEditProfilePage({super.key});
  @override
  State<EmpEditProfilePage> createState() => _EmpEditProfilePageState();
}

class _EmpEditProfilePageState extends State<EmpEditProfilePage> with TickerProviderStateMixin{
  late String corporateId;
  late String userName;
  late String password;
  final empNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final pwdController = TextEditingController();
  final emailAddressController = TextEditingController();
  final phoneNoController = TextEditingController();
  late AnimationController addToCartPopUpAnimationController;

  final _formKey = GlobalKey<FormState>();
  String empName = "---";
  String fatherName = "---";
  String pwd = "---";
  String emailAddress = "---";
  String phoneNo = "---";
  late bool isPasswordVisible;
  File? _profilePicture;
  String? base64Image;

  late CameraController _controller;
  void showPopupWithSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }
  void showPopupWithFailedMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }
  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpNoCrossMessage(
            addToCartPopUpAnimationController,
            message
        );
      },
    );
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Profile Picture Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Selfie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takeSelfie();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takeSelfie() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
      if (imageBytes.length < 3 * 1024 * 1024) {
        addToCartPopUpAnimationController.forward();
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
        });
        showPopupWithMessage("Image size should be less than 3MB!");
      } else {
        setState(() {
          base64Image = base64Encode(imageBytes);
          _profilePicture = File(pickedFile.path);
        });

      }
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
      if ((imageBytes.length < 3 * 1024)) {
        addToCartPopUpAnimationController.forward();
        // Delay for a few seconds and then reverse the animation
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
        });
        showPopupWithMessage("Image size should be less than 3MB!");
      } else {
        setState(() {
          GlobalObjects.empProfilePic = base64Image = base64Encode(imageBytes);
          _profilePicture = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> initCamera() async {
    // Check if camera permission is granted
    final PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      // Camera permission is granted, proceed to initialize the camera controller
      final cameras = await availableCameras();
      CameraDescription? frontCamera;

      if (cameras.length == 1) {
        // Use the only available camera as the default
        frontCamera = cameras[0];
      } else {
        // Check for a front camera among available cameras
        for (final camera in cameras) {
          if (camera.lensDirection == CameraLensDirection.front) {
            frontCamera = camera;
            break;
          }
        }
      }

      // Initialize the camera controller with the default/front camera
      _controller = _controller = CameraController(
        frontCamera!,
        ResolutionPreset.medium,
      );

      _controller.setFlashMode(FlashMode.off);

      ;

      // Initialize the controller future.
    } else {
      // Camera permission is not granted, request it
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    isPasswordVisible = false; // Initialize the visibility state
    super.initState();
    print(GlobalObjects.empProfilePic);
    initCamera();
    _loadUserData();
  }

  Future<Map<String, String>> fetchData() async {
    await retrieveFromSharedPreferences();
    return await fetchPlaceholderValues();
  }

  Future<void> _loadUserData() async {
    await retrieveFromSharedPreferences();
    fetchAndPopulateData();
  }

  void fetchAndPopulateData() async {
    try {
      final Map<String, String> apiData = await fetchPlaceholderValues();

      // Update the controllers with the fetched data
      empNameController.text = apiData['empName'] ?? '';
      fatherNameController.text = apiData['fatherName'] ?? '';
      pwdController.text = apiData['pwd'] ?? '';
      emailAddressController.text = apiData['emailAddress'] ?? '';
      phoneNoController.text = apiData['phoneNo'] ?? '';
    } catch (e) {
      print('Error fetching and populating data: $e');
    }
  }

  void _submitDataToAPI(EmpEditProfileModel dataToSubmit) {
    if (_profilePicture != null) {
      // Encode the image only if it's not empty
      final imageBytes = _profilePicture!.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }

    context
        .read<EmpEditProfileBloc>()
        .add(SubmitEmpEditProfileData(dataToSubmit));

  }

  Widget buildEditProfilePicture() {
    if (_profilePicture != null) {
      return ClipOval(
        child: Image.file(
          _profilePicture!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }
    else if (GlobalObjects.empProfilePic != null && _profilePicture == null) {
      try {
        final imageBytes = base64Decode(GlobalObjects.empProfilePic!);
        if (imageBytes.isNotEmpty) {
          return ClipOval(
            child: Image.memory(
              Uint8List.fromList(imageBytes),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          );
        }
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    return ClipOval(
      child: Image.asset(
        'assets/icons/userrr.png',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  // Inside your build method:
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: AppBarStyles.appBarTextStyle,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.brightWhite),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for data, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error, for example, show an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              // Handle case where no data is available
              return const Center(child: Text('No data available'));
            } else {
              final apiData = snapshot.data!;

              empNameController.text = apiData['empName'] ?? '';
              fatherNameController.text = apiData['fatherName'] ?? '';
              pwdController.text = apiData['pwd'] ?? '';
              emailAddressController.text = apiData['emailAddress'] ?? '';
              phoneNoController.text = apiData['phoneNo'] ?? '';
              return BlocProvider(
                create: (context) => EmpEditProfileBloc(
                    empEditProfileRepository: EmpEditProfileRepository()),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height / 14, 0, 0),
                    child: Form(
                      key: _formKey,
                      child: Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          child: Card(
                            color:
                                Colors.transparent, // Make the Card transparent
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _pickProfilePicture();
                                    },
                                    child: Center(
                                      child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              buildEditProfilePicture(),
                                              const Center(
                                                child: Icon(Icons.edit,
                                                    size: 25.0,
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Personal Information",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: empNameController,
                                    // Use the controller here
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.black),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      empNameController.text =
                                          value!; // Update the controller's value
                                    },
                                  ),
                                  // Repeat this for other TextFormFields
                                  TextFormField(
                                    controller: fatherNameController,
                                    decoration: InputDecoration(
                                      labelText: "Father's Name",
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.black),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your father's name";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      fatherNameController.text = value!;
                                    },
                                  ),
                                  TextFormField(
                                    controller: pwdController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.black),
                                      suffixIcon:IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible = !isPasswordVisible;
                                          });
                                        },
                                      ),

                                    ),
                                    obscureText: !isPasswordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      pwdController.text = value!;
                                    },
                                  ),
                                  TextFormField(
                                    controller: emailAddressController,
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.black),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      emailAddressController.text = value!;
                                    },
                                  ),
                                  TextFormField(
                                    controller: phoneNoController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.black),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      phoneNoController.text = value!;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                      child: Center(
                                    child: BlocConsumer<EmpEditProfileBloc,
                                        EmpEditProfileState>(
                                      listener: (context, state) {
                                        if (state is EmpEditProfileSuccess) {
                                          addToCartPopUpAnimationController.forward();
                                          // Delay for a few seconds and then reverse the animation
                                          Timer(const Duration(seconds: 3), () {
                                            addToCartPopUpAnimationController.reverse();
                                            Navigator.pop(context);
                                            Navigator.pop(context,true);
                                          });

                                          showPopupWithSuccessMessage("Profile updated successfully!");

                                        } else if (state is EmpEditProfileError) {
                                          // Show a failure toast message when data submission fails
                                          addToCartPopUpAnimationController.forward();
                                          // Delay for a few seconds and then reverse the animation
                                          Timer(const Duration(seconds: 3), () {
                                            addToCartPopUpAnimationController.reverse();
                                            Navigator.pop(context);
                                          });
                                          showPopupWithFailedMessage("Failed to update!");
                                        }
                                      },
                                      builder: (context, state) {
                                        return Builder(builder: (context) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                final dataToSubmit =
                                                    EmpEditProfileModel(
                                                  empId: GlobalObjects.empId,
                                                  empName: empNameController.text,
                                                  fatherName:
                                                      fatherNameController.text,
                                                  pwd: pwdController.text,
                                                  emailAddress:
                                                      emailAddressController.text,
                                                  phoneNo: phoneNoController.text,
                                                  profilePic: base64Image ?? GlobalObjects.empProfilePic!,
                                                );
                                                _submitDataToAPI(dataToSubmit);
                                                addToCartPopUpAnimationController.forward();
                                                // Delay for a few seconds and then reverse the animation
                                                Timer(const Duration(seconds: 3), () {
                                                  addToCartPopUpAnimationController.reverse();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context,true);
                                                });
                                                showPopupWithSuccessMessage("Profile updated successfully!");
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                            ),
                                            child: Text(
                                              'Save',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<void> retrieveFromSharedPreferences() async {
    final sharedPrefEmp = await SharedPreferences.getInstance();

    corporateId = sharedPrefEmp.getString('corporate_id')!;
    userName = sharedPrefEmp.getString('user_name')!;
    password = sharedPrefEmp.getString('password')!;

    if (corporateId != null && userName != null && password != null) {

    } else {
      // Handle the case where data is not found in shared preferences
      print('Data not found in shared preferences');
    }
  }

  Future<Map<String, String>> fetchPlaceholderValues() async {
    // Use the values retrieved from shared preferences
    final String retrievedCorporateId = corporateId;
    final String retrievedUsername = userName;
    final String retrievedPassword = password;

    final userRepository = UserRepository();
    try {
      final List<Employee> employees = (await userRepository.getData(
          corporateId: retrievedCorporateId,
          username: retrievedUsername,
          password: retrievedPassword,
          role: 'employee'));

      if (employees.isNotEmpty) {
        final employee = employees[0];
        return {
          'empName': employee.empName,
          'fatherName': employee.fatherName,
          'pwd': employee.pwd,
          'emailAddress': employee.emailAddress,
          'phoneNo': employee.phoneNo,
        };
      } else {
        throw Exception('No employee data found');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors or provide default values as needed
      return {
        'empName': 'Muhammad Ali',
        'fatherName': 'Ali Hassan',
        'pwd': '1999',
        'emailAddress': 'muhammadali@gmail.com',
        'phoneNo': '123456789',
      };
    }
  }
}

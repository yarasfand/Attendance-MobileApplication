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
import 'package:project/employee/empDashboard/screens/employeeMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import '../../../Sqlite/sqlite_helper.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../empDashboard/models/user_model.dart';
import '../../empDashboard/models/user_repository.dart';
import '../bloc/EmpEditProfileApiFiles/emp_edit_profile_bloc.dart';
import '../models/EmpEditProfileRepository.dart';
import '../models/empEditProfileModel.dart';

class EmpEditProfilePage extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback? onSaveSuccess; // Define the onSaveSuccess callback

  EmpEditProfilePage({Key? key, required this.onSave, this.onSaveSuccess}) : super(key: key);


  @override
  State<EmpEditProfilePage> createState() => _EmpEditProfilePageState(onSave);


}

class _EmpEditProfilePageState extends State<EmpEditProfilePage>
    with TickerProviderStateMixin {
  final VoidCallback onSave;

  _EmpEditProfilePageState(this.onSave);

  final EmployeeDatabaseHelper dbHelper = EmployeeDatabaseHelper.instance;
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
            addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithFailedMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpNoCrossMessage(
            addToCartPopUpAnimationController, message);
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

  Future<void> _loadUserData() async {
    fetchAndPopulateData();
  }

  void fetchAndPopulateData() async {
    try {
      // Update the controllers with the fetched data
      empNameController.text = GlobalObjects.empName ?? '';
      fatherNameController.text = GlobalObjects.empFatherName ?? '';
      pwdController.text = GlobalObjects.empPassword ?? '';
      emailAddressController.text = GlobalObjects.empMail ?? '';
      phoneNoController.text = GlobalObjects.empPhone ?? '';
    } catch (e) {
      print('Error fetching and populating data: $e');
    }
  }

  Future<void> _submitDataToAPI(EmpEditProfileModel dataToSubmit) async {
    if (_profilePicture != null) {
      final imageBytes = _profilePicture!.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }

    try {
      final dbHelper = EmployeeDatabaseHelper.instance;
      int loggedInEmployeeId = await dbHelper.getLoggedInEmployeeId();

      if (loggedInEmployeeId > 0) {
        final db = await dbHelper.database;
        await db.transaction((txn) async {
          await txn.rawInsert('''
            INSERT OR REPLACE INTO employeeProfileData (empCode, profilePic, empName, emailAddress)
            VALUES (?, ?, ?, ?)
          ''', [
            GlobalObjects.empCode,
            dataToSubmit.profilePic,
            dataToSubmit.empName,
            dataToSubmit.emailAddress
          ]);
        });

        setState(() {
          GlobalObjects.empProfilePic = dataToSubmit.profilePic;
          GlobalObjects.empName = dataToSubmit.empName;
          GlobalObjects.empMail = dataToSubmit.emailAddress;
          GlobalObjects.empFatherName=dataToSubmit.fatherName;
          GlobalObjects.empPhone=dataToSubmit.phoneNo;
          GlobalObjects.empPassword=dataToSubmit.pwd;
        });
      }

      await dbHelper.printProfileData();
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      setState(() {});
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
    } else if (GlobalObjects.empProfilePic != null && _profilePicture == null) {
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
        body: BlocProvider(
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
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      color: Colors.transparent, // Make the Card transparent
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
                                              color: AppColors.primaryColor),
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
                                labelStyle:
                                    GoogleFonts.poppins(color: AppColors.black),
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
                                labelStyle:
                                    GoogleFonts.poppins(color: AppColors.black),
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
                                labelStyle:
                                    GoogleFonts.poppins(color: AppColors.black),
                                suffixIcon: IconButton(
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
                                labelStyle:
                                    GoogleFonts.poppins(color: AppColors.black),
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
                                labelStyle:
                                    GoogleFonts.poppins(color: AppColors.black),
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
                                    Timer(const Duration(seconds: 3), () {
                                      addToCartPopUpAnimationController.reverse();
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                      // Call the callback function to update data in EmpProfilePage
                                      widget.onSaveSuccess?.call();
                                    });
                                    showPopupWithSuccessMessage("Profile updated successfully!");
                                    EmpMainPageState().fetchProfileData();
                                  }
                                  else if (state is EmpEditProfileError) {
                                    // Show a failure toast message when data submission fails
                                    addToCartPopUpAnimationController.forward();
                                    // Delay for a few seconds and then reverse the animation
                                    Timer(const Duration(seconds: 3), () {
                                      addToCartPopUpAnimationController
                                          .reverse();
                                      Navigator.pop(context);
                                    });
                                    showPopupWithFailedMessage(
                                        "Failed to update!");
                                  }
                                },
                                builder: (context, state) {
                                  return Builder(builder: (context) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        final empIdSqlite = await dbHelper.getLoggedInEmployeeId();
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          final dataToSubmit = EmpEditProfileModel(
                                            empId: empIdSqlite,
                                            empName: empNameController.text,
                                            fatherName: fatherNameController.text,
                                            pwd: pwdController.text,
                                            emailAddress: emailAddressController.text,
                                            phoneNo: phoneNoController.text,
                                            profilePic: base64Image ?? GlobalObjects.empProfilePic!,
                                          );

                                          _submitDataToAPI(dataToSubmit);
                                          onSave();

                                          // Set the boolean value to true
                                          widget.onSaveSuccess?.call();
                                          addToCartPopUpAnimationController.forward();

                                          // Delay for a few seconds and then reverse the animation
                                          Timer(const Duration(seconds: 3), () {
                                            addToCartPopUpAnimationController.reverse();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });

                                          showPopupWithSuccessMessage("Profile updated successfully!");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
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
        ));
  }
}

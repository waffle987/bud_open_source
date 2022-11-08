import 'package:bud/authentication/ui/otp_page.dart';
import 'package:bud/authentication/ui/start_up_page.dart';
import 'package:bud/authentication/ui/unauth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../general/config.dart';
import '../../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();

  /// Text Editing Controllers
  final TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController otpTextEditingController =
      TextEditingController();

  /// Firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// Stored values
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  RxBool isLoading = RxBool(false);
  String verificationId = '';

  @override
  void onReady() async {
    super.onReady();

    /// Run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);
  }

  @override
  void onClose() {
    super.onClose();

    phoneNumberTextEditingController.dispose();
    otpTextEditingController.dispose();
  }

  /// Logic to handle when USER logs in
  void handleAuthChanged(firebaseUser) async {
    if (firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());

      Get.offAll(() => const StartUpPage());
    } else {
      Get.offAll(() => const UnauthPage());
    }
  }

  /// Firebase user one-time fetch
  Future<User> get getUser async => _firebaseAuth.currentUser!;

  /// Firebase user a real time stream
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  /// Streams the firestore USER from the firestore collection
  Stream<UserModel?> streamFirestoreUser() {
    return _firebaseFirestore
        .collection("users")
        .doc(firebaseUser.value!.uid)
        .snapshots()
        .map((snapshot) => snapshot.data() == null
            ? null
            : UserModel.fromData(snapshot.data()!));
  }

  /// Create the firestore USER in users collection
  void _createUserFirestore(UserModel user, User firebaseUser) {
    _firebaseFirestore
        .collection("users")
        .doc(firebaseUser.uid)
        .set(user.toJson());
    update();
  }

  /// Sign up using Firebase Phone Auth
  void verifyPhoneNumber() async {
    /// Begin loading
    isLoading.value = true;

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+65${phoneNumberTextEditingController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential).then((result) {
            if (result.additionalUserInfo!.isNewUser) {
              /// Create the new USER object
              UserModel newUser = UserModel(
                id: result.user!.uid,
                phoneNumber: result.user!.phoneNumber!,
                username: '',
                photoUrl: '',
                bio: '',
                tag: '',
              );

              /// Create the USER in Firestore
              _createUserFirestore(newUser, result.user!);

              /// Clear Text Editing Controllers
              phoneNumberTextEditingController.clear();
              otpTextEditingController.clear();

              /// End loading
              isLoading.value = false;
            } else {
              /// End loading
              isLoading.value = false;
            }
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
        verificationFailed: (FirebaseAuthException exception) {
          if (exception.code == 'invalid-phone-number') {
            Get.snackbar(
              'Invalid phone number!'.tr,
              "Please use a valid phone number",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 10),
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Authentication issue'.tr,
              exception.code,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 10),
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        codeSent: (String newVerificationId, int? resendToken) {
          verificationId = newVerificationId;

          isLoading.value = false;

          /// Redirect USER to OTP verification page
          Get.to(() => const OTPPage());
        },
      );
    } catch (error) {
      Get.snackbar(
        'Authentication issue'.tr,
        "$error",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Sign in using Firebase Phone Auth
  void signInWithPhoneNumber() async {
    /// Create a PhoneAuthCredential with the OTP
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpTextEditingController.text,
    );

    /// Sign in the USER with the PhoneAuthCredential
    await _firebaseAuth.signInWithCredential(credential).then((result) {
      if (result.additionalUserInfo!.isNewUser) {
        /// Create the new USER object
        UserModel newUser = UserModel(
          id: result.user!.uid,
          phoneNumber: result.user!.phoneNumber!,
          username: '',
          photoUrl: '',
          bio: '',
          tag: '',
        );

        /// Create the USER in Firestore
        _createUserFirestore(newUser, result.user!);

        /// Clear Text Editing Controllers
        phoneNumberTextEditingController.clear();
        otpTextEditingController.clear();

        isLoading.value = false;
      }
    });
  }

  /// Sign out
  Future<void> signOut() {
    /// Clear Text Editing Controllers
    phoneNumberTextEditingController.clear();
    otpTextEditingController.clear();

    /// Reset Firestore USER value
    firestoreUser.value = null;

    Get.snackbar(
      'Signed Out'.tr,
      "Hope that you will back soon!",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );

    return _firebaseAuth.signOut();
  }
}

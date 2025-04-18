import 'package:flutter/material.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'personal_details_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // String _otp = ''; // Removed unused OTP field (handled via callbacks)
  bool _isOtpComplete = false;
  bool _isResendEnabled = false;
  int _resendTimer = 30;
  
  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }
  
  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _isResendEnabled = true;
          }
        });
      }
    });
  }
  
  void _verifyOtp() {
    // This would normally connect to authentication service
    // For now just navigate to the personal details screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP verified successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
    
    // Navigate to the personal details screen to complete profile setup
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PersonalDetailsScreen()),
      );
    });
  }
  
  void _resendOtp() {
    if (_isResendEnabled) {
      setState(() {
        _isResendEnabled = false;
        _resendTimer = 30;
      });
      
      // Here you would actually resend the OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent again!'),
          backgroundColor: Colors.blue,
        ),
      );
      
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'OTP Verification',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Enter the 6-digit OTP',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a verification code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // OTP Input Field
              Center(
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: Colors.indigo,
                  focusedBorderColor: Colors.indigo.shade900,
                  showFieldAsBox: true,
                  borderWidth: 2.0,
                  fieldWidth: 45,
                  borderRadius: BorderRadius.circular(12),
                  onCodeChanged: (String code) {
                    // Handle onCodeChanged
                    setState(() {
                      _isOtpComplete = code.length == 6;
                    });
                  },
                  onSubmit: (String verificationCode) {
                    setState(() {
                      _isOtpComplete = verificationCode.length == 6;
                    });
                    if (_isOtpComplete) {
                      _verifyOtp();
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Resend OTP option
              Center(
                child: GestureDetector(
                  onTap: _isResendEnabled ? _resendOtp : null,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      children: [
                        const TextSpan(text: "Didn't receive the code? "),
                        TextSpan(
                          text: _isResendEnabled 
                            ? "Resend OTP" 
                            : "Resend in $_resendTimer seconds",
                          style: TextStyle(
                            color: _isResendEnabled 
                              ? Colors.indigo.shade900 
                              : Colors.grey.shade500,
                            fontWeight: _isResendEnabled 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: _isOtpComplete ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

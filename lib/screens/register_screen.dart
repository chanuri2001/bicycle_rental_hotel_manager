import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _hotelNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  String? _selectedDistrict;
  String? _selectedCity;

  final Map<String, List<String>> _locationData = {
    'Colombo': ['Colombo 01', 'Colombo 02', 'Colombo 03'],
    'Gampaha': ['Negombo', 'Gampaha City'],
    'Kandy': ['Kandy City', 'Peradeniya'],
  };

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hotelNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        final registerRequest = RegisterRequest(
          hotelName: _hotelNameController.text.trim(),
          district: _selectedDistrict ?? '',
          city: _selectedCity ?? '',
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          agreeToTerms: _agreeToTerms,
        );

        // Using mock registration for demo - replace with _authService.register(registerRequest) for real API
        final registerResponse = await _authService.mockRegister(
          registerRequest,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (registerResponse.success) {
            HapticFeedback.lightImpact();
            _showSuccessMessage(
              registerResponse.message ??
                  'Registration successful! Awaiting approval.',
            );
            _resetForm();
          } else {
            _showErrorMessage(
              registerResponse.message ?? 'Registration failed',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage('Registration error: ${e.toString()}');
        }
      }
    } else if (!_agreeToTerms) {
      _showErrorMessage('Please agree to the Terms and Conditions');
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedDistrict = null;
      _selectedCity = null;
      _agreeToTerms = false;
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Hero(
                          tag: 'bike_logo',
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_bike,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Join SpinIsland',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account to get started',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Create Account 🚀',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fill in your details to get started',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Hotel Name
                              _buildTextField(
                                label: 'Hotel Name',
                                controller: _hotelNameController,
                                hint: 'Enter your hotel name',
                                icon: Icons.apartment,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Please enter hotel name'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // District Dropdown
                              DropdownButtonFormField<String>(
                                decoration: _dropdownDecoration(
                                  'Select District',
                                  Icons.location_city,
                                ),
                                value: _selectedDistrict,
                                items:
                                    _locationData.keys
                                        .map(
                                          (district) => DropdownMenuItem(
                                            value: district,
                                            child: Text(district),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDistrict = value;
                                    _selectedCity = null;
                                  });
                                },
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Please select a district'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // City Dropdown
                              DropdownButtonFormField<String>(
                                decoration: _dropdownDecoration(
                                  'Select City',
                                  Icons.location_on,
                                ),
                                value: _selectedCity,
                                items:
                                    (_selectedDistrict != null
                                            ? _locationData[_selectedDistrict]!
                                            : <String>[])
                                        .map(
                                          (city) => DropdownMenuItem(
                                            value: city,
                                            child: Text(city),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) =>
                                        setState(() => _selectedCity = value),
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Please select a city'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // Full Name
                              _buildTextField(
                                label: 'Full Name',
                                controller: _fullNameController,
                                hint: 'Enter your full name',
                                icon: Icons.person_outline,
                                validator:
                                    (value) =>
                                        value == null || value.length < 2
                                            ? 'Enter valid name'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // Email
                              _buildTextField(
                                label: 'Email Address',
                                controller: _emailController,
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Please enter email';
                                  final emailRegex = RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  );
                                  return !emailRegex.hasMatch(value)
                                      ? 'Invalid email format'
                                      : null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Username
                              _buildTextField(
                                label: 'Username',
                                controller: _usernameController,
                                hint: 'Choose a username',
                                icon: Icons.alternate_email,
                                validator:
                                    (value) =>
                                        value == null || value.length < 3
                                            ? 'Minimum 3 characters'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // Password
                              _buildTextField(
                                label: 'Password',
                                controller: _passwordController,
                                hint: 'Create a password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onTogglePassword:
                                    () => setState(
                                      () =>
                                          _isPasswordVisible =
                                              !_isPasswordVisible,
                                    ),
                                validator:
                                    (value) =>
                                        value == null || value.length < 6
                                            ? 'Minimum 6 characters'
                                            : null,
                              ),

                              const SizedBox(height: 20),

                              // Confirm Password
                              _buildTextField(
                                label: 'Confirm Password',
                                controller: _confirmPasswordController,
                                hint: 'Confirm your password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isPasswordVisible: _isConfirmPasswordVisible,
                                onTogglePassword:
                                    () => setState(
                                      () =>
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible,
                                    ),
                                validator:
                                    (value) =>
                                        value != _passwordController.text
                                            ? 'Passwords do not match'
                                            : null,
                              ),

                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged:
                                        (value) => setState(
                                          () => _agreeToTerms = value ?? false,
                                        ),
                                    activeColor: const Color(0xFF4CAF50),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I agree to the ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: TextStyle(
                                              color: Color(0xFF4CAF50),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: Color(0xFF4CAF50),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child:
                                      _isLoading
                                          ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Text(
                                            'Create Account',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              Center(
                                child: GestureDetector(
                                  onTap:
                                      () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginScreen(),
                                        ),
                                      ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Sign In',
                                          style: TextStyle(
                                            color: Color(0xFF4CAF50),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: onTogglePassword,
                    )
                    : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}

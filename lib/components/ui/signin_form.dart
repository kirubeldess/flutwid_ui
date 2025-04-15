import 'package:flutter/material.dart';

class SigninForm extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;
  final Color borderColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color forgotPasswordColor;
  final double borderRadius;
  final String emailHintText;
  final String passwordHintText;
  final String forgotPasswordText;
  final String signInButtonText;
  final VoidCallback? onForgotPasswordPressed;
  final Function(String email, String password)? onSignInPressed;
  final bool fullWidth;
  final double horizontalPadding;
  final FormFieldValidator<String>? emailValidator;
  final FormFieldValidator<String>? passwordValidator;

  const SigninForm({
    super.key,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.primaryColor = Colors.white,
    this.borderColor = Colors.white,
    this.buttonColor = Colors.white,
    this.buttonTextColor = Colors.black,
    this.forgotPasswordColor = Colors.white,
    this.borderRadius = 8.0,
    this.emailHintText = 'Email',
    this.passwordHintText = 'Password',
    this.forgotPasswordText = 'Forgot Password?',
    this.signInButtonText = 'Sign In',
    this.onForgotPasswordPressed,
    this.onSignInPressed,
    this.fullWidth = true,
    this.horizontalPadding = 16.0,
    this.emailValidator,
    this.passwordValidator,
  });

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Custom email validator if not provided
  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Custom password validator if not provided
  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final signInForm = FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius * 2),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _emailController,
                  hintText: widget.emailHintText,
                  prefixIcon: Icons.email_outlined,
                  validator: widget.emailValidator ?? _defaultEmailValidator,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hintText: widget.passwordHintText,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: widget.passwordValidator ?? _defaultPasswordValidator,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: widget.primaryColor.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onForgotPasswordPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: widget.forgotPasswordColor,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        widget.forgotPasswordText,
                        style: TextStyle(
                          color: widget.forgotPasswordColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (widget.onSignInPressed != null) {
                          widget.onSignInPressed!(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.buttonColor,
                      foregroundColor: widget.buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      elevation: 4,
                      shadowColor: widget.buttonColor.withOpacity(0.4),
                    ),
                    child: Text(
                      widget.signInButtonText,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: widget.buttonTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    // If fullWidth is true, wrap the signin form in a Padding widget
    return widget.fullWidth 
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: signInForm,
          )
        : signInForm;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: widget.textColor),
      cursorColor: widget.primaryColor,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: widget.textColor.withOpacity(0.5)),
        prefixIcon: Icon(
          prefixIcon,
          color: widget.primaryColor.withOpacity(0.7),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: widget.backgroundColor.withOpacity(0.6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

// Example usage
class ExampleSignIn extends StatelessWidget {
  const ExampleSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SigninForm(
                onSignInPressed: (email, password) {
                  // Handle sign in
                },
                onForgotPasswordPressed: () {
                  // Handle forgot password
                },
              ),
              const SizedBox(height: 24),
              SigninForm(
                backgroundColor: Colors.black,
                primaryColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: Colors.black,
                horizontalPadding: 32.0, // Custom horizontal padding
                onSignInPressed: (email, password) {
                  // Handle sign in
                },
              ),
              const SizedBox(height: 24),
              SigninForm(
                backgroundColor: Colors.black,
                primaryColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: Colors.black,
                fullWidth: false, // Non-full width signin form
                onSignInPressed: (email, password) {
                  // Handle sign in
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

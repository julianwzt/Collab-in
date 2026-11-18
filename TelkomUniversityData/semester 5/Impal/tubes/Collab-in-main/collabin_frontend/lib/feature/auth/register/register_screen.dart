import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collabin/core/common/app_ui_helper.dart';
import 'package:collabin/core/widget/auth_text_field.dart';
import 'package:collabin/core/widget/auth_buttons.dart';
import 'package:collabin/core/common/color_value.dart';
import 'package:collabin/feature/auth/bloc/register_bloc/register_bloc.dart';
import 'package:collabin/feature/auth/bloc/register_bloc/register_event.dart';
import 'package:collabin/feature/auth/bloc/register_bloc/register_state.dart';
import '../forgot_password/reset_password_screen.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../core/common/shared_code.dart';
import '../service/firebase_integration_service.dart';
import '../../../core/widget/bottom_navigation.dart';
import '../login/login_screen.dart';
import '../repository/register_repository/register_repository.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SharedCode _sharedCode = SharedCode();
  late final RegisterPageBloc _registerPageBloc;

  bool _obscurePassword = true;

  bool _isLoading(RegisterPageState state) => state is RegisterPageLoading;

  @override
  void initState() {
    super.initState();
    _registerPageBloc = RegisterPageBloc(
      registerRepository: RegisterRepositoryImpl(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _registerPageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerPageBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: BlocConsumer<RegisterPageBloc, RegisterPageState>(
          listener: (context, state) {
            if (state is RegisterPageLoaded) {
              FocusManager.instance.primaryFocus?.unfocus();

              AppUiHelper.showSuccess(context, 'Registrasi berhasil! Silakan masuk.');
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            } else if (state is RegisterPageError) {
              AppUiHelper.showError(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            return _buildInitialLayout(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildInitialLayout(BuildContext context, RegisterPageState state) {
    final bool isLoading = _isLoading(state);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    Assets.image.png.collabinSymbol.path,
                    width: 114,
                    height: 114,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 44),
                  const Text(
                    'Daftar Sekarang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan nama, email dan password untuk mengakses',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: ColorValue.placeholderGrey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'Masukkan email',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: _sharedCode.emailValidator,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _nameController,
                    hintText: 'Masukkan nama',
                    prefixIcon: Icons.accessibility_new,
                    validator: _sharedCode.nameValidator,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: 'Masukkan password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: _sharedCode.passwordValidator,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: ColorValue.brandGray,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AuthPrimaryButton(
                    label: 'Daftar',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              context.read<RegisterPageBloc>().add(
                                RegisterButtonPressed(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  AuthGoogleButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            try {
                              await FirebaseIntegrationService.instance
                                  .signInWithGoogleAndSync(context);
                            } catch (e) {
                              AppUiHelper.showError(
                                context,
                                AppUiHelper.readableError(
                                  e,
                                  fallback:
                                      'Gagal masuk dengan Google. Silakan coba lagi.',
                                ),
                              );
                            }
                          },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: ColorValue.placeholderGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.accentOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

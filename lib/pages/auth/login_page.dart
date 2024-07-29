import 'dart:developer';

import 'package:flutter_task/config/app_assets.dart';
import 'package:flutter_task/config/app_colors.dart';
import 'package:flutter_task/config/app_decorations.dart';
import 'package:flutter_task/pages/home/home.dart';
import 'package:flutter_task/providers/auth_provider.dart';
import 'package:flutter_task/utils/toast_helper.dart';
import 'package:flutter_task/widgets/buttons/app_primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../config/environment.dart';
import '../../utils/validation_helper.dart';

///
/// Created by Auro on 24/06/24 at 8:55 pm
///

class LoginPage extends StatefulWidget {
  static const routeName = "/login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // AuthProvider get authProvider =>
  //     Provider.of<AuthProvider>(context, listen: false);

  GoRouter get router => GoRouter.of(context);

  bool get isLogin =>
      Provider.of<AuthProvider>(context, listen: false).authType == 0;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  handleSubmit(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final state = authProvider.formKey.currentState;
      if (state == null) return;
      if (!state.validate()) {
        await authProvider.handleAutoValidate(AutovalidateMode.always);
      } else {
        if (isLogin) {
          await authProvider.signIn();
          AppToastHelper.showToast(
            "Login successful",
            type: ToastificationType.success,
          );
        } else {
          await authProvider.signUp();
          AppToastHelper.showToast(
            "Account created successfully",
            type: ToastificationType.success,
          );
        }
        router.pushReplacementNamed(HomePage.routeName);
      }
    } catch (err) {
      log("$err");
      AppToastHelper.showToast("$err", type: ToastificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop(context))
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.loginSideBG,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        AppAssets.skullIllustration,
                        errorBuilder: (a, b, c) => const SizedBox(),
                        // cacheHeight: 500,
                        // cacheWidth: 500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop(context) ? 100 : 20,
                ),
                child: Form(
                  key: authProvider.formKey,
                  autovalidateMode: authProvider.autoValidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppAssets.logo),
                      const SizedBox(height: 20),
                      Text(
                        isLogin ? "Login to your Account" : "Create an Account",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "To view all the super awesome products 👾",
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Text("NAME: ${authProvider.isObscure}"),
                      if (!isLogin) ...[
                        TextFormField(
                          key: const Key("S_1"),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onChanged: (v) {
                            authProvider.onNameChanged(v);
                          },
                          decoration:
                              AppDecorations.textFieldDecoration(context)
                                  .copyWith(hintText: "Example : Auro"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key("S_2"),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              AppFormValidators.validateMail(v, context),
                          onChanged: (v) {
                            authProvider.onEmailChanged(v);
                          },
                          decoration:
                              AppDecorations.textFieldDecoration(context)
                                  .copyWith(hintText: "mail@abc.com"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key("S_3"),
                          obscureText: authProvider.isObscure,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (v) => isLogin
                              ? AppFormValidators.validateEmpty(v, context)
                              : AppFormValidators.validateStrongPassword(
                                  v, context),
                          onChanged: (v) {
                            authProvider.onPasswordChanged(v);
                          },
                          decoration:
                              AppDecorations.textFieldDecoration(context)
                                  .copyWith(
                            hintText: "******************",
                            suffixIcon: IconButton(
                              icon: Icon(
                                authProvider.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.greyTextColor,
                                size: 22,
                              ),
                              onPressed: () {
                                authProvider.toggleObscure();
                              },
                            ),
                          ),
                        ),
                      ] else ...[
                        TextFormField(
                          key: const Key("L_1"),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              AppFormValidators.validateMail(v, context),
                          onChanged: (v) {
                            authProvider.onEmailChanged(v);
                          },
                          decoration:
                              AppDecorations.textFieldDecoration(context)
                                  .copyWith(hintText: "mail@abc.com"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key("L_2"),
                          obscureText: authProvider.isObscure,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          validator: (v) => isLogin
                              ? AppFormValidators.validateEmpty(v, context)
                              : AppFormValidators.validateStrongPassword(
                                  v, context),
                          onChanged: (v) {
                            authProvider.onPasswordChanged(v);
                          },
                          decoration:
                              AppDecorations.textFieldDecoration(context)
                                  .copyWith(
                            hintText: "******************",
                            suffixIcon: IconButton(
                              icon: Icon(
                                authProvider.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.greyTextColor,
                                size: 22,
                              ),
                              onPressed: () {
                                authProvider.toggleObscure();
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: AppPrimaryButton(
                          key: authProvider.buttonKey,
                          width: double.infinity,
                          child: Text(isLogin ? "Login" : "Sign Up"),
                          onPressed: () {
                            if (authProvider
                                .buttonKey.currentState!.isLoading) {
                              return;
                            }
                            handleSubmit(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: isLogin
                                ? "Not Registered Yet? "
                                : "Already have an account? ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: Environment.fontFamily,
                              fontSize: 15,
                              color: Color(0xff868686),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    isLogin ? " Create an account." : " Login.",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.primaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    authProvider
                                        .changeAuthType(isLogin ? 1 : 0);
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

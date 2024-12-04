import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibeauty/app_constants.dart';
import 'package:ibeauty/application/auth/auth_bloc.dart';
import 'package:ibeauty/domain/service/helper.dart';
import 'package:ibeauty/domain/service/tr_keys.dart';
import 'package:ibeauty/domain/service/validators.dart';
import 'package:ibeauty/infrastructure/firebase/firebase_service.dart';
import 'package:ibeauty/infrastructure/local_storage/local_storage.dart';
import 'package:ibeauty/presentation/components/blur_wrap.dart';
import 'package:ibeauty/presentation/components/button/custom_button.dart';
import 'package:ibeauty/presentation/components/custom_textformfield.dart';
import 'package:ibeauty/presentation/components/keyboard_dismisser.dart';
import 'package:ibeauty/presentation/route/app_route.dart';
import 'package:ibeauty/presentation/route/app_route_setting.dart';
import 'package:ibeauty/presentation/style/style.dart';
import 'package:ibeauty/presentation/style/theme/theme.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'widgets/social_button.dart';

class SignUpScreen extends StatefulWidget {
  final CustomColorSet colors;
  final TextEditingController phone;

  const SignUpScreen({
    super.key,
    required this.colors,
    required this.phone,
  }) ;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlurWrap(
      radius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: KeyboardDismisser(
        isLtr: LocalStorage.getLangLtr(),
        child: Container(
          margin:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            color: CustomStyle.black.withOpacity(0.25),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              FlutterRemix.arrow_left_line,
                              color: widget.colors.white,
                              size: 26.r,
                            )),
                        const Spacer(),
                        Text(
                          AppHelper.getTrn(TrKeys.signUp),
                          style: CustomStyle.interNoSemi(
                              color: widget.colors.white, size: 20),
                        ),
                        const Spacer(),
                        SizedBox(width: 42.r)
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: AppConstants.socialSignIn
                          .map((e) => SocialButton(
                        iconColor: widget.colors.textBlack,
                        bgColor: widget.colors.socialButtonColor,
                        icon: e,
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(AuthEvent.socialSignIn(
                              context: context,
                              type: e,
                              onSuccess: () {
                                if (LocalStorage.getAddress() ==
                                    null) {
                                  AppRouteSetting.goSelectCountry(
                                      context: context);
                                  return;
                                }
                                if (AppConstants.isDemo &&
                                    LocalStorage.getUiType() ==
                                        null) {
                                  AppRouteSetting.goSelectUIType(
                                      context: context);
                                  return;
                                }
                                AppRoute.goMain(context);
                              }));
                        },
                      ))
                          .toList(),
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(child: Divider(color: widget.colors.white)),
                        8.horizontalSpace,
                        Text(
                          AppHelper.getTrn(TrKeys.orAccessQuickly),
                          style: CustomStyle.interNormal(
                              color: widget.colors.white, size: 12),
                        ),
                        8.horizontalSpace,
                        Expanded(child: Divider(color: widget.colors.white)),
                      ],
                    ),
                    16.verticalSpace,
                    if (AppConstants.isSpecificNumberEnabled)
                      IntlPhoneField(
                        cursorWidth: 1,
                        cursorColor: widget.colors.textBlack,
                        disableLengthCheck:
                        !AppConstants.isNumberLengthAlwaysSame,
                        initialCountryCode: AppConstants.countryCodeISO,
                        autovalidateMode:
                        AppConstants.isNumberLengthAlwaysSame
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        showCountryFlag: AppConstants.showFlag,
                        showDropdownIcon: AppConstants.showArrowIcon,
                        validator: (s) {
                          if (AppConstants.isNumberLengthAlwaysSame &&
                              (s?.isValidNumber() ?? true)) {
                            return AppHelper.getTrn(
                                TrKeys.phoneNumberIsNotValid);
                          }
                          return null;
                        },
                        style: CustomStyle.interNormal(
                          size: 14.sp,
                          color: widget.colors.textBlack,
                        ),
                        onChanged: (phoneNum) {
                          widget.phone.text = phoneNum.completeNumber;
                        },
                        dropdownTextStyle: CustomStyle.interNormal(
                          size: 14.sp,
                          color: widget.colors.textBlack,
                        ),
                        keyboardType: TextInputType.phone,
                        invalidNumberMessage:
                        AppHelper.getTrn(TrKeys.phoneNumberIsNotValid),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlignVertical: const TextAlignVertical(y: .2),
                        decoration: InputDecoration(
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          fillColor: widget.colors.socialButtonColor,
                          filled: true,
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(color: widget.colors.icon)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomStyle.icon)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomStyle.icon)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomStyle.icon)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomStyle.icon)),
                        ),
                      ),
                    if (!AppConstants.isSpecificNumberEnabled)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: widget.colors.socialButtonColor,
                      ),
                      child: CustomTextFormField(
                        validation: AppValidators.isNotEmptyValidator,
                        controller: widget.phone,
                        hint: AppHelper.getTrn(TrKeys.phoneNumber),
                        inputType: TextInputType.phone,
                      ),
                    ),
                    16.verticalSpace,
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (l, n) {
                        return l.isLoading != n.isLoading;
                      },
                      builder: (context, state) {
                        return CustomButton(
                            isLoading: state.isLoading,
                            title: AppHelper.getTrn(TrKeys.signUp),
                            bgColor: widget.colors.primary,
                            titleColor: CustomStyle.white,
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                if (AppHelper.checkPhone(
                                    widget.phone.text.replaceAll(" ", ""))) {
                                  context.read<AuthBloc>().add(AuthEvent.checkPhone(
                                      context: context,
                                      phone: widget.phone.text,
                                      onSuccess: () {
                                        FirebaseService.sendCode(
                                            phone: widget.phone.text,
                                            onSuccess: (id) {
                                              context.read<AuthBloc>().add(
                                                  AuthEvent.setVerificationId(
                                                      id: id));
                                              Navigator.pop(context);
                                              },
                                            onError: (e) {
                                              AppHelper.errorSnackBar(
                                                  context: context, message: e);
                                            });
                                      }));
                                } else {
                                  AppHelper.errorSnackBar(
                                      context: context,
                                      message: AppHelper.getTrn(
                                          TrKeys.thisNotPhoneNumber));
                                }
                              }
                            });
                      },
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

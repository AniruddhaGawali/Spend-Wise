import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/data/constant_values.dart';
import 'package:spendwise/utils/about_device.dart';
import 'package:spendwise/widgits/loading.dart';

class AuthWidget extends HookConsumerWidget {
  final bool isLogin;
  final String title;
  final String subTitle;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final String? bottomText;
  final String? bottomButtonText;
  final Widget? bottomWidget;
  final Widget? nextScreen;
  final Future<bool> Function(String username, String password, bool rememberMe,
      WidgetRef ref, BuildContext context)? onSubmit;

  const AuthWidget({
    super.key,
    required this.isLogin,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    this.bottomText,
    this.bottomButtonText,
    this.bottomWidget,
    this.nextScreen,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = getTopPadding(context);

    final widgetHeight = isLandscape(context)
        ? screenHeight
        : screenHeight - statusBarHeight - 40;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState(false);
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: SizedBox(
            height: widgetHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getTopPadding(context) + padding * 2,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: spacerHeight,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Spacer(),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                      const SizedBox(
                        height: spacerHeight,
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintText: "Enter your username",
                          icon: Icon(MdiIcons.accountCircleOutline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: spacerHeight,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          icon: Icon(MdiIcons.lockOutline),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              isPasswordVisible.value =
                                  !isPasswordVisible.value;
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: spacerHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: rememberMe.value,
                            onChanged: (value) {
                              rememberMe.value = value ?? false;
                            },
                          ),
                          Text(
                            "Remember Me",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: spacerHeight,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: () async {
                            isLoading.value = true;
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (onSubmit != null) {
                                bool isSuccess = await onSubmit!(
                                  usernameController.text,
                                  passwordController.text,
                                  rememberMe.value,
                                  ref,
                                  context,
                                );

                                if (isSuccess) {
                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => nextScreen!,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                            isLoading.value = false;
                          },
                          icon: isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Loading(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(buttonIcon),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              buttonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: spacerHeight,
                      ),
                      bottomButtonText != null &&
                              bottomButtonText!.isNotEmpty &&
                              bottomText != null &&
                              bottomText!.isNotEmpty &&
                              bottomWidget != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bottomText!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => bottomWidget!,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    bottomButtonText!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

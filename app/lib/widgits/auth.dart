import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  final Future<bool> Function(String email, String username, String password,
      bool rememberMe, WidgetRef ref, BuildContext context)? onSubmit;

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
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final email = useState('');
    final username = useState('');
    final password = useState('');
    final rememberMe = useState(false);
    final isLoading = useState(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 80,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      !isLogin
                          ? TextFormField(
                              decoration: InputDecoration(
                                  icon: Icon(MdiIcons.emailOutline),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an user email';
                                }
                                return null;
                              },
                              onSaved: (newValue) => email.value = newValue!,
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(MdiIcons.accountCircleOutline),
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an username';
                          }
                          return null;
                        },
                        onSaved: (newValue) => username.value = newValue!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(MdiIcons.lockOutline),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onSaved: (newValue) => password.value = newValue!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: rememberMe.value,
                            onChanged: (value) {
                              rememberMe.value = value!;
                            },
                          ),
                          Text(
                            'Remember me',
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            isLoading.value = true;
                            if (onSubmit != null) {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                bool isSuccessFull = await onSubmit!(
                                  email.value,
                                  username.value,
                                  password.value,
                                  rememberMe.value,
                                  ref,
                                  context,
                                );

                                if (isSuccessFull) {
                                  if (nextScreen != null) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Account created successfully!",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onTertiaryContainer,
                                                  )),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                        ),
                                      );

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => nextScreen!,
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Account creation failed!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer,
                                                )),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
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
                                        Theme.of(context).colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  buttonIcon,
                                ),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Text(
                              buttonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (bottomText != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bottomText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                if (bottomWidget != null) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => bottomWidget!,
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: Text(
                                bottomButtonText!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )),
            ],
          ),
        )),
      ),
    );
  }
}

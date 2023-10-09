import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthWidgit extends StatefulWidget {
  final bool isLogin;
  final String title;
  final String subTitle;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final String? bottomText;
  final String? bottomButtonText;
  final Widget? bottomWidget;

  const AuthWidgit({
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
  });

  @override
  State<AuthWidgit> createState() => _AuthWidgitState();
}

class _AuthWidgitState extends State<AuthWidgit> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    print(widget.bottomButtonText.runtimeType);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + 40,
                ),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.subTitle,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Spacer(),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Username",
                              hintText: "Enter your username",
                              icon: Icon(MdiIcons.accountCircleOutline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a username";
                            }
                            return null;
                          },
                          onSaved: (newValue) => setState(() {
                            _username = newValue!;
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: _isPasswordVisible,
                          decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              icon: Icon(MdiIcons.lockOutline),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    },
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }
                            return null;
                          },
                          onSaved: (newValue) => setState(() {
                            _password = newValue!;
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.isLogin
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Remember Me",
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
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Icon(widget.buttonIcon),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.buttonText,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.bottomButtonText != null &&
                                widget.bottomButtonText!.isNotEmpty &&
                                widget.bottomText != null &&
                                widget.bottomText!.isNotEmpty &&
                                widget.bottomWidget != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.bottomText!,
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
                                          builder: (context) =>
                                              widget.bottomWidget!,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      widget.bottomButtonText!,
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

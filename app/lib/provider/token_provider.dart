import 'package:hooks_riverpod/hooks_riverpod.dart';

class TokenNotfier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  set(String token) {
    state = token;
  }

  get() {
    return state;
  }

  clear() {
    state = "";
  }
}

final tokenProvider = NotifierProvider<TokenNotfier, String>(() {
  return TokenNotfier();
});

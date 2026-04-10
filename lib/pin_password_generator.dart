import 'dart:ffi';
import 'dart:math';

import 'package:ironkey/password_generator.dart';

class PinPasswordGenerator implements PasswordGenerator{
  String generate(int length){
    const numbers = "1234567890";
    final random = Random();

    return List.generate(length, (_) => numbers[random.nextInt(numbers.length)],
    ).join();
  }
}
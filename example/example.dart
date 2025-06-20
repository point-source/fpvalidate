import 'package:fpvalidate/fpvalidate.dart';

void main() {
  final email = 'test@test.com';
  final result = email.field('Email').notEmpty().email().validateEither();
  print(result);
}

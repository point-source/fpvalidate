import 'package:test/test.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

void main() {
  group('Custom Error Messages', () {
    group('SyncValidationStep', () {
      test('errorOrNull should support custom message', () {
        final step = ''.trust('Field').isNotEmpty();
        final error = step.errorOrNull(
          (fieldName) => 'Custom $fieldName is empty',
        );
        expect(error, equals('Custom Field is empty'));
      });

      test('asFormValidator should support custom message', () {
        final step = ''.trust('Field').isNotEmpty();
        final error = step.asFormValidator(
          (fieldName) => 'Custom $fieldName is empty',
        );
        expect(error, equals('Custom Field is empty'));
      });

      test('verifyEither should support custom message', () {
        final step = ''.trust('Field').isNotEmpty();
        final result = step.verifyEither((fieldName) => 'Custom $fieldName');
        result.fold(
          (l) => expect(l.message, equals('Custom Field')),
          (r) => fail('Should have failed'),
        );
      });
    });

    group('AsyncValidationStep', () {
      test('errorOrNull should support custom message', () async {
        final step = Future.value(
          '',
        ).trust('Field').then((s) => s.isNotEmpty());
        final error = await step.errorOrNull(
          (fieldName) => 'Custom $fieldName is empty',
        );
        expect(error, equals('Custom Field is empty'));
      });

      test('asFormValidator should support custom message', () async {
        final step = Future.value(
          '',
        ).trust('Field').then((s) => s.isNotEmpty());
        final error = await step.asFormValidator(
          (fieldName) => 'Custom $fieldName is empty',
        );
        expect(error, equals('Custom Field is empty'));
      });

      test('verifyTaskEither should support custom message', () async {
        final step = Future.value(
          '',
        ).trust('Field').then((s) => s.isNotEmpty());
        final result = await step
            .verifyTaskEither((fieldName) => 'Custom $fieldName')
            .run();
        result.fold(
          (l) => expect(l.message, equals('Custom Field')),
          (r) => fail('Should have failed'),
        );
      });
    });

    group('BatchSyncValidationExtension', () {
      test('verify should support custom message', () {
        final steps = [
          'abc'.trust('Field1').isNotEmpty(),
          ''.trust('Field2').isNotEmpty(),
        ];
        expect(
          () => steps.verify((fieldName) => 'Custom $fieldName failed'),
          throwsA(
            predicate(
              (e) =>
                  e is ValidationError && e.message == 'Custom Field2 failed',
            ),
          ),
        );
      });

      test('verifyEither should support custom message', () {
        final steps = [
          'abc'.trust('Field1').isNotEmpty(),
          ''.trust('Field2').isNotEmpty(),
        ];
        final result = steps.verifyEither(
          (fieldName) => 'Custom $fieldName failed',
        );
        result.fold(
          (l) => expect(l.message, equals('Custom Field2 failed')),
          (r) => fail('Should have failed'),
        );
      });

      test(
        'verifyEither(sync) conversion to TaskEither should support custom message',
        () async {
          final steps = [
            'abc'.trust('Field1').isNotEmpty(),
            ''.trust('Field2').isNotEmpty(),
          ];
          final result = await steps
              .verifyEither((fieldName) => 'Custom $fieldName failed')
              .toTaskEither()
              .run();
          result.fold(
            (l) => expect(l.message, equals('Custom Field2 failed')),
            (r) => fail('Should have failed'),
          );
        },
      );
    });

    group('BatchAsyncValidationExtension', () {
      test('verifyAsync should support custom message', () {
        final steps = [
          Future.value('abc').trust('Field1').then((s) => s.isNotEmpty()),
          Future.value('').trust('Field2').then((s) => s.isNotEmpty()),
        ];
        expect(
          () async => await steps.verifyAsync(
            (fieldName) => 'Custom $fieldName failed',
          ),
          throwsA(
            predicate(
              (e) =>
                  e is ValidationError && e.message == 'Custom Field2 failed',
            ),
          ),
        );
      });

      test('verifyTaskEither (async) should support custom message', () async {
        final steps = [
          Future.value('abc').trust('Field1').then((s) => s.isNotEmpty()),
          Future.value('').trust('Field2').then((s) => s.isNotEmpty()),
        ];
        final result = await steps
            .verifyTaskEither((fieldName) => 'Custom $fieldName failed')
            .run();
        result.fold(
          (l) => expect(l.message, equals('Custom Field2 failed')),
          (r) => fail('Should have failed'),
        );
      });

      test(
        'verifyTaskEither (async) run should support custom message',
        () async {
          final steps = [
            Future.value('abc').trust('Field1').then((s) => s.isNotEmpty()),
            Future.value('').trust('Field2').then((s) => s.isNotEmpty()),
          ];
          final result = await steps
              .verifyTaskEither((fieldName) => 'Custom $fieldName failed')
              .run();
          result.fold(
            (l) => expect(l.message, equals('Custom Field2 failed')),
            (r) => fail('Should have failed'),
          );
        },
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/components/playground_console.dart';

void main() {
  final PlaygroundLog log = PlaygroundLog.instance;

  setUp(log.clear);

  test('starts empty', () {
    expect(log.isEmpty, isTrue);
    expect(log.text, isEmpty);
  });

  test('keeps lines in the order they arrived', () {
    log.add('first');
    log.add('second');

    expect(log.lines, <String>['first', 'second']);
    expect(log.text, 'first\nsecond');
  });

  test('drops the oldest lines past the cap', () {
    for (int i = 0; i < PlaygroundLog.maxLines + 5; i++) {
      log.add('line $i');
    }

    expect(log.lines.length, PlaygroundLog.maxLines);
    expect(log.lines.first, 'line 5');
    expect(log.lines.last, 'line ${PlaygroundLog.maxLines + 4}');
  });

  test('clear empties the console and notifies once', () {
    int notifications = 0;
    void listener() => notifications++;
    log.addListener(listener);
    addTearDown(() => log.removeListener(listener));

    log.add('something');
    log.clear();

    expect(log.isEmpty, isTrue);
    expect(notifications, 2);
  });

  test('clearing an empty console notifies nobody', () {
    int notifications = 0;
    void listener() => notifications++;
    log.addListener(listener);
    addTearDown(() => log.removeListener(listener));

    log.clear();

    expect(notifications, 0);
  });

  test('logInsider reaches the on-screen console', () {
    logInsider('[INSIDER] hello');

    expect(log.lines, contains('[INSIDER] hello'));
  });
}

// #! /usr/bin/env dcli

// @Timeout(Duration(seconds: 60))
// library spawn_test;

// import 'dart:async';

// import 'package:sync_isolate/src/isolate_channel.dart';
// import 'package:sync_isolate/src/message.dart';
// import 'package:sync_isolate/src/message_response.dart';
// import 'package:sync_isolate/src/simple_in_isolate.dart';
// import 'package:test/test.dart';

// void main(List<String> args) async {
//   test('spawn', () async {
//     await _spawnWithTake(1);
//     print('*' * 120);
//     print('*' * 120);
//     print('*' * 120);
//     await _spawnWithDelayedTake(1);
//   });
// }

// /// spawn the isolate and then immediately all the sync Mailbox.take method.
// Future<void> _spawnWithTake(int index) async {
//   final channel = IsolateChannel();

//   startSimpleIsolate(channel);

//   MessageResponse? response;
//   do {
//     processLogger(() => 'Primary calling Mailbox.take()');
//     try {
//       final messageData =
//           channel.toPrimaryIsolate.take(timeout: const Duration(seconds: 4));
//       response = MessageResponse.fromData(messageData)..onStdout(print);
//     } on TimeoutException catch (e) {
//       // ignore: avoid_print
//       processLogger(
//           () => 'Timeout waiting for response from isolate: ${e.message}');
//     }
//   } while (response?.messageType != MessageType.exitCode);
//   print('primary: received exit message');
// }

// /// spawn the isolate and then wait 20 seconds before calling
// /// the sync Mailbox.take method.
// Future<void> _spawnWithDelayedTake(int index) async {
//   final channel = IsolateChannel();

//   startSimpleIsolate(channel);

//   MessageResponse? response;
//   processLogger(() => 'Sleep to allow the isolate to spawn');
//   do {
//     try {
//       await Future.delayed(const Duration(seconds: 4), () {});
//       processLogger(() => 'Primary calling Mailbox.take()');
//       final messageData =
//           channel.toPrimaryIsolate.take(timeout: const Duration(seconds: 4));
//       response = MessageResponse.fromData(messageData)..onStdout(print);
//     } on TimeoutException catch (e) {
//       // ignore: avoid_print
//       processLogger(
//           () => 'Timeout waiting for response from isolate: ${e.message}');
//       // await Future.delayed(const Duration(seconds: 3), () {});
//     }
//   } while (response?.messageType != MessageType.exitCode);
//   print('primary: received exit message');
// }

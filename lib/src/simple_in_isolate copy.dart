// // ignore_for_file: unnecessary_lambdas, cascade_invocations

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:isolate';
// import 'dart:typed_data';

// // import 'mailbox.dart';
// import 'isolate_channel.dart';
// import 'mailbox_extension.dart';
// import 'message.dart';
// // import 'process_sync.dart';

// /// Setting this to try will cause the isolate to dump lots
// /// of output to stdout. This causes problems with the
// /// some process on the primary isolate side, but often it is the
// /// only way to debug the process in isolate code as the
// /// debugger hangs.
// const debugIsolate = true;

// void startSimpleIsolate(IsolateChannel channel) {
//   unawaited(_startIsolate(channel));
// }

// /// Starts an isolate that spawns the command.
// Future<void> _startIsolate(IsolateChannel channel) {
//   final sendable = channel.asSendable();
//   processLogger(() => 'calling spawn');
//   return Isolate.spawn<IsolateChannelSendable>(
//     _body,
//     sendable,
//     debugName:
//         'ProcessInIsolate - ',
//   );
// }

// Future<void> _body(IsolateChannelSendable channel) async {
//   isolateLogger(() => 'body entered');

//   final mailboxToPrimaryIsolate = channel.toPrimaryIsolate.materialize();

//   try {
//     final message = Uint8List.fromList(utf8.encode('hello from simple'));
//     await mailboxToPrimaryIsolate.postMessage(Message.stdout(message));
//     await mailboxToPrimaryIsolate.postMessage(Message.exit(15));
//   }
//   // ignore: avoid_catches_without_on_clauses
//   catch (e, st) {
//     await mailboxToPrimaryIsolate
//         .postMessage(Message.runException(e.toString()));
//   }

//   isolateLogger(() => 'Isolate is exiting');
// }

// String? _isolateID;
// void isolateLogger(String Function() message) {
//   if (debugIsolate) {
//     _isolateID ??= Service.getIsolateId(Isolate.current);
//     print('${DateTime.now()} isolate($_isolateID): ${message()}');
//   }
// }

// void processLogger(String Function() message) {
//   if (debugIsolate) {
//     _isolateID ??= Service.getIsolateId(Isolate.current);
//     print('${DateTime.now()} process($_isolateID): ${message()}');
//   }
// }

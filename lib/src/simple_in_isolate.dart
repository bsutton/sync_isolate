// ignore_for_file: unnecessary_lambdas, cascade_invocations

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:stack_trace/stack_trace.dart';

// import 'mailbox.dart';
import 'isolate_channel.dart';
import 'mailbox_extension.dart';
import 'message.dart';
import 'run_exception.dart';
// import 'process_sync.dart';

/// Setting this to try will cause the isolate to dump lots
/// of output to stdout. This causes problems with the
/// some process on the primary isolate side, but often it is the
/// only way to debug the process in isolate code as the
/// debugger hangs.
const debugIsolate = true;

void startSimpleIsolate(IsolateChannel channel) {
  processLogger(() => 'starting isolate');
  unawaited(_startIsolate(channel));

  processLogger(() => 'waiting for isolate to spawn');
}

/// Starts an isolate that spawns the command.
Future<void> _startIsolate(IsolateChannel channel) {
  processLogger(() => 'getting sendable');
  final sendable = channel.asSendable();
  processLogger(() => 'calling spawn');
  return Isolate.spawn<IsolateChannelSendable>(
    _body,
    sendable,
    onError: sendable.errorPort,
    debugName:
        'ProcessInIsolate - ${channel.process.command} ${channel.process.args}',
  );

  // return Isolate.spawn<String>(
  //   _body,
  //   'hi',
  //   onError: sendable.errorPort,
  //   debugName:
  //     ProcessInIsolate - ${channel.process.command} ${channel.process.args}',
  // );
}

Future<void> _body(IsolateChannelSendable channel) async {
  isolateLogger(() => 'body entered');

  isolateLogger(() =>
      '''process running: ${channel.process.command} ${channel.process.args}''');

  /// We are now running in the isolate.
  isolateLogger(() => 'started');
  final mailboxToPrimaryIsolate = channel.toPrimaryIsolate.materialize();
  isolateLogger(() => 'mailboxes materialized');

  try {
    isolateLogger(() => 'listen to recieve port');

    final message =Uint8List.fromList(utf8.encode('hello from simple'));
    await mailboxToPrimaryIsolate
        .postMessage(Message.stdout(message));

    isolateLogger(() => 'waiting in isolate for process to exit');

    await mailboxToPrimaryIsolate.postMessage(Message.exit(15));
  } on RunException catch (e, _) {
    isolateLogger(() => 'Exception caught: $e');
    await mailboxToPrimaryIsolate.postMessage(Message.runException(e));
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e, st) {
    await mailboxToPrimaryIsolate.postMessage(Message.runException(
        RunException.fromException(
            e, channel.process.command, channel.process.args,
            stackTrace: Trace.from(st))));
  }

  isolateLogger(() => 'Isolate is exiting');
}

String? _isolateID;
void isolateLogger(String Function() message) {
  if (debugIsolate) {
    _isolateID ??= Service.getIsolateId(Isolate.current);
    print('${DateTime.now()} isolate($_isolateID): ${message()}');
  }
}

void processLogger(String Function() message) {
  if (debugIsolate) {
    _isolateID ??= Service.getIsolateId(Isolate.current);
    print('${DateTime.now()} process($_isolateID): ${message()}');
  }
}
import 'package:events_emitter/events_emitter.dart';

class LoaderHanlder {
  final events = EventEmitter();

  void isLoading(bool loading) {
    events.emit("load", loading);
  }
}

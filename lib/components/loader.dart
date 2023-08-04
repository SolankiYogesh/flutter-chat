import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:folder_stucture/Helpers/Color.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => LoaderState();
}

class LoaderState extends State<Loader> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final events = EventEmitter();
    events.on("load", (data) {
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Positioned(
            child: Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(ColorProvider.PrimaryColor),
              ),
            ),
          ))
        : const SizedBox();
  }
}

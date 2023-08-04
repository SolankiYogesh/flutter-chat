import 'package:flutter/material.dart';
import 'package:folder_stucture/Helpers/Color.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onPress,
      required this.title,
      this.isDisabled = false})
      : super(key: key);

  final void Function() onPress;
  final String title;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled! ? () => {} : onPress,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(ColorProvider.PrimaryColor),
                const Color(ColorProvider.PrimaryColor).withAlpha(9),
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}

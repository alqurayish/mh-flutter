import '../utils/exports.dart';

class CustomLoader {
  static Future show(
    BuildContext context,
  ) {
    hide;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static hide(BuildContext context) {
    if(!(ModalRoute.of(context)?.isCurrent ?? false)) {
      Navigator.of(context).pop();
    }
  }
}

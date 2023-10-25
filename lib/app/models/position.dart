import 'dropdown_item.dart';

class Position extends DropdownItem {
  final String? logo;

  Position({
    required String super.id,
    required String super.name,
    bool active = true,
    required this.logo,
  }) : super(
          active: active,
        );
}

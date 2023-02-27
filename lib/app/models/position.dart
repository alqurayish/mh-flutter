import 'dropdown_item.dart';

class Position extends DropdownItem {
  final String? logo;

  Position({
    required String id,
    required String name,
    active = true,
    required this.logo,
  }) : super(
          id: id,
          name: name,
          active: active,
        );
}

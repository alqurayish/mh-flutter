import 'dart:convert';

class DropdownItem {
  DropdownItem({
    this.id,
    this.name,
    this.active = true,
  });

  final String? id;
  final String? name;
  final bool? active;

  factory DropdownItem.fromRawJson(String str) =>
      DropdownItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DropdownItem.fromJson(Map<String, dynamic> json) => DropdownItem(
    id: json["_id"],
    name: json["name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "active": active,
  };
}
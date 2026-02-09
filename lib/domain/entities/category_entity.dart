import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final String name;
  final int iconCode;
  final String colorHex;

  const CategoryEntity({
    this.id,
    required this.name,
    required this.iconCode,
    required this.colorHex,
  });

  CategoryEntity copyWith({
    int? id,
    String? name,
    int? iconCode,
    String? colorHex,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  @override
  List<Object?> get props => [id, name, iconCode, colorHex];
}

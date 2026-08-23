class DropdownItemModel {
  const DropdownItemModel({
    this.id,
    required this.name,
    required this.mainCatagoriesName,
    this.mainCatagoriesId,
  });
  final String? id;
  final String name;
  final String mainCatagoriesName;
  final String? mainCatagoriesId;
}

class DropdownMultipleTreeModel {
  const DropdownMultipleTreeModel({
    this.id,
    required this.name,
    this.subItems,
  });
  final String? id;
  final String name;
  final List<DropdownItemModel>? subItems;
}

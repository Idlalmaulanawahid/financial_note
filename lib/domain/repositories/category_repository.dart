import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAllCategories();
  Future<CategoryEntity?> getCategoryById(int id);
  Future<int> insertCategory(CategoryEntity category);
  Future<int> updateCategory(CategoryEntity category);
  Future<int> deleteCategory(int id);
}

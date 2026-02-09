import '../../core/constants/app_constants.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/database_helper.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper _dbHelper;

  CategoryRepositoryImpl(this._dbHelper);

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final db = await _dbHelper.database;
    final maps = await db.query(AppConstants.tableCategories);
    return maps.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<CategoryEntity?> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      AppConstants.tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  @override
  Future<int> insertCategory(CategoryEntity category) async {
    final db = await _dbHelper.database;
    return db.insert(
      AppConstants.tableCategories,
      CategoryModel.fromEntity(category).toMap(),
    );
  }

  @override
  Future<int> updateCategory(CategoryEntity category) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableCategories,
      CategoryModel.fromEntity(category).toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      AppConstants.tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

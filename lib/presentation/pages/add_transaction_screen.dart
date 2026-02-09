import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionEntity? existingTransaction;

  const AddTransactionScreen({super.key, this.existingTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = AppConstants.typeExpense;
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());

    if (isEditing) {
      final t = widget.existingTransaction!;
      _titleController.text = t.title;
      _amountController.text = t.amount.toStringAsFixed(0);
      _noteController.text = t.note ?? '';
      _type = t.type;
      _selectedCategoryId = t.categoryId;
      _selectedDate = t.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaksi' : 'Tambah Transaksi'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildNoteField(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = AppConstants.typeExpense),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _type == AppConstants.typeExpense
                      ? AppTheme.roseRed.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: _type == AppConstants.typeExpense
                      ? Border.all(color: AppTheme.roseRed, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Pengeluaran',
                    style: TextStyle(
                      color: _type == AppConstants.typeExpense
                          ? AppTheme.roseRed
                          : AppColors.of(context).textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = AppConstants.typeIncome),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _type == AppConstants.typeIncome
                      ? AppTheme.emeraldGreen.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: _type == AppConstants.typeIncome
                      ? Border.all(color: AppTheme.emeraldGreen, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Pemasukan',
                    style: TextStyle(
                      color: _type == AppConstants.typeIncome
                          ? AppTheme.emeraldGreen
                          : AppColors.of(context).textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: TextStyle(color: AppColors.of(context).textPrimary),
      decoration: InputDecoration(
        labelText: 'Judul',
        prefixIcon: Icon(
          Icons.edit,
          color: AppColors.of(context).textSecondary,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Judul tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      style: TextStyle(
        color: AppColors.of(context).textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Jumlah',
        prefixIcon: Icon(
          Icons.attach_money,
          color: AppColors.of(context).textSecondary,
        ),
        prefixText: 'Rp ',
        prefixStyle: TextStyle(
          color: _type == AppConstants.typeIncome
              ? AppTheme.emeraldGreen
              : AppTheme.roseRed,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Jumlah tidak boleh kosong';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Masukkan jumlah yang valid';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppTheme.emeraldGreen,
                  surface: AppColors.of(context).surfaceColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Tanggal',
          prefixIcon: Icon(
            Icons.calendar_today,
            color: AppColors.of(context).textSecondary,
          ),
        ),
        child: Text(
          DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate),
          style: TextStyle(color: AppColors.of(context).textPrimary),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<CategoryEntity> categories = [];
        if (state is CategoryLoaded) {
          categories = state.categories;
        }

        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Kategori',
            prefixIcon: Icon(
              Icons.category,
              color: AppColors.of(context).textSecondary,
            ),
          ),
          child: categories.isEmpty
              ? Text(
                  'Memuat...',
                  style: TextStyle(color: AppColors.of(context).textSecondary),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedCategoryId,
                    hint: Text(
                      'Pilih Kategori',
                      style: TextStyle(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                    dropdownColor: AppColors.of(context).cardAltColor,
                    isExpanded: true,
                    items: categories.map((cat) {
                      return DropdownMenuItem<int>(
                        value: cat.id,
                        child: Row(
                          children: [
                            Icon(
                              IconData(
                                cat.iconCode,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: Color(
                                int.parse('FF${cat.colorHex}', radix: 16),
                              ),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              cat.name,
                              style: TextStyle(
                                color: AppColors.of(context).textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      style: TextStyle(color: AppColors.of(context).textPrimary),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Catatan (opsional)',
        prefixIcon: Icon(
          Icons.note,
          color: AppColors.of(context).textSecondary,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSubmitButton() {
    final color = _type == AppConstants.typeIncome
        ? AppTheme.emeraldGreen
        : AppTheme.roseRed;

    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          isEditing ? 'Simpan Perubahan' : 'Tambah Transaksi',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori terlebih dahulu'),
          backgroundColor: AppTheme.roseRed,
        ),
      );
      return;
    }

    final transaction = TransactionEntity(
      id: widget.existingTransaction?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      categoryId: _selectedCategoryId!,
      type: _type,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (isEditing) {
      context.read<TransactionBloc>().add(UpdateTransaction(transaction));
    } else {
      context.read<TransactionBloc>().add(AddTransaction(transaction));
    }

    context.read<DashboardBloc>().add(RefreshDashboard());
    Navigator.of(context).pop();
  }
}

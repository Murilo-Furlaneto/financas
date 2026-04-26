import 'dart:developer';
import 'package:financas/core/enum/enum_month.dart';
import 'package:financas/core/enum/enum_categories.dart';
import 'package:financas/core/entities/day_entity.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:financas/features/home/presentation/widgets/bar_chart_widget.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_cubit.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MonthlyExpensesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MonthlyExpensesCubit>();
    cubit.loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showAddAccountDialog(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: BlocBuilder<MonthlyExpensesCubit, MonthlyExpensesState>(
        builder: (context, state) {
          if (state is MonthlyExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MonthlyExpensesError) {
            return Center(child: Text(state.message));
          } else if (state is MonthlyExpensesLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeaderCard(state.totalAmount),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Resumo semanal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BarChartWidget(
                      days: _calculateWeeklySummary(state.expenses),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Últimas despesas',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final expense = state.expenses[index];
                      return _buildTransactionCard(expense);
                    },
                    childCount: state.expenses.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          }
          return const Center(
            child: Text('Não há despesas cadastradas.'),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(double amount) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gasto Total de ${EnumMonth.nameActualMonth()}',
              style: Theme.of(context).colorScheme.onPrimaryContainer != null
                  ? TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(MonthlyExpenses expense) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      onDismissed: (direction) {
        context.read<MonthlyExpensesCubit>().deleteExpense(expense.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Text(
              expense.title.isNotEmpty ? expense.title[0].toUpperCase() : '?',
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
          title: Text(
            expense.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Vence dia ${expense.dueDate}'),
          trailing: Text(
            '- R\$ ${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  List<Day> _calculateWeeklySummary(List<MonthlyExpenses> expenses) {
    Map<int, double> weeklySummary = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    final now = DateTime.now();
    for (var expense in expenses) {
      try {
        final expenseDate = DateTime(now.year, now.month, expense.dueDate);
        weeklySummary[expenseDate.weekday] = (weeklySummary[expenseDate.weekday] ?? 0) + expense.amount;
      } catch (_) {}
    }
    return [
      Day(id: 'Seg', valor: weeklySummary[1]!),
      Day(id: 'Ter', valor: weeklySummary[2]!),
      Day(id: 'Qua', valor: weeklySummary[3]!),
      Day(id: 'Qui', valor: weeklySummary[4]!),
      Day(id: 'Sex', valor: weeklySummary[5]!),
      Day(id: 'Sab', valor: weeklySummary[6]!),
      Day(id: 'Dom', valor: weeklySummary[7]!),
    ];
  }

  void showAddAccountDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    Categories? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nova Despesa', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Dia (1-31)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixText: 'R\$ ',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Categories>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: Categories.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        dateController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedCategory != null) {
                      context.read<MonthlyExpensesCubit>().addExpense(
                            MonthlyExpenses(
                              id: const Uuid().v4(),
                              title: nameController.text,
                              category: selectedCategory!,
                              amount: double.parse(amountController.text),
                              dueDate: int.parse(dateController.text),
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Salvar Despesa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

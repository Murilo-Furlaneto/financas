import 'dart:developer';

import 'package:financas/core/enum/enum_month.dart';
import 'package:financas/core/enum/enum_categories.dart';
import 'package:financas/domain/entities/day/day_entity.dart';
import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';
import 'package:financas/ui/home/widgets/bar_chart_widget.dart';
import 'package:financas/ui/monthly_expenses/cubit/monthly_expenses_cubit.dart';
import 'package:financas/ui/monthly_expenses/cubit/monthly_expenses_state.dart';
import 'package:financas/ui/user/page/profile_page.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const Icon(
            Icons.account_circle,
            size: 30,
          ),
        ),
        title: const Text('Minhas despesas'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showAddAccountDialog(context),
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MonthlyExpensesCubit, MonthlyExpensesState>(
          builder: (context, state) {
            if (state is MonthlyExpensesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MonthlyExpensesError) {
              return Center(child: Text(state.message));
            } else if (state is MonthlyExpensesLoaded) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          text: 'Gastos de ${EnumMonth.nameActualMonth()}:',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' R\$ ${state.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        MonthlyExpenses expenses = state.expenses[index];
                        return Dismissible(
                          key: Key(expenses.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            context
                                .read<MonthlyExpensesCubit>()
                                .deleteExpense(expenses.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${expenses.title} excluída')),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(expenses.title[0]),
                            ),
                            title: Text(
                              expenses.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Vencimento: ${expenses.dueDate}'),
                            trailing: Text(
                              'R\$ ${expenses.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                 const Text(
                    'Resumo semanal',
                    style: TextStyle(fontSize: 20),
                  ),
                  BarChartWidget(
                    days: _calculateWeeklySummary(state.expenses),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Não há despesas cadastradas.'),
            );
          },
        ),
      ),
    );
  }

  List<Day> _calculateWeeklySummary(List<MonthlyExpenses> expenses) {
    Map<int, double> weeklySummary = {
      1: 0.0,
      2: 0.0,
      3: 0.0,
      4: 0.0,
      5: 0.0,
      6: 0.0,
      7: 0.0,
    };

    final now = DateTime.now();
    for (var expense in expenses) {
      try {
        final expenseDate = DateTime(now.year, now.month, expense.createdAt);
        final weekday = expenseDate.weekday;
        weeklySummary[weekday] = (weeklySummary[weekday] ?? 0) + expense.amount;
      } catch (e) {
          log('Invalid date for expense "${expense.title}": ${expense.createdAt}');
      }
    }

    return [
      Day(id: 'Seg', valor: weeklySummary[2]!),
      Day(id: 'Ter', valor: weeklySummary[3]!),
      Day(id: 'Qua', valor: weeklySummary[4]!),
      Day(id: 'Qui', valor: weeklySummary[5]!),
      Day(id: 'Sex', valor: weeklySummary[6]!),
      Day(id: 'Sab', valor: weeklySummary[7]!),
      Day(id: 'Dom', valor: weeklySummary[1]!),
    ];
  }

  void showAddAccountDialog(BuildContext context) {
    final TextEditingController accountNameController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    Categories? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Adicionar Conta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: accountNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da conta',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    controller: dueDateController,
                    decoration: const InputDecoration(
                      labelText: 'Dia do Vencimento',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                    ),
                  ),
                 const SizedBox(height: 5,),
                  DropdownButton<Categories>(
                    value: selectedCategory,
                    hint: const Text('Selecione uma categoria'),
                    isExpanded: true,
                    items: Categories.values.map((e) {
                      return DropdownMenuItem<Categories>(
                        value: e,
                        child: Text(e.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    String accountName = accountNameController.text;
                    int? dueDate = int.tryParse(dueDateController.text);
                    double? amount = double.tryParse(amountController.text);

                    if (dueDate != null &&
                        dueDate >= 1 &&
                        dueDate <= 31 &&
                        amount != null &&
                        accountName.isNotEmpty &&
                        selectedCategory != null) {
                      context.read<MonthlyExpensesCubit>().addExpense(
                            MonthlyExpenses(
                              id: const Uuid().v4(),
                              title: accountName,
                              category: selectedCategory!,
                              amount: amount,
                              dueDate: dueDate,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                            ),
                          );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, insira valores válidos'),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:financas/shared/enum/enum_categories.dart';
import 'package:financas/ui/charts/cubit/charts_cubit.dart';
import 'package:financas/ui/charts/cubit/charts_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChartsCubit>().loadChartData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos'),
      ),
      body: BlocBuilder<ChartsCubit, ChartsState>(
        builder: (context, state) {
          if (state is ChartsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChartsError) {
            return Center(child: Text(state.message));
          }
          if (state is ChartsLoaded) {
            final sortedExpenses = List.from(state.expenses)
              ..sort((a, b) => b.amount.compareTo(a.amount));

            return Column(
              children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildMonthFilter(context, state),
                    _buildYearFilter(context, state),
                   // _buildCategoryFilter(context, state),
                  ],
                ),
              ),
                // Chart
                if (state.expenses.isEmpty)
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('Sem dados para exibir no gráfico.'),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _generatePieChartSections(state.expensesByCategory),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                // "What you spent the most on" list
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 8.0),
                  child: Text(
                    'Maiores despesas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = sortedExpenses[index];
                      final category = Categories.values.firstWhere(
                        (e) => e.label == expense.category.label,
                        orElse: () => Categories.other,
                      );
                      return ListTile(
                        title: Text(expense.title,style:const TextStyle(fontSize: 16.0),),
                        subtitle: Text(category.label, style: const TextStyle(fontSize: 16.0),),
                        trailing: Text(
                          'R\$ ${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Sem dados para exibir'));
        },
      ),
    );
  }

  Widget _buildMonthFilter(BuildContext context, ChartsLoaded state) {
    return DropdownButton<int>(
      value: state.selectedMonth,
      items: List.generate(12, (index) {
        return DropdownMenuItem(
          value: index + 1,
          child: Text(
            _getMonthName(index + 1),
          ),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          context.read<ChartsCubit>().loadChartData(
                month: value,
                year: state.selectedYear,
                category: state.selectedCategory,
              );
        }
      },
    );
  }

  Widget _buildYearFilter(BuildContext context, ChartsLoaded state) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear - index);

    return DropdownButton<int>(
      value: state.selectedYear,
      items: years.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<ChartsCubit>().loadChartData(
                month: state.selectedMonth,
                year: value,
                category: state.selectedCategory,
              );
        }
      },
    );
  }



  List<PieChartSectionData> _generatePieChartSections(Map<String, double> expensesByCategory) {
    return expensesByCategory.entries.map((entry) {
      final category = Categories.values.firstWhere((e) => e.label == entry.key, orElse: () => Categories.other);
      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: entry.value,
        title: entry.value.toStringAsFixed(2),
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }


  Color _getCategoryColor(Categories category) {
    switch (category) {
      case Categories.transport:
        return Colors.blue;
      case Categories.food:
        return Colors.red;
      case Categories.health:
        return Colors.green;
      case Categories.housing:
        return Colors.orange;
      case Categories.entertainment:
        return Colors.purple;
      case Categories.education:
        return Colors.yellow;
      case Categories.utilities:
        return Colors.cyan;
      case Categories.shopping:
        return Colors.pink;
      case Categories.travel:
        return Colors.teal;
      case Categories.investments:
        return Colors.indigo;
      case Categories.savings:
        return Colors.lightGreen;
      case Categories.other:
        return Colors.grey;
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return monthNames[month - 1];
  }
}
import 'package:financas/core/enum/enum_month.dart';
import 'package:financas/features/charts/presentation/cubit/charts_cubit.dart';
import 'package:financas/features/charts/presentation/cubit/charts_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ChartsCubit>().loadChartData(
          month: selectedMonth,
          year: selectedYear,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Gastos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          Expanded(
            child: BlocBuilder<ChartsCubit, ChartsState>(
              builder: (context, state) {
                if (state is ChartsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChartsError) {
                  return Center(child: Text(state.message));
                }
                if (state is ChartsLoaded) {
                  if (state.expensesByCategory.isEmpty) {
                    return const Center(child: Text('Nenhum dado para este período.'));
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDonutChart(state.expensesByCategory),
                        const SizedBox(height: 32),
                        _buildCategoryList(state.expensesByCategory),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final monthIndex = index + 1;
          final isSelected = selectedMonth == monthIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              selected: isSelected,
              label: Text(EnumMonth.fromInt(monthIndex).nome),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedMonth = monthIndex;
                  });
                  _loadData();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDonutChart(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, item) => sum + item);
    
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 70,
              sections: data.entries.map((entry) {
                final index = data.keys.toList().indexOf(entry.key);
                return PieChartSectionData(
                  color: Colors.primaries[index % Colors.primaries.length],
                  value: entry.value,
                  title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(Map<String, double> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorias',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...data.entries.map((entry) {
          final index = data.keys.toList().indexOf(entry.key);
          final color = Colors.primaries[index % Colors.primaries.length];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(entry.key),
              trailing: Text(
                'R\$ ${entry.value.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

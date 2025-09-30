import 'package:financas/core/helpers/enum/enum_month.dart';

class UtilsService {
  String returnMonth(int mes) {
    if (mes < 1 || mes > 12) {
      throw Exception('Esse mês não existe');
    } else {
      return EnumMonth.values[mes - 1].toString().split('.').last;
    }
  }
}

import 'package:financas/core/utils/utils_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('teste da função que retorne o mes atual', () async {
    final UtilsService utilsService = UtilsService();

    String mes = utilsService.returnMonth(DateTime.now().month);

    expect(mes, equals('Novembro'));
  });
}

enum EnumMonth {
  janeiro('Janeiro'),
  fevereiro('Fevereiro'),
  marco('Março'),
  abril('Abril'),
  maio('Maio'),
  junho('Junho'),
  julho('Julho'),
  agosto('Agosto'),
  setembro('Setembro'),
  outubro('Outubro'),
  novembro('Novembro'),
  dezembro('Dezembro');

  final String nome;

  const EnumMonth(this.nome);

  static EnumMonth fromDateTime(DateTime date) {
    return EnumMonth.values[date.month - 1];
  }

  static String nameActualMonth() {
    return fromDateTime(DateTime.now()).nome;
  }
}
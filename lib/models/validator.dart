class Validator {
  final String name;
  final String commission;
  final String uptime;
  final bool selected;

  const Validator({
    required this.name,
    required this.commission,
    required this.uptime,
    required this.selected,
  });

  Validator copyWith({bool? selected}) {
    return Validator(
      name: name,
      commission: commission,
      uptime: uptime,
      selected: selected ?? this.selected,
    );
  }
}

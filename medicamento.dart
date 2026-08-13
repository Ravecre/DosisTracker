class Medicamento {
  final String id;
  final String nombre;
  final String? codigoBarras;
  int stockPastillas; // Pastillas que quedan en la caja actual
  int numeroCajas;     // Cajas completas almacenadas
  final String? perfil; // Para saber de quién es (ej. "Mamá", "Mi perfil")
  
  // Opciones de toma
  final bool esSegunNecesidad; // Si es true, no tiene horario fijo
  final int? intervaloHoras;   // Ej. Cada 8 horas
  DateTime? ultimaToma;        // Para recalcular la siguiente hora
  
  // Información adicional
  final String? observaciones;
  final String? efectosAdversos;

  Medicamento({
    required this.id,
    required this.nombre,
    this.codigoBarras,
    required this.stockPastillas,
    this.numeroCajas = 1,
    this.perfil = 'Principal',
    this.esSegunNecesidad = false,
    this.intervaloHoras,
    this.ultimaToma,
    this.observaciones,
    this.efectosAdversos,
  });

  // Lógica para saber si hay que lanzar avisos de stock
  bool requiereAvisoCincoPastillas() {
    return stockPastillas <= 5 && stockPastillas > 3 && numeroCajas == 0;
  }

  bool requiereAvisoTresPastillas() {
    return stockPastillas <= 3 && stockPastillas > 1 && numeroCajas == 0;
  }

  bool esUltimaPastilla() {
    return stockPastillas == 1 && numeroCajas == 0;
  }
}

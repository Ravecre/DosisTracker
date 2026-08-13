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

  // Función para registrar la toma y actualizar inventario
  void registrarToma() {
    ultimaToma = DateTime.now();

    if (stockPastillas > 0) {
      stockPastillas--;
    }

    // Si se acaba la caja actual pero quedan cajas guardadas, abrir una nueva
    if (stockPastillas == 0 && numeroCajas > 0) {
      numeroCajas--;
      // Asumimos un tamaño de caja estándar por defecto o mantenemos 20
      stockPastillas = 20; 
    }
  }

  // Calcular la hora de la próxima toma
  DateTime? obtenerProximaToma() {
    if (esSegunNecesidad || intervaloHoras == null || ultimaToma == null) {
      return null;
    }
    return ultimaToma!.add(Duration(hours: intervaloHoras!));
  }

  bool esUltimaPastilla() {
    return stockPastillas == 1 && numeroCajas == 0;
  }
}

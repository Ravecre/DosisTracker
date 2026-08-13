import 'package:flutter/material.dart';
import 'services/notification_service.dart'

void main() async {
  // Asegura que las configuraciones nativas estén listas
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Inicializa las notificaciones
  await NotificationService.init(); 

  runApp(const DosisTrackerApp());
}

// 1. MODELO DE DATOS (Medicamento)

class Medicamento {
  final String id;
  final String nombre;
  final String? codigoBarras;
  int stockPastillas; // Pastillas que quedan en la caja actual
  int numeroCajas;     // Cajas completas almacenadas
  final String? perfil; // Ej. "Principal", "Mamá", etc.
  
  // Opciones de horario y frecuencia
  final bool esSegunNecesidad; // Si es true, no requiere horario fijo
  final int? intervaloHoras;   // Ej. Cada 8 horas
  DateTime? ultimaToma;        // Registra la fecha y hora de la última toma
  
  // Notas e información médica
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

  // Métodos de control de stock y alertas
  bool requiereAvisoCincoPastillas() {
    return stockPastillas <= 5 && stockPastillas > 3 && numeroCajas == 0;
  }

  bool requiereAvisoTresPastillas() {
    return stockPastillas <= 3 && stockPastillas > 1 && numeroCajas == 0;
  }

  bool esUltimaPastilla() {
    return stockPastillas == 1 && numeroCajas == 0;
  }

  // Registra la toma, descuenta stock y usa cajas nuevas si se acaba la actual
  void registrarToma() {
    ultimaToma = DateTime.now();

    if (stockPastillas > 0) {
      stockPastillas--;
    }

    // Si se agota la caja actual pero quedan cajas en el inventario
    if (stockPastillas == 0 && numeroCajas > 0) {
      numeroCajas--;
      stockPastillas = 20; // Reemplaza por una caja estándar de 20 unidades
    }
  }
}


// 2. CONFIGURACIÓN PRINCIPAL DE LA APP

class DosisTrackerApp extends StatelessWidget {
  const DosisTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DosisTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF), // Azul médico
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


// 3. PANTALLA PRINCIPAL (Lista de Medicamentos)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista inicial de prueba
  final List<Medicamento> _misMedicamentos = [
    Medicamento(
      id: '1',
      nombre: 'Ibuprofeno 600mg',
      stockPastillas: 5,
      numeroCajas: 0,
      intervaloHoras: 8,
      observaciones: 'Tomar después de las comidas',
    ),
  ];

  void _abrirFormularioAgregar() async {
    final nuevoMed = await Navigator.of(context).push<Medicamento>(
      MaterialPageRoute(
        builder: (context) => const AgregarMedicamentoScreen(),
      ),
    );

    if (nuevoMed != null) {
      setState(() {
        _misMedicamentos.add(nuevoMed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DosisTracker 💊'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _misMedicamentos.isEmpty
          ? const Center(
              child: Text(
                'No tienes medicamentos registrados.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _misMedicamentos.length,
              itemBuilder: (context, index) {
                final med = _misMedicamentos[index];

                // Determinar el mensaje de advertencia según el stock restante
                String? mensajeAlerta;
                Color colorAlerta = Colors.black;

                if (med.esUltimaPastilla()) {
                  mensajeAlerta = '⚠️ ¡Última pastilla del stock total!';
                  colorAlerta = Colors.red;
                } else if (med.requiereAvisoTresPastillas()) {
                  mensajeAlerta = '⚠️ Quedan solo 3 pastillas';
                  colorAlerta = Colors.orange;
                } else if (med.requiereAvisoCincoPastillas()) {
                  mensajeAlerta = '⚠️ Quedan 5 pastillas';
                  colorAlerta = Colors.amber.shade800;
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE3F2FD),
                            child: Icon(Icons.medication, color: Color(0xFF0066FF)),
                          ),
                          title: Text(
                            med.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                med.esSegunNecesidad
                                    ? 'Frecuencia: Según necesidad (PRN)'
                                    : 'Frecuencia: Cada ${med.intervaloHoras} horas',
                              ),
                              Text(
                                'Stock: ${med.stockPastillas} pastillas (${med.numeroCajas} caja/s)',
                              ),
                              if (med.ultimaToma != null)
                                Text(
                                  'Última toma: ${med.ultimaToma!.hour.toString().padLeft(2, '0')}:${med.ultimaToma!.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              if (mensajeAlerta != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  mensajeAlerta,
                                  style: TextStyle(
                                    color: colorAlerta,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (med.stockPastillas == 0 && med.numeroCajas == 0)
                              TextButton.icon(
                                onPressed: () {
                                  // Función para archivar o finalizar tratamiento
                                },
                                icon: const Icon(Icons.check_circle_outline, color: Colors.grey),
                                label: const Text(
                                  'Finalizar tratamiento',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    med.registrarToma();
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Toma registrada para ${med.nombre}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0066FF),
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text('Tomar dosis'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormularioAgregar,
        icon: const Icon(Icons.add),
        label: const Text('Añadir medicina'),
      ),
    );
  }
}


// 4. PANTALLA FORMULARIO (Agregar Medicamento)

class AgregarMedicamentoScreen extends StatefulWidget {
  const AgregarMedicamentoScreen({super.key});

  @override
  State<AgregarMedicamentoScreen> createState() => _AgregarMedicamentoScreenState();
}

class _AgregarMedicamentoScreenState extends State<AgregarMedicamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  int _stockPastillas = 20;
  int _numeroCajas = 1;
  bool _esSegunNecesidad = false;
  int _intervaloHoras = 8;
  String _observaciones = '';

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final nuevoMedicamento = Medicamento(
        id: DateTime.now().toString(),
        nombre: _nombre,
        stockPastillas: _stockPastillas,
        numeroCajas: _numeroCajas,
        esSegunNecesidad: _esSegunNecesidad,
        intervaloHoras: _esSegunNecesidad ? null : _intervaloHoras,
        observaciones: _observaciones.isEmpty ? null : _observaciones,
      );

      Navigator.of(context).pop(nuevoMedicamento);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del medicamento',
                  hintText: 'Ej. Paracetamol 1g',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: (value)


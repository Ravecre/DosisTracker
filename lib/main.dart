import 'package:flutter/material.dart';
import 'models/medicamento.dart';

void main() {
  runApp(const DosisTrackerApp());
}

class DosisTrackerApp extends StatelessWidget {
  const DosisTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DosisTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista donde guardaremos temporalmente los medicamentos
  final List<Medicamento> _misMedicamentos = [
    Medicamento(
      id: '1',
      nombre: 'Ibuprofeno 600mg',
      stockPastillas: 4, // Hará saltar el aviso de <= 5
      numeroCajas: 0,
      intervaloHoras: 8,
      observaciones: 'Tomar después de comer',
    ),
  ];

  void _agregarMedicamentoEjemplo() {
    setState(() {
      _misMedicamentos.add(
        Medicamento(
          id: DateTime.now().toString(),
          nombre: 'Paracetamol 1g',
          stockPastillas: 20,
          numeroCajas: 1,
          esSegunNecesidad: true,
        ),
      );
    });
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
                
                // Determinamos si hay alerta de stock
                String? mensajeAlerta;
                Color colorAlerta = Colors.black;

                if (med.esUltimaPastilla()) {
                  mensajeAlerta = '⚠️ ¡Última pastilla!';
                  colorAlerta = Colors.red;
                } else if (med.requiereAvisoTresPastillas()) {
                  mensajeAlerta = '⚠️ Quedan 3 pastillas';
                  colorAlerta = Colors.orange;
                } else if (med.requiereAvisoCincoPastillas()) {
                  mensajeAlerta = '⚠️ Quedan 5 pastillas';
                  colorAlerta = Colors.amber.shade800;
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(Icons.medication, color: Color(0xFF0066FF)),
                    ),
                    title: Text(
                      med.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.esSegunNecesidad
                              ? 'Toma: Según necesidad'
                              : 'Cada ${med.intervaloHoras} horas',
                        ),
                        Text('Stock: ${med.stockPastillas} pastillas (${med.numeroCajas} caja/s)'),
                        if (mensajeAlerta != null)
                          Text(
                            mensajeAlerta,
                            style: TextStyle(
                              color: colorAlerta,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarMedicamentoEjemplo,
        icon: const Icon(Icons.add),
        label: const Text('Añadir medicina'),
      ),
    );
  }
}

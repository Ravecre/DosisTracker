import 'package:flutter/material.dart';
import '../models/medicamento.dart';

class AgregarMedicamentoScreen extends StatefulWidget {
  const AgregarMedicamentoScreen({super.key});

  @override
  State<AgregarMedicamentoScreen> createState() => _AgregarMedicamentoScreenState();
}

class _AgregarMedicamentoScreenState extends State<AgregarMedicamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  String _nombre = '';
  int _stockPastillas = 20;
  int _numeroCajas = 1;
  bool _esSegunNecesidad = false;
  int _intervaloHoras = 8;
  String _observaciones = '';

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Creamos el nuevo medicamento con los datos del usuario
      final nuevoMedicamento = Medicamento(
        id: DateTime.now().toString(),
        nombre: _nombre,
        stockPastillas: _stockPastillas,
        numeroCajas: _numeroCajas,
        esSegunNecesidad: _esSegunNecesidad,
        intervaloHoras: _esSegunNecesidad ? null : _intervaloHoras,
        observaciones: _observaciones.isEmpty ? null : _observaciones,
      );

      // Devolvemos el medicamento a la pantalla anterior
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
              // 1. Nombre del medicamento
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del medicamento',
                  hintText: 'Ej. Ibuprofeno 600mg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, escribe un nombre';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!.trim(),
              ),
              const SizedBox(height: 16),

              // 2. Inventario (Stock y Cajas)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '20',
                      decoration: const InputDecoration(
                        labelText: 'Pastillas en caja',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _stockPastillas = int.parse(value ?? '0'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: '1',
                      decoration: const InputDecoration(
                        labelText: 'Nº Cajas',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _numeroCajas = int.parse(value ?? '1'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Casilla "Según necesidad"
              SwitchListTile(
                title: const Text('Tomar según necesidad (PRN)'),
                subtitle: const Text('Sin horario fijo ni alarmas automáticas'),
                value: _esSegunNecesidad,
                onChanged: (val) {
                  setState(() {
                    _esSegunNecesidad = val;
                  });
                },
              ),
              const SizedBox(height: 8),

              // 4. Intervalo de horas (Si no es según necesidad)
              if (!_esSegunNecesidad)
                TextFormField(
                  initialValue: '8',
                  decoration: const InputDecoration(
                    labelText: 'Frecuencia (Cada X horas)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.alarm),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _intervaloHoras = int.parse(value ?? '8'),
                ),
              const SizedBox(height: 16),

              // 5. Observaciones o Notas
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Observaciones / Notas',
                  hintText: 'Ej. Tomar con las comidas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 2,
                onSaved: (value) => _observaciones = value ?? '',
              ),
              const SizedBox(height: 24),

              // Botón de Guardar
              ElevatedButton.icon(
                onPressed: _guardarFormulario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF0066FF),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar Medicamento', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

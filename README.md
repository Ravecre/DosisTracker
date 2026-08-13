# DosisTracker (Open Source)

App móvil de código abierto para iOS y Android creada con Flutter. Diseñada para gestionar de forma sencilla, 100% privada y local la medicación, el inventario de cajas y las tomas diarias.

---

##✨ Características Principales

* ** 100% Offline y Privada:** Todos los datos se guardan en el propio dispositivo. Cero servidores, cero rastreo.
* ** Control Inteligente de Stock:**
  * Registro por número de cajas y pastillas por caja.
  * Avisos escalonados al quedar **5 pastillas**, **3 pastillas** y el **día de la última pastilla del stock total**.
  * Opción protegida para **Finalizar tratamiento**.
* ** Horarios Dinámicos y Alertas Críticas:**
  * Configuración para tomas fijas, días alternos, cada X horas/días o modo **"Según necesidad"** (sin horario fijo).
  * **Recálculo automático:** Si retrasas una toma, el horario de la siguiente dosis se recalcula automáticamente desde la hora real.
  * Notificaciones en modo *Alertas Críticas* (suenan aunque el dispositivo esté en silencio o en modo *No Molestar*).  
* ** Múltiples Perfiles:** Gestión independiente para ti, familiares o mascotas.
* ** Integración CIMA (AEMPS):** Consulta de la base de datos oficial de España para obtener información de medicamentos y el prospecto oficial en PDF.
* ** Exportación:** Generación de informes en PDF, CSV y JSON.

---

## 🛠️ Tecnologías Utilizadas
* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Base de datos local:** SQLite / Hive
* **API Externa (solo lectura pública):** CIMA (AEMPS)
* **Plataforma objetivo inicial:** iOS (iPhone)

---

## 🚀 Cómo Ejecutar el Proyecto Localmente

### Requisitos previos
* Tener instalado [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Xcode (para simular o compilar en iOS)

### Pasos
1. Clona este repositorio:
   ```bash
   git clone [https://github.com/ravecre/dosis-tracker.git](https://github.com/ravecre/dosis-tracker.git)

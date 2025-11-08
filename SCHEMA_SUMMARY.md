# Resumen Rápido del Schema de Dataverse

## 📊 Estadísticas Generales

- **Total de Tablas:** 22
- **Total de Vistas:** 5
- **Total de Stored Procedures:** 2
- **Total de Triggers:** 2
- **Módulos:** 6

---

## 📁 Módulos del Sistema

### 1️⃣ **Módulo CRM** (2 tablas)
- `Customers` - Clientes y turistas
- `CustomerInteractions` - Historial de interacciones

### 2️⃣ **Módulo de Reservaciones** (4 tablas)
- `Bookings` - Reservaciones principales
- `BookingDetails` - Detalles de cada viaje
- `Passengers` - Información de pasajeros
- `VehicleAssignments` - Asignación de vehículos/conductores

### 3️⃣ **Módulo de Administración** (6 tablas)
- `Vehicles` - Catálogo de vehículos
- `Drivers` - Información de conductores
- `Routes` - Rutas predefinidas
- `TravelPackages` - Paquetes de viaje
- `Destinations` - Destinos turísticos
- `VehicleAssignments` - Gestión de asignaciones

### 4️⃣ **Módulo de Contabilidad** (5 tablas)
- `Invoices` - Facturas
- `InvoiceLineItems` - Detalles de facturas
- `Payments` - Pagos recibidos
- `Expenses` - Gastos operativos
- `PromoCodes` - Códigos promocionales

### 5️⃣ **Módulo de Comunicación** (3 tablas)
- `Notifications` - Notificaciones automáticas
- `Reviews` - Reseñas y calificaciones
- `SupportTickets` - Tickets de soporte

### 6️⃣ **Módulo de Usuarios** (2 tablas)
- `Users` - Usuarios del sistema
- `AuditLog` - Registro de auditoría

---

## 🔗 Relaciones Principales

```
Customer (1) ──→ (N) Bookings
Booking (1) ──→ (N) BookingDetails
Booking (1) ──→ (N) Passengers
Booking (1) ──→ (1) VehicleAssignment
Booking (1) ──→ (N) Invoices
Booking (1) ──→ (N) Payments
Invoice (1) ──→ (N) InvoiceLineItems
Vehicle (1) ──→ (N) VehicleAssignments
Driver (1) ──→ (N) VehicleAssignments
Route (1) ──→ (N) BookingDetails
Package (1) ──→ (N) BookingDetails
```

---

## 📈 Vistas SQL Disponibles

1. **vw_ActiveBookings** - Reservaciones activas con toda la información
2. **vw_RevenueReport** - Reporte de ingresos por mes
3. **vw_VehicleUtilization** - Utilización de vehículos
4. **vw_CustomerLoyalty** - Análisis de clientes leales
5. **vw_PendingPayments** - Pagos pendientes y facturas vencidas

---

## 🛠️ Procedimientos Almacenados

1. **sp_CreateBooking** - Crear nueva reservación
2. **sp_ProcessPayment** - Procesar pago y actualizar estados

---

## 🔐 Seguridad

### Campos Sensibles (Requieren Encriptación):
- `Customers.PassportNumber`
- `Payments.CardLast4Digits`
- `Payments.TransactionID`

### Roles Recomendados:
- **Admin** - Acceso completo
- **Manager** - Lectura completa, escritura limitada
- **Agent** - Gestión de reservaciones
- **Driver** - Solo sus asignaciones
- **Support** - Gestión de tickets
- **Accounting** - Módulos financieros

---

## 📦 Archivos Incluidos

### 1. `DATAVERSE_SCHEMA_REPORT.md`
Reporte completo y detallado con:
- Definiciones completas de todas las tablas
- Descripción de cada campo
- Tipos de datos y restricciones
- Índices y constraints
- Diagramas ER
- Consideraciones de seguridad
- Plan de implementación

### 2. `dataverse_schema.sql`
Script SQL completo con:
- Definiciones DDL de todas las tablas
- Creación de índices
- Foreign keys y constraints
- 5 vistas útiles
- 2 stored procedures
- 2 triggers
- Datos iniciales de ejemplo

### 3. `SCHEMA_SUMMARY.md`
Este resumen rápido

---

## 🚀 Próximos Pasos

1. **Revisar** el reporte completo en `DATAVERSE_SCHEMA_REPORT.md`
2. **Ejecutar** el script SQL en `dataverse_schema.sql`
3. **Configurar** los roles de seguridad
4. **Implementar** las APIs necesarias
5. **Probar** con datos de ejemplo

---

## 📞 Soporte

Para preguntas o modificaciones al schema, contactar al equipo de desarrollo.

**Última Actualización:** 8 de Noviembre, 2025

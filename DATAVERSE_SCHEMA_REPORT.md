# Reporte de Schema de Dataverse - Sistema de Transporte Turístico NexionExplorTravel

## Resumen Ejecutivo

Este documento presenta el esquema completo de la base de datos Dataverse para el sistema de transporte turístico y viajes privados de NexionExplorTravel. El esquema está diseñado para soportar reservaciones, administración y contabilidad según los requisitos especificados.

**Fecha de Creación:** 8 de Noviembre, 2025  
**Versión:** 1.0  
**Plataforma:** Microsoft Dataverse

---

## Tabla de Contenidos
1. [Arquitectura General](#arquitectura-general)
2. [Tablas del Sistema](#tablas-del-sistema)
3. [Relaciones Entre Entidades](#relaciones-entre-entidades)
4. [Índices y Constraints](#índices-y-constraints)
5. [Diagrama de Entidad-Relación](#diagrama-de-entidad-relación)

---

## Arquitectura General

El esquema de Dataverse está organizado en 5 módulos principales:

1. **Módulo de Clientes y CRM** - Gestión de clientes y relaciones
2. **Módulo de Reservaciones** - Sistema de booking y gestión de inventario
3. **Módulo de Administración** - Operaciones y gestión de recursos
4. **Módulo de Contabilidad** - Facturación, pagos y finanzas
5. **Módulo de Catálogo** - Gestión de servicios y destinos

---

## Tablas del Sistema

### 1. MÓDULO DE CLIENTES Y CRM

#### Tabla: `Customers` (Clientes)
**Propósito:** Almacena información de clientes y turistas.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| CustomerID | GUID | Sí | Identificador único del cliente |
| FirstName | String(100) | Sí | Nombre del cliente |
| LastName | String(100) | Sí | Apellido del cliente |
| Email | String(255) | Sí | Correo electrónico (único) |
| PhoneNumber | String(20) | Sí | Número de teléfono |
| DateOfBirth | Date | No | Fecha de nacimiento |
| Nationality | String(50) | No | Nacionalidad |
| PassportNumber | String(50) | No | Número de pasaporte |
| PreferredLanguage | String(10) | No | Idioma preferido (es, en, fr, etc.) |
| PreferredCurrency | String(3) | No | Moneda preferida (USD, EUR, MXN) |
| LoyaltyTier | OptionSet | No | Nivel de lealtad (Bronze, Silver, Gold, Platinum) |
| LoyaltyPoints | Integer | No | Puntos de lealtad acumulados |
| CreatedOn | DateTime | Sí | Fecha de registro |
| ModifiedOn | DateTime | Sí | Última modificación |
| Status | OptionSet | Sí | Estado (Active, Inactive, Blocked) |

**Índices:**
- PK: CustomerID
- UK: Email
- IX: PhoneNumber, LastName

---

#### Tabla: `CustomerInteractions` (Interacciones con Clientes)
**Propósito:** Registro de todas las interacciones con clientes para CRM.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| InteractionID | GUID | Sí | Identificador único de interacción |
| CustomerID | GUID | Sí | FK a Customers |
| InteractionType | OptionSet | Sí | Tipo (Call, Email, Chat, Meeting, Feedback) |
| Subject | String(255) | Sí | Asunto de la interacción |
| Description | Text | No | Descripción detallada |
| InteractionDate | DateTime | Sí | Fecha y hora de la interacción |
| AssignedToUser | GUID | No | Usuario responsable |
| Status | OptionSet | Sí | Estado (Open, In Progress, Closed) |
| CreatedOn | DateTime | Sí | Fecha de creación |

**Índices:**
- PK: InteractionID
- FK: CustomerID
- IX: InteractionDate, AssignedToUser

---

### 2. MÓDULO DE RESERVACIONES

#### Tabla: `Bookings` (Reservaciones)
**Propósito:** Gestiona todas las reservaciones de transporte y viajes.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| BookingID | GUID | Sí | Identificador único de reservación |
| BookingNumber | String(20) | Sí | Número de confirmación único |
| CustomerID | GUID | Sí | FK a Customers |
| BookingDate | DateTime | Sí | Fecha de la reservación |
| TravelDate | Date | Sí | Fecha del viaje |
| TravelTime | Time | No | Hora del viaje |
| TripType | OptionSet | Sí | Tipo (OneWay, RoundTrip, MultiDestination) |
| PassengerCount | Integer | Sí | Número de pasajeros |
| Status | OptionSet | Sí | Estado (Pending, Confirmed, Cancelled, Completed) |
| TotalAmount | Currency | Sí | Monto total |
| CurrencyCode | String(3) | Sí | Código de moneda |
| PaymentStatus | OptionSet | Sí | Estado de pago (Pending, Partial, Paid, Refunded) |
| CancellationReason | Text | No | Razón de cancelación |
| SpecialRequests | Text | No | Solicitudes especiales |
| CreatedOn | DateTime | Sí | Fecha de creación |
| ModifiedOn | DateTime | Sí | Última modificación |
| ConfirmationSentOn | DateTime | No | Fecha de envío de confirmación |

**Índices:**
- PK: BookingID
- UK: BookingNumber
- FK: CustomerID
- IX: TravelDate, Status, BookingDate

---

#### Tabla: `BookingDetails` (Detalles de Reservación)
**Propósito:** Detalles específicos de cada segmento de viaje en una reservación.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| BookingDetailID | GUID | Sí | Identificador único |
| BookingID | GUID | Sí | FK a Bookings |
| VehicleID | GUID | No | FK a Vehicles |
| RouteID | GUID | No | FK a Routes |
| PackageID | GUID | No | FK a TravelPackages |
| OriginLocation | String(255) | Sí | Ubicación de origen |
| DestinationLocation | String(255) | Sí | Ubicación de destino |
| PickupAddress | Text | No | Dirección de recogida |
| DropoffAddress | Text | No | Dirección de entrega |
| PickupDateTime | DateTime | Sí | Fecha/hora de recogida |
| EstimatedArrival | DateTime | No | Llegada estimada |
| ActualArrival | DateTime | No | Llegada real |
| Distance | Decimal(10,2) | No | Distancia en km |
| Duration | Integer | No | Duración en minutos |
| SeatNumbers | String(255) | No | Números de asiento |
| Price | Currency | Sí | Precio de este segmento |

**Índices:**
- PK: BookingDetailID
- FK: BookingID, VehicleID, RouteID, PackageID
- IX: PickupDateTime

---

#### Tabla: `Passengers` (Pasajeros)
**Propósito:** Información de pasajeros en cada reservación.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| PassengerID | GUID | Sí | Identificador único |
| BookingID | GUID | Sí | FK a Bookings |
| FirstName | String(100) | Sí | Nombre |
| LastName | String(100) | Sí | Apellido |
| Age | Integer | No | Edad |
| PassengerType | OptionSet | Sí | Tipo (Adult, Child, Infant, Senior) |
| IdentificationNumber | String(50) | No | Número de identificación |
| SpecialNeeds | Text | No | Necesidades especiales |
| SeatPreference | String(50) | No | Preferencia de asiento |

**Índices:**
- PK: PassengerID
- FK: BookingID

---

### 3. MÓDULO DE ADMINISTRACIÓN

#### Tabla: `Vehicles` (Vehículos)
**Propósito:** Catálogo de vehículos disponibles.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| VehicleID | GUID | Sí | Identificador único |
| VehicleType | OptionSet | Sí | Tipo (Bus, Van, Car, Luxury, SUV) |
| Make | String(50) | Sí | Marca del vehículo |
| Model | String(50) | Sí | Modelo |
| Year | Integer | Sí | Año de fabricación |
| LicensePlate | String(20) | Sí | Placa (única) |
| Capacity | Integer | Sí | Capacidad de pasajeros |
| Color | String(30) | No | Color |
| VIN | String(50) | No | Número de serie |
| Features | Text | No | Características (AC, WiFi, etc.) |
| Status | OptionSet | Sí | Estado (Available, InService, Maintenance, Retired) |
| CurrentLocation | String(255) | No | Ubicación actual |
| LastMaintenanceDate | Date | No | Última fecha de mantenimiento |
| NextMaintenanceDate | Date | No | Próxima fecha de mantenimiento |
| InsurancePolicyNumber | String(50) | No | Número de póliza de seguro |
| InsuranceExpiryDate | Date | No | Fecha de vencimiento del seguro |

**Índices:**
- PK: VehicleID
- UK: LicensePlate
- IX: VehicleType, Status

---

#### Tabla: `Drivers` (Conductores)
**Propósito:** Información de conductores.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| DriverID | GUID | Sí | Identificador único |
| FirstName | String(100) | Sí | Nombre |
| LastName | String(100) | Sí | Apellido |
| Email | String(255) | No | Correo electrónico |
| PhoneNumber | String(20) | Sí | Teléfono |
| LicenseNumber | String(50) | Sí | Número de licencia (único) |
| LicenseType | String(20) | Sí | Tipo de licencia |
| LicenseExpiryDate | Date | Sí | Fecha de vencimiento de licencia |
| DateOfBirth | Date | Sí | Fecha de nacimiento |
| HireDate | Date | Sí | Fecha de contratación |
| Status | OptionSet | Sí | Estado (Active, OnLeave, Suspended, Terminated) |
| Rating | Decimal(3,2) | No | Calificación (0.00-5.00) |
| LanguagesSpoken | String(255) | No | Idiomas hablados |
| EmergencyContact | String(255) | No | Contacto de emergencia |

**Índices:**
- PK: DriverID
- UK: LicenseNumber
- IX: Status, Rating

---

#### Tabla: `VehicleAssignments` (Asignaciones de Vehículos)
**Propósito:** Asignación de vehículos y conductores a reservaciones.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| AssignmentID | GUID | Sí | Identificador único |
| BookingID | GUID | Sí | FK a Bookings |
| VehicleID | GUID | Sí | FK a Vehicles |
| DriverID | GUID | Sí | FK a Drivers |
| AssignmentDate | DateTime | Sí | Fecha de asignación |
| Status | OptionSet | Sí | Estado (Scheduled, InProgress, Completed, Cancelled) |
| StartOdometer | Integer | No | Odómetro inicial |
| EndOdometer | Integer | No | Odómetro final |
| FuelStart | Decimal(5,2) | No | Nivel de combustible inicial |
| FuelEnd | Decimal(5,2) | No | Nivel de combustible final |
| Notes | Text | No | Notas |

**Índices:**
- PK: AssignmentID
- FK: BookingID, VehicleID, DriverID
- IX: AssignmentDate, Status

---

#### Tabla: `Routes` (Rutas)
**Propósito:** Rutas predefinidas del servicio.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| RouteID | GUID | Sí | Identificador único |
| RouteName | String(255) | Sí | Nombre de la ruta |
| RouteCode | String(20) | Sí | Código único de la ruta |
| OriginCity | String(100) | Sí | Ciudad de origen |
| DestinationCity | String(100) | Sí | Ciudad de destino |
| Distance | Decimal(10,2) | Sí | Distancia en km |
| EstimatedDuration | Integer | Sí | Duración estimada en minutos |
| BasePrice | Currency | Sí | Precio base |
| Description | Text | No | Descripción de la ruta |
| IsActive | Boolean | Sí | Ruta activa |
| Stops | Text | No | Paradas intermedias (JSON) |

**Índices:**
- PK: RouteID
- UK: RouteCode
- IX: OriginCity, DestinationCity, IsActive

---

#### Tabla: `TravelPackages` (Paquetes de Viaje)
**Propósito:** Paquetes personalizados y predefinidos.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| PackageID | GUID | Sí | Identificador único |
| PackageName | String(255) | Sí | Nombre del paquete |
| PackageCode | String(20) | Sí | Código único |
| PackageType | OptionSet | Sí | Tipo (Predefined, Custom, Seasonal) |
| Description | Text | Sí | Descripción |
| Duration | Integer | Sí | Duración en días |
| IncludedServices | Text | No | Servicios incluidos (JSON) |
| Destinations | Text | No | Destinos incluidos (JSON) |
| Activities | Text | No | Actividades incluidas (JSON) |
| BasePrice | Currency | Sí | Precio base |
| MaxParticipants | Integer | No | Máximo de participantes |
| IsActive | Boolean | Sí | Paquete activo |
| ValidFrom | Date | No | Válido desde |
| ValidTo | Date | No | Válido hasta |

**Índices:**
- PK: PackageID
- UK: PackageCode
- IX: PackageType, IsActive

---

#### Tabla: `Destinations` (Destinos)
**Propósito:** Catálogo de destinos turísticos.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| DestinationID | GUID | Sí | Identificador único |
| DestinationName | String(255) | Sí | Nombre del destino |
| City | String(100) | Sí | Ciudad |
| State | String(100) | No | Estado/Provincia |
| Country | String(100) | Sí | País |
| Description | Text | No | Descripción del destino |
| Latitude | Decimal(10,8) | No | Latitud |
| Longitude | Decimal(11,8) | No | Longitud |
| Category | OptionSet | No | Categoría (Beach, Mountain, City, Historic, etc.) |
| Rating | Decimal(3,2) | No | Calificación |
| IsPopular | Boolean | No | Destino popular |
| ImageURL | String(500) | No | URL de imagen |

**Índices:**
- PK: DestinationID
- IX: City, Country, Category

---

### 4. MÓDULO DE CONTABILIDAD

#### Tabla: `Invoices` (Facturas)
**Propósito:** Facturas generadas para reservaciones.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| InvoiceID | GUID | Sí | Identificador único |
| InvoiceNumber | String(20) | Sí | Número de factura (único) |
| BookingID | GUID | Sí | FK a Bookings |
| CustomerID | GUID | Sí | FK a Customers |
| InvoiceDate | Date | Sí | Fecha de factura |
| DueDate | Date | Sí | Fecha de vencimiento |
| SubTotal | Currency | Sí | Subtotal |
| TaxAmount | Currency | Sí | Monto de impuestos |
| DiscountAmount | Currency | No | Descuento aplicado |
| TotalAmount | Currency | Sí | Total a pagar |
| CurrencyCode | String(3) | Sí | Código de moneda |
| Status | OptionSet | Sí | Estado (Draft, Sent, Paid, Overdue, Cancelled) |
| Notes | Text | No | Notas adicionales |
| TaxID | String(50) | No | RFC/Tax ID del cliente |
| BillingAddress | Text | No | Dirección de facturación |

**Índices:**
- PK: InvoiceID
- UK: InvoiceNumber
- FK: BookingID, CustomerID
- IX: InvoiceDate, Status

---

#### Tabla: `InvoiceLineItems` (Líneas de Factura)
**Propósito:** Desglose de conceptos en facturas.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| LineItemID | GUID | Sí | Identificador único |
| InvoiceID | GUID | Sí | FK a Invoices |
| Description | String(500) | Sí | Descripción del concepto |
| Quantity | Decimal(10,2) | Sí | Cantidad |
| UnitPrice | Currency | Sí | Precio unitario |
| TaxRate | Decimal(5,2) | No | Tasa de impuesto (%) |
| TaxAmount | Currency | No | Monto de impuesto |
| LineTotal | Currency | Sí | Total de la línea |
| ServiceType | OptionSet | No | Tipo de servicio |

**Índices:**
- PK: LineItemID
- FK: InvoiceID

---

#### Tabla: `Payments` (Pagos)
**Propósito:** Registro de pagos recibidos.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| PaymentID | GUID | Sí | Identificador único |
| BookingID | GUID | Sí | FK a Bookings |
| InvoiceID | GUID | No | FK a Invoices |
| PaymentDate | DateTime | Sí | Fecha y hora del pago |
| Amount | Currency | Sí | Monto pagado |
| CurrencyCode | String(3) | Sí | Código de moneda |
| PaymentMethod | OptionSet | Sí | Método (CreditCard, DebitCard, Cash, Transfer, PayPal) |
| TransactionID | String(100) | No | ID de transacción externa |
| CardLast4Digits | String(4) | No | Últimos 4 dígitos de tarjeta |
| Status | OptionSet | Sí | Estado (Pending, Completed, Failed, Refunded) |
| PaymentGateway | String(50) | No | Gateway utilizado |
| Notes | Text | No | Notas |
| RefundedAmount | Currency | No | Monto reembolsado |
| RefundDate | DateTime | No | Fecha de reembolso |

**Índices:**
- PK: PaymentID
- FK: BookingID, InvoiceID
- IX: PaymentDate, Status, TransactionID

---

#### Tabla: `Expenses` (Gastos)
**Propósito:** Registro de gastos operativos.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| ExpenseID | GUID | Sí | Identificador único |
| ExpenseDate | Date | Sí | Fecha del gasto |
| Category | OptionSet | Sí | Categoría (Fuel, Maintenance, Salary, Insurance, etc.) |
| Description | String(500) | Sí | Descripción |
| Amount | Currency | Sí | Monto |
| CurrencyCode | String(3) | Sí | Código de moneda |
| VehicleID | GUID | No | FK a Vehicles (si aplica) |
| SupplierName | String(255) | No | Nombre del proveedor |
| InvoiceReference | String(100) | No | Referencia de factura |
| PaymentMethod | OptionSet | Sí | Método de pago |
| Status | OptionSet | Sí | Estado (Pending, Approved, Paid, Rejected) |
| ApprovedBy | GUID | No | Usuario que aprobó |
| ApprovedDate | DateTime | No | Fecha de aprobación |
| Notes | Text | No | Notas |

**Índices:**
- PK: ExpenseID
- FK: VehicleID
- IX: ExpenseDate, Category, Status

---

#### Tabla: `PromoCodess` (Códigos Promocionales)
**Propósito:** Gestión de códigos de descuento.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| PromoCodeID | GUID | Sí | Identificador único |
| PromoCode | String(50) | Sí | Código promocional (único) |
| Description | String(255) | Sí | Descripción |
| DiscountType | OptionSet | Sí | Tipo (Percentage, FixedAmount) |
| DiscountValue | Decimal(10,2) | Sí | Valor del descuento |
| MinimumPurchase | Currency | No | Compra mínima requerida |
| MaximumDiscount | Currency | No | Descuento máximo |
| ValidFrom | DateTime | Sí | Válido desde |
| ValidTo | DateTime | Sí | Válido hasta |
| UsageLimit | Integer | No | Límite de usos totales |
| UsageCount | Integer | No | Veces usado |
| IsActive | Boolean | Sí | Activo |
| ApplicableServices | Text | No | Servicios aplicables (JSON) |

**Índices:**
- PK: PromoCodeID
- UK: PromoCode
- IX: ValidFrom, ValidTo, IsActive

---

### 5. MÓDULO DE COMUNICACIÓN Y FEEDBACK

#### Tabla: `Notifications` (Notificaciones)
**Propósito:** Notificaciones automáticas enviadas.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| NotificationID | GUID | Sí | Identificador único |
| BookingID | GUID | No | FK a Bookings |
| CustomerID | GUID | Sí | FK a Customers |
| NotificationType | OptionSet | Sí | Tipo (Email, SMS, Push) |
| Subject | String(255) | No | Asunto (para email) |
| Message | Text | Sí | Contenido del mensaje |
| Status | OptionSet | Sí | Estado (Pending, Sent, Failed, Delivered) |
| SentOn | DateTime | No | Fecha de envío |
| ScheduledFor | DateTime | No | Programado para |
| Template | String(100) | No | Plantilla utilizada |
| ErrorMessage | Text | No | Mensaje de error |

**Índices:**
- PK: NotificationID
- FK: BookingID, CustomerID
- IX: Status, SentOn

---

#### Tabla: `Reviews` (Reseñas)
**Propósito:** Reseñas y calificaciones de clientes.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| ReviewID | GUID | Sí | Identificador único |
| BookingID | GUID | Sí | FK a Bookings |
| CustomerID | GUID | Sí | FK a Customers |
| DriverID | GUID | No | FK a Drivers (si aplica) |
| Rating | Integer | Sí | Calificación (1-5) |
| ReviewTitle | String(255) | No | Título de la reseña |
| ReviewText | Text | No | Texto de la reseña |
| ReviewDate | DateTime | Sí | Fecha de la reseña |
| IsPublic | Boolean | Sí | Visible públicamente |
| Status | OptionSet | Sí | Estado (Pending, Approved, Rejected) |
| ResponseText | Text | No | Respuesta de la empresa |
| ResponseDate | DateTime | No | Fecha de respuesta |

**Índices:**
- PK: ReviewID
- FK: BookingID, CustomerID, DriverID
- IX: ReviewDate, Rating, Status

---

#### Tabla: `SupportTickets` (Tickets de Soporte)
**Propósito:** Gestión de solicitudes de soporte.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| TicketID | GUID | Sí | Identificador único |
| TicketNumber | String(20) | Sí | Número de ticket (único) |
| CustomerID | GUID | Sí | FK a Customers |
| BookingID | GUID | No | FK a Bookings (si aplica) |
| Subject | String(255) | Sí | Asunto |
| Description | Text | Sí | Descripción del problema |
| Priority | OptionSet | Sí | Prioridad (Low, Medium, High, Critical) |
| Category | OptionSet | Sí | Categoría (Booking, Payment, Technical, Other) |
| Status | OptionSet | Sí | Estado (New, Open, InProgress, Resolved, Closed) |
| AssignedTo | GUID | No | Usuario asignado |
| CreatedOn | DateTime | Sí | Fecha de creación |
| ResolvedOn | DateTime | No | Fecha de resolución |
| Resolution | Text | No | Resolución del ticket |

**Índices:**
- PK: TicketID
- UK: TicketNumber
- FK: CustomerID, BookingID
- IX: Status, Priority, CreatedOn

---

### 6. MÓDULO DE ADMINISTRACIÓN DE USUARIOS

#### Tabla: `Users` (Usuarios del Sistema)
**Propósito:** Usuarios internos del sistema.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| UserID | GUID | Sí | Identificador único |
| Username | String(100) | Sí | Nombre de usuario (único) |
| Email | String(255) | Sí | Correo electrónico (único) |
| FirstName | String(100) | Sí | Nombre |
| LastName | String(100) | Sí | Apellido |
| Role | OptionSet | Sí | Rol (Admin, Manager, Agent, Driver, Support) |
| PhoneNumber | String(20) | No | Teléfono |
| IsActive | Boolean | Sí | Usuario activo |
| LastLoginDate | DateTime | No | Última fecha de login |
| CreatedOn | DateTime | Sí | Fecha de creación |
| Department | String(100) | No | Departamento |

**Índices:**
- PK: UserID
- UK: Username, Email
- IX: Role, IsActive

---

#### Tabla: `AuditLog` (Registro de Auditoría)
**Propósito:** Registro de todas las acciones importantes en el sistema.

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| AuditID | GUID | Sí | Identificador único |
| EntityName | String(100) | Sí | Nombre de la entidad |
| EntityID | GUID | Sí | ID del registro afectado |
| Action | OptionSet | Sí | Acción (Create, Update, Delete, Read) |
| UserID | GUID | No | Usuario que realizó la acción |
| ActionDate | DateTime | Sí | Fecha y hora de la acción |
| OldValues | Text | No | Valores anteriores (JSON) |
| NewValues | Text | No | Valores nuevos (JSON) |
| IPAddress | String(45) | No | Dirección IP |

**Índices:**
- PK: AuditID
- IX: EntityName, EntityID, ActionDate, UserID

---

## Relaciones Entre Entidades

### Relaciones Principales:

1. **Customers → Bookings** (1:N)
   - Un cliente puede tener múltiples reservaciones
   
2. **Bookings → BookingDetails** (1:N)
   - Una reservación puede tener múltiples detalles/segmentos

3. **Bookings → Passengers** (1:N)
   - Una reservación puede tener múltiples pasajeros

4. **Bookings → Invoices** (1:N)
   - Una reservación puede generar múltiples facturas

5. **Invoices → InvoiceLineItems** (1:N)
   - Una factura puede tener múltiples líneas

6. **Bookings → Payments** (1:N)
   - Una reservación puede tener múltiples pagos

7. **Bookings → VehicleAssignments** (1:1)
   - Una reservación tiene una asignación de vehículo

8. **Vehicles → VehicleAssignments** (1:N)
   - Un vehículo puede tener múltiples asignaciones

9. **Drivers → VehicleAssignments** (1:N)
   - Un conductor puede tener múltiples asignaciones

10. **Routes → BookingDetails** (1:N)
    - Una ruta puede usarse en múltiples reservaciones

11. **TravelPackages → BookingDetails** (1:N)
    - Un paquete puede usarse en múltiples reservaciones

12. **Customers → CustomerInteractions** (1:N)
    - Un cliente puede tener múltiples interacciones

13. **Bookings → Reviews** (1:N)
    - Una reservación puede tener múltiples reseñas

14. **Customers → SupportTickets** (1:N)
    - Un cliente puede crear múltiples tickets

---

## Índices y Constraints

### Constraints de Integridad Referencial:

Todas las relaciones FK (Foreign Key) implementan:
- **ON DELETE**: Restrict (previene eliminación de registros padre con hijos)
- **ON UPDATE**: Cascade (actualiza automáticamente referencias)

### Índices de Performance:

Los índices listados en cada tabla están optimizados para:
- Búsquedas frecuentes
- Joins comunes
- Ordenamiento
- Filtros de reportes

### Unique Constraints:

- Email de clientes
- Número de reservación
- Número de factura
- Placa de vehículo
- Licencia de conductor
- Código de ruta
- Código promocional
- Username de usuarios

---

## Diagrama de Entidad-Relación

```
                                    ┌─────────────┐
                                    │  Customers  │
                                    └──────┬──────┘
                                           │
                    ┌──────────────────────┼────────────────────────┐
                    │                      │                        │
              ┌─────▼──────┐        ┌─────▼──────┐          ┌──────▼─────┐
              │  Bookings  │        │ Customer   │          │  Support   │
              │            │        │Interactions│          │  Tickets   │
              └─────┬──────┘        └────────────┘          └────────────┘
                    │
        ┌───────────┼───────────┬────────────┬──────────┐
        │           │           │            │          │
  ┌─────▼──────┐   │    ┌──────▼─────┐ ┌────▼────┐ ┌──▼────────┐
  │  Booking   │   │    │  Invoices  │ │Payments │ │  Reviews  │
  │  Details   │   │    └──────┬─────┘ └─────────┘ └───────────┘
  └─────┬──────┘   │           │
        │          │    ┌──────▼─────┐
        │          │    │  Invoice   │
        │          │    │ LineItems  │
   ┌────▼─────┐   │    └────────────┘
   │Passengers│   │
   └──────────┘   │
                  │
          ┌───────▼────────┐
          │    Vehicle     │
          │  Assignments   │
          └───┬────────┬───┘
              │        │
        ┌─────▼──┐  ┌──▼──────┐
        │Vehicles│  │ Drivers │
        └────────┘  └─────────┘
        
        
   ┌───────────┐     ┌──────────────┐     ┌─────────────┐
   │  Routes   │     │Travel        │     │Destinations │
   │           │     │Packages      │     │             │
   └───────────┘     └──────────────┘     └─────────────┘
```

---

## Seguridad y Cumplimiento

### Datos Sensibles:
Los siguientes campos contienen información sensible y deben tener encriptación a nivel de campo:
- Customers.PassportNumber
- Payments.CardLast4Digits
- Payments.TransactionID

### GDPR y Privacidad:
- Implementar políticas de retención de datos
- Permitir exportación de datos de clientes
- Implementar "derecho al olvido"
- Logs de acceso a datos personales

### Roles de Seguridad Recomendados:
1. **Administrador**: Acceso completo
2. **Gerente**: Lectura completa, escritura limitada
3. **Agente**: Gestión de reservaciones y clientes
4. **Conductor**: Solo lectura de asignaciones propias
5. **Soporte**: Gestión de tickets y consultas
6. **Contabilidad**: Acceso a módulos financieros

---

## Vistas Recomendadas

### Vista: `vw_ActiveBookings`
Reservaciones activas con detalles de cliente y vehículo.

### Vista: `vw_RevenueReport`
Reporte de ingresos por período.

### Vista: `vw_VehicleUtilization`
Utilización de vehículos por período.

### Vista: `vw_CustomerLoyalty`
Análisis de lealtad de clientes.

### Vista: `vw_PendingPayments`
Pagos pendientes y facturas vencidas.

---

## Procedimientos Almacenados Sugeridos

1. **sp_CreateBooking**: Crear nueva reservación con validaciones
2. **sp_CancelBooking**: Cancelar reservación y manejar reembolsos
3. **sp_GenerateInvoice**: Generar factura para reservación
4. **sp_ProcessPayment**: Procesar pago y actualizar estados
5. **sp_AssignVehicle**: Asignar vehículo y conductor con validaciones
6. **sp_CalculateRevenue**: Calcular ingresos por período
7. **sp_VehicleMaintenanceSchedule**: Programar mantenimiento
8. **sp_CustomerLoyaltyUpdate**: Actualizar puntos de lealtad

---

## Consideraciones de Performance

### Estrategias de Particionamiento:
- **Bookings**: Particionar por TravelDate (mensual/trimestral)
- **Payments**: Particionar por PaymentDate (mensual)
- **AuditLog**: Particionar por ActionDate (mensual)

### Archivado de Datos:
- Archivar bookings completadas > 2 años
- Archivar audit logs > 1 año
- Archivar notificaciones > 6 meses

### Caching Recomendado:
- Catálogo de vehículos
- Rutas activas
- Paquetes de viaje
- Códigos promocionales activos
- Información de destinos

---

## Integración con Sistemas Externos

### APIs Requeridas:
1. **Payment Gateways**: Stripe, PayPal, Conekta
2. **Mapping Services**: Google Maps API, Mapbox
3. **Email Service**: SendGrid, AWS SES
4. **SMS Service**: Twilio, Nexmo
5. **Accounting**: QuickBooks, SAP

### Webhooks:
- Confirmación de pagos
- Actualizaciones de estado de reservación
- Notificaciones de ubicación de vehículo

---

## Resumen de Tablas

| Módulo | Número de Tablas | Tablas Principales |
|--------|------------------|-------------------|
| CRM | 2 | Customers, CustomerInteractions |
| Reservaciones | 4 | Bookings, BookingDetails, Passengers, VehicleAssignments |
| Administración | 6 | Vehicles, Drivers, Routes, TravelPackages, Destinations |
| Contabilidad | 5 | Invoices, InvoiceLineItems, Payments, Expenses, PromoCodes |
| Comunicación | 3 | Notifications, Reviews, SupportTickets |
| Sistema | 2 | Users, AuditLog |
| **TOTAL** | **22 Tablas** | |

---

## Métricas Estimadas

### Volumen de Datos Esperado (Anual):
- **Clientes**: 10,000 - 50,000 registros
- **Reservaciones**: 50,000 - 200,000 registros
- **Pagos**: 50,000 - 200,000 registros
- **Facturas**: 50,000 - 200,000 registros
- **Notificaciones**: 200,000 - 1,000,000 registros
- **Audit Logs**: 500,000 - 2,000,000 registros

### Tamaño de Base de Datos Estimado:
- **Año 1**: 5-10 GB
- **Año 2**: 15-25 GB
- **Año 3**: 30-50 GB

---

## Mantenimiento y Monitoreo

### Tareas Programadas:
1. **Diario**: 
   - Backup completo de la base de datos
   - Limpieza de notificaciones antiguas
   - Actualización de estadísticas

2. **Semanal**:
   - Reindex de tablas principales
   - Revisión de integridad de datos
   - Análisis de performance de queries

3. **Mensual**:
   - Archivado de datos antiguos
   - Revisión de crecimiento de tablas
   - Optimización de índices

### Alertas Configuradas:
- Uso de espacio > 80%
- Queries lentas > 5 segundos
- Fallas de integridad referencial
- Intentos de acceso no autorizados

---

## Próximos Pasos

### Fase 1 - Implementación Base (Sprint 1-2):
- [ ] Crear tablas del módulo de CRM
- [ ] Crear tablas del módulo de Reservaciones
- [ ] Implementar relaciones básicas
- [ ] Crear usuarios y roles de seguridad

### Fase 2 - Módulos Operativos (Sprint 3-4):
- [ ] Implementar módulo de Administración
- [ ] Implementar módulo de Contabilidad
- [ ] Crear procedimientos almacenados básicos
- [ ] Implementar vistas principales

### Fase 3 - Funcionalidades Avanzadas (Sprint 5-6):
- [ ] Módulo de Comunicación y Feedback
- [ ] Sistema de auditoría completo
- [ ] Integración con APIs externas
- [ ] Optimización de performance

### Fase 4 - Producción y Monitoreo (Sprint 7-8):
- [ ] Testing de carga
- [ ] Implementación de backups
- [ ] Configuración de monitoreo
- [ ] Documentación de operaciones

---

## Contacto y Soporte

Para preguntas o aclaraciones sobre este esquema, contactar al equipo de desarrollo.

**Versión del Documento:** 1.0  
**Fecha de Última Actualización:** 8 de Noviembre, 2025  
**Preparado por:** Copilot Development Team  
**Revisado por:** Pendiente

---

## Apéndice A: Diccionario de Tipos de Datos

| Tipo Dataverse | Descripción | Ejemplo |
|----------------|-------------|---------|
| GUID | Identificador único global | 123e4567-e89b-12d3-a456-426614174000 |
| String(n) | Cadena de texto de longitud n | "Juan Pérez" |
| Text | Texto largo sin límite | Descripciones largas |
| Integer | Número entero | 42 |
| Decimal(p,s) | Número decimal | 123.45 |
| Currency | Moneda | $1,234.56 |
| Date | Fecha sin hora | 2025-11-08 |
| DateTime | Fecha y hora | 2025-11-08 15:30:00 |
| Time | Solo hora | 15:30:00 |
| Boolean | Verdadero/Falso | true |
| OptionSet | Lista de opciones | Active, Inactive |

---

## Apéndice B: Glosario de Términos

- **CRM**: Customer Relationship Management
- **FK**: Foreign Key (Llave Foránea)
- **PK**: Primary Key (Llave Primaria)
- **UK**: Unique Key (Llave Única)
- **IX**: Index (Índice)
- **GUID**: Globally Unique Identifier
- **GDPR**: General Data Protection Regulation
- **API**: Application Programming Interface
- **JSON**: JavaScript Object Notation

---

*Fin del Reporte*

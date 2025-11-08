-- =====================================================
-- Dataverse Schema - NexionExplorTravel System
-- Sistema de Transporte Turístico y Viajes Privados
-- Version: 1.0
-- Date: November 8, 2025
-- =====================================================

-- =====================================================
-- MÓDULO 1: CRM - Customer Relationship Management
-- =====================================================

-- Tabla: Customers (Clientes)
CREATE TABLE Customers (
    CustomerID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20) NOT NULL,
    DateOfBirth DATE NULL,
    Nationality NVARCHAR(50) NULL,
    PassportNumber NVARCHAR(50) NULL,
    PreferredLanguage NVARCHAR(10) NULL,
    PreferredCurrency NVARCHAR(3) NULL,
    LoyaltyTier NVARCHAR(20) NULL CHECK (LoyaltyTier IN ('Bronze', 'Silver', 'Gold', 'Platinum')),
    LoyaltyPoints INT NULL DEFAULT 0,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedOn DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active', 'Inactive', 'Blocked'))
);

CREATE INDEX IX_Customers_PhoneNumber ON Customers(PhoneNumber);
CREATE INDEX IX_Customers_LastName ON Customers(LastName);

-- Tabla: CustomerInteractions (Interacciones con Clientes)
CREATE TABLE CustomerInteractions (
    InteractionID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    InteractionType NVARCHAR(20) NOT NULL CHECK (InteractionType IN ('Call', 'Email', 'Chat', 'Meeting', 'Feedback')),
    Subject NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    InteractionDate DATETIME NOT NULL DEFAULT GETDATE(),
    AssignedToUser UNIQUEIDENTIFIER NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Open' CHECK (Status IN ('Open', 'In Progress', 'Closed')),
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE INDEX IX_CustomerInteractions_Date ON CustomerInteractions(InteractionDate);
CREATE INDEX IX_CustomerInteractions_AssignedUser ON CustomerInteractions(AssignedToUser);

-- =====================================================
-- MÓDULO 2: RESERVACIONES
-- =====================================================

-- Tabla: Bookings (Reservaciones)
CREATE TABLE Bookings (
    BookingID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingNumber NVARCHAR(20) NOT NULL UNIQUE,
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    BookingDate DATETIME NOT NULL DEFAULT GETDATE(),
    TravelDate DATE NOT NULL,
    TravelTime TIME NULL,
    TripType NVARCHAR(20) NOT NULL CHECK (TripType IN ('OneWay', 'RoundTrip', 'MultiDestination')),
    PassengerCount INT NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    TotalAmount DECIMAL(18,2) NOT NULL,
    CurrencyCode NVARCHAR(3) NOT NULL DEFAULT 'USD',
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Partial', 'Paid', 'Refunded')),
    CancellationReason NVARCHAR(MAX) NULL,
    SpecialRequests NVARCHAR(MAX) NULL,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedOn DATETIME NOT NULL DEFAULT GETDATE(),
    ConfirmationSentOn DATETIME NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE INDEX IX_Bookings_TravelDate ON Bookings(TravelDate);
CREATE INDEX IX_Bookings_Status ON Bookings(Status);
CREATE INDEX IX_Bookings_BookingDate ON Bookings(BookingDate);
CREATE INDEX IX_Bookings_Customer ON Bookings(CustomerID);

-- Tabla: BookingDetails (Detalles de Reservación)
CREATE TABLE BookingDetails (
    BookingDetailID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NOT NULL,
    VehicleID UNIQUEIDENTIFIER NULL,
    RouteID UNIQUEIDENTIFIER NULL,
    PackageID UNIQUEIDENTIFIER NULL,
    OriginLocation NVARCHAR(255) NOT NULL,
    DestinationLocation NVARCHAR(255) NOT NULL,
    PickupAddress NVARCHAR(MAX) NULL,
    DropoffAddress NVARCHAR(MAX) NULL,
    PickupDateTime DATETIME NOT NULL,
    EstimatedArrival DATETIME NULL,
    ActualArrival DATETIME NULL,
    Distance DECIMAL(10,2) NULL,
    Duration INT NULL,
    SeatNumbers NVARCHAR(255) NULL,
    Price DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE INDEX IX_BookingDetails_Booking ON BookingDetails(BookingID);
CREATE INDEX IX_BookingDetails_PickupDateTime ON BookingDetails(PickupDateTime);

-- Tabla: Passengers (Pasajeros)
CREATE TABLE Passengers (
    PassengerID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Age INT NULL,
    PassengerType NVARCHAR(20) NOT NULL CHECK (PassengerType IN ('Adult', 'Child', 'Infant', 'Senior')),
    IdentificationNumber NVARCHAR(50) NULL,
    SpecialNeeds NVARCHAR(MAX) NULL,
    SeatPreference NVARCHAR(50) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE INDEX IX_Passengers_Booking ON Passengers(BookingID);

-- =====================================================
-- MÓDULO 3: ADMINISTRACIÓN
-- =====================================================

-- Tabla: Vehicles (Vehículos)
CREATE TABLE Vehicles (
    VehicleID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    VehicleType NVARCHAR(20) NOT NULL CHECK (VehicleType IN ('Bus', 'Van', 'Car', 'Luxury', 'SUV')),
    Make NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Year INT NOT NULL,
    LicensePlate NVARCHAR(20) NOT NULL UNIQUE,
    Capacity INT NOT NULL,
    Color NVARCHAR(30) NULL,
    VIN NVARCHAR(50) NULL,
    Features NVARCHAR(MAX) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Available' CHECK (Status IN ('Available', 'InService', 'Maintenance', 'Retired')),
    CurrentLocation NVARCHAR(255) NULL,
    LastMaintenanceDate DATE NULL,
    NextMaintenanceDate DATE NULL,
    InsurancePolicyNumber NVARCHAR(50) NULL,
    InsuranceExpiryDate DATE NULL
);

CREATE INDEX IX_Vehicles_Type ON Vehicles(VehicleType);
CREATE INDEX IX_Vehicles_Status ON Vehicles(Status);

-- Tabla: Drivers (Conductores)
CREATE TABLE Drivers (
    DriverID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    LicenseNumber NVARCHAR(50) NOT NULL UNIQUE,
    LicenseType NVARCHAR(20) NOT NULL,
    LicenseExpiryDate DATE NOT NULL,
    DateOfBirth DATE NOT NULL,
    HireDate DATE NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active', 'OnLeave', 'Suspended', 'Terminated')),
    Rating DECIMAL(3,2) NULL CHECK (Rating >= 0 AND Rating <= 5),
    LanguagesSpoken NVARCHAR(255) NULL,
    EmergencyContact NVARCHAR(255) NULL
);

CREATE INDEX IX_Drivers_Status ON Drivers(Status);
CREATE INDEX IX_Drivers_Rating ON Drivers(Rating);

-- Tabla: VehicleAssignments (Asignaciones de Vehículos)
CREATE TABLE VehicleAssignments (
    AssignmentID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NOT NULL,
    VehicleID UNIQUEIDENTIFIER NOT NULL,
    DriverID UNIQUEIDENTIFIER NOT NULL,
    AssignmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Scheduled' CHECK (Status IN ('Scheduled', 'InProgress', 'Completed', 'Cancelled')),
    StartOdometer INT NULL,
    EndOdometer INT NULL,
    FuelStart DECIMAL(5,2) NULL,
    FuelEnd DECIMAL(5,2) NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE INDEX IX_VehicleAssignments_Date ON VehicleAssignments(AssignmentDate);
CREATE INDEX IX_VehicleAssignments_Status ON VehicleAssignments(Status);
CREATE INDEX IX_VehicleAssignments_Vehicle ON VehicleAssignments(VehicleID);
CREATE INDEX IX_VehicleAssignments_Driver ON VehicleAssignments(DriverID);

-- Tabla: Routes (Rutas)
CREATE TABLE Routes (
    RouteID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    RouteName NVARCHAR(255) NOT NULL,
    RouteCode NVARCHAR(20) NOT NULL UNIQUE,
    OriginCity NVARCHAR(100) NOT NULL,
    DestinationCity NVARCHAR(100) NOT NULL,
    Distance DECIMAL(10,2) NOT NULL,
    EstimatedDuration INT NOT NULL,
    BasePrice DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Stops NVARCHAR(MAX) NULL
);

CREATE INDEX IX_Routes_OriginCity ON Routes(OriginCity);
CREATE INDEX IX_Routes_DestinationCity ON Routes(DestinationCity);
CREATE INDEX IX_Routes_IsActive ON Routes(IsActive);

-- Update BookingDetails to add foreign key to Routes
ALTER TABLE BookingDetails
ADD FOREIGN KEY (RouteID) REFERENCES Routes(RouteID);

-- Tabla: TravelPackages (Paquetes de Viaje)
CREATE TABLE TravelPackages (
    PackageID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PackageName NVARCHAR(255) NOT NULL,
    PackageCode NVARCHAR(20) NOT NULL UNIQUE,
    PackageType NVARCHAR(20) NOT NULL CHECK (PackageType IN ('Predefined', 'Custom', 'Seasonal')),
    Description NVARCHAR(MAX) NOT NULL,
    Duration INT NOT NULL,
    IncludedServices NVARCHAR(MAX) NULL,
    Destinations NVARCHAR(MAX) NULL,
    Activities NVARCHAR(MAX) NULL,
    BasePrice DECIMAL(18,2) NOT NULL,
    MaxParticipants INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    ValidFrom DATE NULL,
    ValidTo DATE NULL
);

CREATE INDEX IX_TravelPackages_Type ON TravelPackages(PackageType);
CREATE INDEX IX_TravelPackages_IsActive ON TravelPackages(IsActive);

-- Update BookingDetails to add foreign key to TravelPackages
ALTER TABLE BookingDetails
ADD FOREIGN KEY (PackageID) REFERENCES TravelPackages(PackageID);

-- Update BookingDetails to add foreign key to Vehicles
ALTER TABLE BookingDetails
ADD FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID);

-- Tabla: Destinations (Destinos)
CREATE TABLE Destinations (
    DestinationID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DestinationName NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100) NULL,
    Country NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Latitude DECIMAL(10,8) NULL,
    Longitude DECIMAL(11,8) NULL,
    Category NVARCHAR(50) NULL,
    Rating DECIMAL(3,2) NULL CHECK (Rating >= 0 AND Rating <= 5),
    IsPopular BIT NULL DEFAULT 0,
    ImageURL NVARCHAR(500) NULL
);

CREATE INDEX IX_Destinations_City ON Destinations(City);
CREATE INDEX IX_Destinations_Country ON Destinations(Country);
CREATE INDEX IX_Destinations_Category ON Destinations(Category);

-- =====================================================
-- MÓDULO 4: CONTABILIDAD
-- =====================================================

-- Tabla: Invoices (Facturas)
CREATE TABLE Invoices (
    InvoiceID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    InvoiceNumber NVARCHAR(20) NOT NULL UNIQUE,
    BookingID UNIQUEIDENTIFIER NOT NULL,
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    InvoiceDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    SubTotal DECIMAL(18,2) NOT NULL,
    TaxAmount DECIMAL(18,2) NOT NULL,
    DiscountAmount DECIMAL(18,2) NULL DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL,
    CurrencyCode NVARCHAR(3) NOT NULL DEFAULT 'USD',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled')),
    Notes NVARCHAR(MAX) NULL,
    TaxID NVARCHAR(50) NULL,
    BillingAddress NVARCHAR(MAX) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE INDEX IX_Invoices_Date ON Invoices(InvoiceDate);
CREATE INDEX IX_Invoices_Status ON Invoices(Status);
CREATE INDEX IX_Invoices_Customer ON Invoices(CustomerID);

-- Tabla: InvoiceLineItems (Líneas de Factura)
CREATE TABLE InvoiceLineItems (
    LineItemID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    InvoiceID UNIQUEIDENTIFIER NOT NULL,
    Description NVARCHAR(500) NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TaxRate DECIMAL(5,2) NULL,
    TaxAmount DECIMAL(18,2) NULL,
    LineTotal DECIMAL(18,2) NOT NULL,
    ServiceType NVARCHAR(50) NULL,
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)
);

CREATE INDEX IX_InvoiceLineItems_Invoice ON InvoiceLineItems(InvoiceID);

-- Tabla: Payments (Pagos)
CREATE TABLE Payments (
    PaymentID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NOT NULL,
    InvoiceID UNIQUEIDENTIFIER NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    CurrencyCode NVARCHAR(3) NOT NULL DEFAULT 'USD',
    PaymentMethod NVARCHAR(20) NOT NULL CHECK (PaymentMethod IN ('CreditCard', 'DebitCard', 'Cash', 'Transfer', 'PayPal')),
    TransactionID NVARCHAR(100) NULL,
    CardLast4Digits NVARCHAR(4) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    PaymentGateway NVARCHAR(50) NULL,
    Notes NVARCHAR(MAX) NULL,
    RefundedAmount DECIMAL(18,2) NULL,
    RefundDate DATETIME NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)
);

CREATE INDEX IX_Payments_Date ON Payments(PaymentDate);
CREATE INDEX IX_Payments_Status ON Payments(Status);
CREATE INDEX IX_Payments_TransactionID ON Payments(TransactionID);
CREATE INDEX IX_Payments_Booking ON Payments(BookingID);

-- Tabla: Expenses (Gastos)
CREATE TABLE Expenses (
    ExpenseID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ExpenseDate DATE NOT NULL,
    Category NVARCHAR(50) NOT NULL CHECK (Category IN ('Fuel', 'Maintenance', 'Salary', 'Insurance', 'Marketing', 'Office', 'Other')),
    Description NVARCHAR(500) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    CurrencyCode NVARCHAR(3) NOT NULL DEFAULT 'USD',
    VehicleID UNIQUEIDENTIFIER NULL,
    SupplierName NVARCHAR(255) NULL,
    InvoiceReference NVARCHAR(100) NULL,
    PaymentMethod NVARCHAR(20) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Paid', 'Rejected')),
    ApprovedBy UNIQUEIDENTIFIER NULL,
    ApprovedDate DATETIME NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);

CREATE INDEX IX_Expenses_Date ON Expenses(ExpenseDate);
CREATE INDEX IX_Expenses_Category ON Expenses(Category);
CREATE INDEX IX_Expenses_Status ON Expenses(Status);

-- Tabla: PromoCodes (Códigos Promocionales)
CREATE TABLE PromoCodes (
    PromoCodeID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PromoCode NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NOT NULL,
    DiscountType NVARCHAR(20) NOT NULL CHECK (DiscountType IN ('Percentage', 'FixedAmount')),
    DiscountValue DECIMAL(10,2) NOT NULL,
    MinimumPurchase DECIMAL(18,2) NULL,
    MaximumDiscount DECIMAL(18,2) NULL,
    ValidFrom DATETIME NOT NULL,
    ValidTo DATETIME NOT NULL,
    UsageLimit INT NULL,
    UsageCount INT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    ApplicableServices NVARCHAR(MAX) NULL
);

CREATE INDEX IX_PromoCodes_ValidFrom ON PromoCodes(ValidFrom);
CREATE INDEX IX_PromoCodes_ValidTo ON PromoCodes(ValidTo);
CREATE INDEX IX_PromoCodes_IsActive ON PromoCodes(IsActive);

-- =====================================================
-- MÓDULO 5: COMUNICACIÓN Y FEEDBACK
-- =====================================================

-- Tabla: Notifications (Notificaciones)
CREATE TABLE Notifications (
    NotificationID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NULL,
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    NotificationType NVARCHAR(20) NOT NULL CHECK (NotificationType IN ('Email', 'SMS', 'Push')),
    Subject NVARCHAR(255) NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Sent', 'Failed', 'Delivered')),
    SentOn DATETIME NULL,
    ScheduledFor DATETIME NULL,
    Template NVARCHAR(100) NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE INDEX IX_Notifications_Status ON Notifications(Status);
CREATE INDEX IX_Notifications_SentOn ON Notifications(SentOn);
CREATE INDEX IX_Notifications_Customer ON Notifications(CustomerID);

-- Tabla: Reviews (Reseñas)
CREATE TABLE Reviews (
    ReviewID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    BookingID UNIQUEIDENTIFIER NOT NULL,
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    DriverID UNIQUEIDENTIFIER NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    ReviewTitle NVARCHAR(255) NULL,
    ReviewText NVARCHAR(MAX) NULL,
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsPublic BIT NOT NULL DEFAULT 1,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    ResponseText NVARCHAR(MAX) NULL,
    ResponseDate DATETIME NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE INDEX IX_Reviews_Date ON Reviews(ReviewDate);
CREATE INDEX IX_Reviews_Rating ON Reviews(Rating);
CREATE INDEX IX_Reviews_Status ON Reviews(Status);
CREATE INDEX IX_Reviews_Driver ON Reviews(DriverID);

-- Tabla: SupportTickets (Tickets de Soporte)
CREATE TABLE SupportTickets (
    TicketID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TicketNumber NVARCHAR(20) NOT NULL UNIQUE,
    CustomerID UNIQUEIDENTIFIER NOT NULL,
    BookingID UNIQUEIDENTIFIER NULL,
    Subject NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium' CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical')),
    Category NVARCHAR(50) NOT NULL CHECK (Category IN ('Booking', 'Payment', 'Technical', 'Complaint', 'Other')),
    Status NVARCHAR(20) NOT NULL DEFAULT 'New' CHECK (Status IN ('New', 'Open', 'InProgress', 'Resolved', 'Closed')),
    AssignedTo UNIQUEIDENTIFIER NULL,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    ResolvedOn DATETIME NULL,
    Resolution NVARCHAR(MAX) NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE INDEX IX_SupportTickets_Status ON SupportTickets(Status);
CREATE INDEX IX_SupportTickets_Priority ON SupportTickets(Priority);
CREATE INDEX IX_SupportTickets_CreatedOn ON SupportTickets(CreatedOn);
CREATE INDEX IX_SupportTickets_Customer ON SupportTickets(CustomerID);

-- =====================================================
-- MÓDULO 6: ADMINISTRACIÓN DE USUARIOS
-- =====================================================

-- Tabla: Users (Usuarios del Sistema)
CREATE TABLE Users (
    UserID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'Manager', 'Agent', 'Driver', 'Support')),
    PhoneNumber NVARCHAR(20) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    LastLoginDate DATETIME NULL,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    Department NVARCHAR(100) NULL
);

CREATE INDEX IX_Users_Role ON Users(Role);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);

-- Tabla: AuditLog (Registro de Auditoría)
CREATE TABLE AuditLog (
    AuditID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    EntityName NVARCHAR(100) NOT NULL,
    EntityID UNIQUEIDENTIFIER NOT NULL,
    Action NVARCHAR(20) NOT NULL CHECK (Action IN ('Create', 'Update', 'Delete', 'Read')),
    UserID UNIQUEIDENTIFIER NULL,
    ActionDate DATETIME NOT NULL DEFAULT GETDATE(),
    OldValues NVARCHAR(MAX) NULL,
    NewValues NVARCHAR(MAX) NULL,
    IPAddress NVARCHAR(45) NULL
);

CREATE INDEX IX_AuditLog_EntityName ON AuditLog(EntityName);
CREATE INDEX IX_AuditLog_EntityID ON AuditLog(EntityID);
CREATE INDEX IX_AuditLog_ActionDate ON AuditLog(ActionDate);
CREATE INDEX IX_AuditLog_UserID ON AuditLog(UserID);

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista: Reservaciones Activas con Detalles
GO
CREATE VIEW vw_ActiveBookings AS
SELECT 
    b.BookingID,
    b.BookingNumber,
    b.TravelDate,
    b.Status,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email AS CustomerEmail,
    c.PhoneNumber AS CustomerPhone,
    b.TotalAmount,
    b.CurrencyCode,
    b.PaymentStatus,
    v.Make + ' ' + v.Model AS VehicleName,
    v.LicensePlate,
    d.FirstName + ' ' + d.LastName AS DriverName
FROM Bookings b
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
LEFT JOIN VehicleAssignments va ON b.BookingID = va.BookingID
LEFT JOIN Vehicles v ON va.VehicleID = v.VehicleID
LEFT JOIN Drivers d ON va.DriverID = d.DriverID
WHERE b.Status IN ('Pending', 'Confirmed');
GO

-- Vista: Reporte de Ingresos
GO
CREATE VIEW vw_RevenueReport AS
SELECT 
    YEAR(p.PaymentDate) AS Year,
    MONTH(p.PaymentDate) AS Month,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(p.Amount) AS TotalRevenue,
    p.CurrencyCode,
    AVG(p.Amount) AS AvgBookingValue
FROM Payments p
INNER JOIN Bookings b ON p.BookingID = b.BookingID
WHERE p.Status = 'Completed'
GROUP BY YEAR(p.PaymentDate), MONTH(p.PaymentDate), p.CurrencyCode;
GO

-- Vista: Utilización de Vehículos
GO
CREATE VIEW vw_VehicleUtilization AS
SELECT 
    v.VehicleID,
    v.Make + ' ' + v.Model AS VehicleName,
    v.LicensePlate,
    v.VehicleType,
    COUNT(va.AssignmentID) AS TotalAssignments,
    SUM(CASE WHEN va.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedTrips,
    AVG(DATEDIFF(MINUTE, bd.PickupDateTime, bd.ActualArrival)) AS AvgTripDuration
FROM Vehicles v
LEFT JOIN VehicleAssignments va ON v.VehicleID = va.VehicleID
LEFT JOIN BookingDetails bd ON va.BookingID = bd.BookingID
GROUP BY v.VehicleID, v.Make, v.Model, v.LicensePlate, v.VehicleType;
GO

-- Vista: Lealtad de Clientes
GO
CREATE VIEW vw_CustomerLoyalty AS
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    c.LoyaltyTier,
    c.LoyaltyPoints,
    COUNT(b.BookingID) AS TotalBookings,
    SUM(b.TotalAmount) AS TotalSpent,
    MAX(b.BookingDate) AS LastBookingDate,
    AVG(CAST(r.Rating AS DECIMAL(3,2))) AS AvgRating
FROM Customers c
LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID
LEFT JOIN Reviews r ON c.CustomerID = r.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email, c.LoyaltyTier, c.LoyaltyPoints;
GO

-- Vista: Pagos Pendientes
GO
CREATE VIEW vw_PendingPayments AS
SELECT 
    i.InvoiceID,
    i.InvoiceNumber,
    i.InvoiceDate,
    i.DueDate,
    DATEDIFF(DAY, i.DueDate, GETDATE()) AS DaysOverdue,
    i.TotalAmount,
    i.CurrencyCode,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    c.PhoneNumber,
    b.BookingNumber
FROM Invoices i
INNER JOIN Customers c ON i.CustomerID = c.CustomerID
INNER JOIN Bookings b ON i.BookingID = b.BookingID
WHERE i.Status IN ('Sent', 'Overdue')
  AND i.TotalAmount > (
      SELECT ISNULL(SUM(p.Amount), 0)
      FROM Payments p
      WHERE p.InvoiceID = i.InvoiceID AND p.Status = 'Completed'
  );
GO

-- =====================================================
-- STORED PROCEDURES BÁSICOS
-- =====================================================

-- Procedimiento: Crear Reservación
GO
CREATE PROCEDURE sp_CreateBooking
    @CustomerID UNIQUEIDENTIFIER,
    @TravelDate DATE,
    @TravelTime TIME,
    @TripType NVARCHAR(20),
    @PassengerCount INT,
    @TotalAmount DECIMAL(18,2),
    @CurrencyCode NVARCHAR(3),
    @BookingID UNIQUEIDENTIFIER OUTPUT,
    @BookingNumber NVARCHAR(20) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Generar número de reservación único
    DECLARE @Counter INT;
    SELECT @Counter = ISNULL(MAX(CAST(SUBSTRING(BookingNumber, 4, LEN(BookingNumber)) AS INT)), 0) + 1
    FROM Bookings
    WHERE BookingNumber LIKE 'BK%';
    
    SET @BookingNumber = 'BK' + RIGHT('00000' + CAST(@Counter AS NVARCHAR), 5);
    SET @BookingID = NEWID();
    
    -- Insertar reservación
    INSERT INTO Bookings (
        BookingID, BookingNumber, CustomerID, BookingDate, TravelDate, TravelTime,
        TripType, PassengerCount, Status, TotalAmount, CurrencyCode, PaymentStatus
    )
    VALUES (
        @BookingID, @BookingNumber, @CustomerID, GETDATE(), @TravelDate, @TravelTime,
        @TripType, @PassengerCount, 'Pending', @TotalAmount, @CurrencyCode, 'Pending'
    );
    
    SELECT @BookingID AS BookingID, @BookingNumber AS BookingNumber;
END;
GO

-- Procedimiento: Procesar Pago
GO
CREATE PROCEDURE sp_ProcessPayment
    @BookingID UNIQUEIDENTIFIER,
    @Amount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(20),
    @TransactionID NVARCHAR(100),
    @PaymentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insertar pago
        SET @PaymentID = NEWID();
        INSERT INTO Payments (PaymentID, BookingID, PaymentDate, Amount, PaymentMethod, TransactionID, Status)
        VALUES (@PaymentID, @BookingID, GETDATE(), @Amount, @PaymentMethod, @TransactionID, 'Completed');
        
        -- Actualizar estado de pago de la reservación
        DECLARE @TotalPaid DECIMAL(18,2);
        DECLARE @BookingTotal DECIMAL(18,2);
        
        SELECT @TotalPaid = ISNULL(SUM(Amount), 0)
        FROM Payments
        WHERE BookingID = @BookingID AND Status = 'Completed';
        
        SELECT @BookingTotal = TotalAmount
        FROM Bookings
        WHERE BookingID = @BookingID;
        
        UPDATE Bookings
        SET PaymentStatus = CASE 
            WHEN @TotalPaid >= @BookingTotal THEN 'Paid'
            WHEN @TotalPaid > 0 THEN 'Partial'
            ELSE 'Pending'
        END
        WHERE BookingID = @BookingID;
        
        COMMIT TRANSACTION;
        SELECT @PaymentID AS PaymentID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger: Actualizar ModifiedOn en Customers
GO
CREATE TRIGGER trg_Customers_UpdateModifiedOn
ON Customers
AFTER UPDATE
AS
BEGIN
    UPDATE Customers
    SET ModifiedOn = GETDATE()
    FROM Customers c
    INNER JOIN inserted i ON c.CustomerID = i.CustomerID;
END;
GO

-- Trigger: Actualizar ModifiedOn en Bookings
GO
CREATE TRIGGER trg_Bookings_UpdateModifiedOn
ON Bookings
AFTER UPDATE
AS
BEGIN
    UPDATE Bookings
    SET ModifiedOn = GETDATE()
    FROM Bookings b
    INNER JOIN inserted i ON b.BookingID = i.BookingID;
END;
GO

-- =====================================================
-- DATOS INICIALES DE EJEMPLO
-- =====================================================

-- Insertar tipos de usuario
INSERT INTO Users (Username, Email, FirstName, LastName, Role, IsActive)
VALUES 
    ('admin', 'admin@nexionexplor.com', 'Admin', 'System', 'Admin', 1),
    ('manager1', 'manager@nexionexplor.com', 'John', 'Manager', 'Manager', 1),
    ('agent1', 'agent1@nexionexplor.com', 'Maria', 'Agent', 'Agent', 1);

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================

PRINT 'Schema de Dataverse creado exitosamente para NexionExplorTravel';
PRINT 'Total de tablas: 22';
PRINT 'Total de vistas: 5';
PRINT 'Total de stored procedures: 2';
PRINT 'Total de triggers: 2';
GO

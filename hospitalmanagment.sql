-- 1. CREATE TABLES

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    AdmissionDate DATE
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(50),
    Specialty VARCHAR(50)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Date DATE,
    Time TIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Bills (
    BillID INT PRIMARY KEY,
    PatientID INT,
    Amount DECIMAL(10, 2),
    Status VARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    PatientID INT,
    RoomType VARCHAR(20),
    AdmissionDate DATE,
    DischargeDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- 2. INSERT  DATAS
INSERT INTO Patients VALUES
(1, 'Arjun Mehta', 45, 'Male', '2025-06-15'),
(2, 'Priya Reddy', 30, 'Female', '2025-06-18'),
(3, 'Karan Patel', 60, 'Male', '2025-07-01'),
(4, 'Sneha Iyer', 25, 'Female', '2025-07-02'),
(5, 'Rahul Das', 50, 'Male', '2025-06-20');

-- Doctors
INSERT INTO Doctors VALUES
(1, 'Dr. Anjali Sharma', 'Cardiology'),
(2, 'Dr. Vikram Rao', 'Orthopedics'),
(3, 'Dr. Neha Kapoor', 'Neurology');

-- Appointments
INSERT INTO Appointments VALUES
(1, 1, 1, '2025-06-16', '10:00:00'),
(2, 2, 2, '2025-06-19', '11:00:00'),
(3, 3, 1, '2025-07-02', '09:30:00'),
(4, 4, 3, '2025-07-03', '14:00:00'),
(5, 5, 2, '2025-06-21', '15:00:00');

-- Bills
INSERT INTO Bills VALUES
(101, 1, 5000.00, 'Paid'),
(102, 2, 3500.00, 'Unpaid'),
(103, 3, 8000.00, 'Paid'),
(104, 4, 2000.00, 'Unpaid'),
(105, 5, 4500.00, 'Paid');

-- Rooms
INSERT INTO Rooms VALUES
(201, 1, 'General', '2025-06-15', '2025-06-20'),
(202, 2, 'ICU', '2025-06-18', NULL),
(203, 3, 'General', '2025-07-01', NULL),
(204, 4, 'Private', '2025-07-02', NULL),
(205, 5, 'ICU', '2025-06-20', '2025-06-25');

-- 3. QUERIES

--  List of all patients who haven't been discharged yet
SELECT p.PatientID, p.Name, r.RoomType
FROM Patients p
JOIN Rooms r ON p.PatientID = r.PatientID
WHERE r.DischargeDate IS NULL;

--  Total number of appointments per doctor
SELECT d.Name AS DoctorName, COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.Name;

-- List unpaid bills with patient names
SELECT p.Name, b.Amount
FROM Bills b
JOIN Patients p ON b.PatientID = p.PatientID
WHERE b.Status = 'Unpaid';

-- Patients who have appointments with Cardiologists
SELECT DISTINCT p.Name
FROM Appointments a
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Patients p ON a.PatientID = p.PatientID
WHERE d.Specialty = 'Cardiology';

-- Room occupancy per type
SELECT RoomType, COUNT(*) AS TotalOccupied
FROM Rooms
WHERE DischargeDate IS NULL
GROUP BY RoomType
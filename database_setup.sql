-- Жаңа рөлдерді құру
CREATE ROLE med_admin;
CREATE ROLE doctor_role;

-- Рөлдерге рұқсаттар беру
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT, INSERT ON patient, appointment TO doctor_role;

-- Пайдаланушыларды құру және рөлдерді тағайындау
CREATE USER admin_01 WITH PASSWORD 'AdminPass123';
CREATE USER doc_aslan WITH PASSWORD 'DocPass456';

GRANT med_admin TO admin_01;
GRANT doctor_role TO doc_aslan;

-- 3. КЕСТЕЛЕР ҚҰРУ (Физикалық модель)

-- Пациенттер кестесі
CREATE TABLE patient (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE
);
-- Сақтандыру полистері (1:1 байланысы)
CREATE TABLE insurance (
    insurance_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(patient_id),
    policy_number VARCHAR(50) UNIQUE NOT NULL
);

-- Дәрігерлер кестесі
CREATE TABLE doctor (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);


CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(patient_id),
    doctor_id INT REFERENCES doctor(doctor_id),
    appointment_date DATE NOT NULL
);
-- 4. ОҢТАЙЛАНДЫРУ (Индекстер)

-- Жұмыс өнімділігін арттыру үшін индекстерді қосу
CREATE INDEX idx_patient_iin ON patients(iin);
CREATE INDEX idx_service_date ON services(service_date);

-- 5. ТЕСТІЛІК МӘЛІМЕТТЕР (Test Data)
INSERT INTO patient (first_name, last_name, phone) VALUES
('Ali', 'Nurgali', '87001234567'),
('Aida', 'Zhumabek', '87007654321'),
('Dauren', 'Sagat', '87009876543'),
('Sara', 'Abil', '87003456789');

INSERT INTO doctor (full_name, specialization) VALUES
('Dr. Askar Bektay', 'Cardiology'),
('Dr. Gulnar Kassen', 'Pediatrics'),
('Dr. Nurlan Yessen', 'Orthopedics');

INSERT INTO insurance (patient_id, policy_number) VALUES
(1, 'INS-1001'),
(2, 'INS-1002'),
(3, 'INS-1003'),
(4, 'INS-1004');

INSERT INTO appointment (patient_id, doctor_id, appointment_date) VALUES
(1, 1, '2026-02-20'),
(2, 2, '2026-02-21'),
(3, 1, '2026-02-22'),
(4, 3, '2026-02-23'),
(2, 1, '2026-02-24');

-- 6. ТЕСТІЛІК СҰРАНЫСТАР (SQL Queries)

-- JOIN – Науқастардың дәрігерлері мен қабылдау күндері
SELECT p.first_name, p.last_name, d.full_name, a.appointment_date
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id;
-- GROUP BY – Қай дәрігер қанша пациент қабылдады
SELECT d.full_name, COUNT(a.appointment_id) AS total
FROM doctor d
JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.full_name;

--Агрегат функция – Барлық қабылдау саны
SELECT COUNT(*) FROM appointment;

-- Жаңа рөлдерді құру
CREATE ROLE med_admin;
CREATE ROLE doctor_role;

-- Рөлдерге рұқсаттар беру
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO med_admin;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA public TO doctor_role;

-- Пайдаланушыларды құру және рөлдерді тағайындау
CREATE USER admin_01 WITH PASSWORD 'AdminPass123';
CREATE USER doc_aslan WITH PASSWORD 'DocPass456';

GRANT med_admin TO admin_01;
GRANT doctor_role TO doc_aslan;

-- 3. КЕСТЕЛЕР ҚҰРУ (Физикалық модель)

-- Пациенттер кестесі
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    iin VARCHAR(12) UNIQUE NOT NULL,
    birth_date DATE CHECK (birth_date < CURRENT_DATE),
    address VARCHAR(300) DEFAULT 'Мекенжай көрсетілмеген'
);

-- Сақтандыру полистері (1:1 байланысы)
CREATE TABLE insurance (
    policy_id INT PRIMARY KEY,
    policy_num VARCHAR(50) UNIQUE NOT NULL,
    patient_id INT UNIQUE REFERENCES patients(patient_id),
    amount DECIMAL CHECK (amount > 0)
);

-- Дәрігерлер кестесі
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(200) NOT NULL,
    specialty VARCHAR(100) NOT NULL
);

-- Медициналық қызметтер кестесі (M:N байланысы)
CREATE TABLE services (
    service_id INT PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    service_name VARCHAR(200) NOT NULL,
    service_cost DECIMAL NOT NULL,
    service_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. ОҢТАЙЛАНДЫРУ (Индекстер)

-- Жұмыс өнімділігін арттыру үшін индекстерді қосу
CREATE INDEX idx_patient_iin ON patients(iin);
CREATE INDEX idx_service_date ON services(service_date);

-- 5. ТЕСТІЛІК МӘЛІМЕТТЕР (Test Data)
INSERT INTO patients VALUES (1, 'Ахметов Ербол', '900510300123', '1990-05-10', 'Алматы');
INSERT INTO patients VALUES (2, 'Серікова Айгерім', '950822400567', '1995-08-22', 'Астана');

INSERT INTO doctors VALUES (1, 'Досболұлы Қанат', 'Терапевт');
INSERT INTO doctors VALUES (2, 'Смағұлова Гүлнәр', 'Кардиолог');

INSERT INTO insurance VALUES (1, 'POL-001', 1, 500000);

INSERT INTO services VALUES (101, 1, 1, 'Консультация', 5000);
INSERT INTO services VALUES (102, 2, 2, 'ЭКГ', 15000);

-- 6. ТЕСТІЛІК СҰРАНЫСТАР (SQL Queries)

-- Бірнеше кестені біріктіру (JOIN)
SELECT p.full_name, s.service_name, d.doctor_name
FROM patients p
JOIN services s ON p.patient_id = s.patient_id
JOIN doctors d ON s.doctor_id = d.doctor_id;

-- Топтау және агрегаттық функциялар
SELECT patient_id, SUM(service_cost) AS total_sum
FROM services
GROUP BY patient_id
HAVING SUM(service_cost) > 10000;

-- Индекс тиімділігін тексеру
EXPLAIN ANALYZE SELECT * FROM patients WHERE iin = '900510300123';

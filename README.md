```mermaid
erDiagram
    PATIENTS ||--|| INSURANCE : "has"
    PATIENTS ||--o{ SERVICES : "receives"
    DOCTORS ||--o{ SERVICES : "provides"

    PATIENTS {
        int patient_id PK
        string full_name
        string iin UK
        date birth_date
        string address
    }
    INSURANCE {
        int policy_id PK
        string policy_num UK
        int patient_id FK
        decimal amount
    }
    DOCTORS {
        int doctor_id PK
        string doctor_name
        string specialty
    }
    SERVICES {
        int service_id PK
        int patient_id FK
        int doctor_id FK
        string service_name
        decimal service_cost
        datetime service_date
    }

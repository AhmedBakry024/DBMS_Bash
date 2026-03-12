# DBMS_Bash - A Bash-Based Relational Database Management System

**DBMS_Bash** is a lightweight, file-based relational database management system (RDBMS) implemented entirely using Bash shell scripting. It provides a robust platform for managing data without relying on external database services, making it an excellent educational tool for understanding database internals and shell scripting prowess.

## 🚀 Key Features

*   **Zero Dependencies**: Written purely in Bash, requiring only standard Unix utilities (sed, awk, grep, etc.).
*   **Dual Interface**:
    *   **Interactive Menu System**: User-friendly menus for easy navigation and operation.
    *   **SQL-Like CLI (`bsql`)**: Execute database commands using a syntax familiar to SQL users.
*   **Data Definition Language (DDL)**:
    *   Create and Drop Databases.
    *   Create and Drop Tables with customizable schema.
    *   **Schema Definition**: Define columns with data types (`int`, `string`) and enforce **Primary Key** constraints.
    *   **Metadata Management**: Stores table metadata separately for validation and integrity.
*   **Data Manipulation Language (DML)**:
    *   **Insert**: Add records with automatic type validation.
    *   **Select**: Retrieve data with column selection and `WHERE` clause filtering.
    *   **Update**: Modify existing records based on specific conditions.
    *   **Delete**: Remove records matching criteria.
*   **Data Integrity**: Basic type checking to ensure integer and string fields contain valid data.

## 📦 Installation & Setup

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/DBMS_Bash.git
    cd DBMS_Bash
    ```

2.  **Set Permissions**:
    Ensure the scripts are executable:
    ```bash
    chmod +x main_menu.sh bsql
    chmod +x commands/in_db/*.sh
    chmod +x commands/out_db/*.sh
    ```

3.  **Run the Application**:
    Start the interactive menu:
    ```bash
    ./main_menu.sh
    ```
    Or use the SQL CLI:
    ```bash
    ./bsql
    ```

## 📖 Usage Guide

### Interactive Menu Mode (`./main_menu.sh`)
The main menu guides you through database operations step-by-step:
1.  **Create Database**: Initialize a new database storage directory.
2.  **List Databases**: View all available databases.
3.  **Connect to Database**: Select a database to work with tables.
    *   Once connected, you can Create Tables, Insert, Select, Update, Delete data, and Drop Tables.
4.  **Drop Database**: Remove an entire database and its contents.

### SQL CLI Mode (`./bsql`)
Execute commands directly using SQL-style syntax:

*   **Database Operations**:
    *   `CREATE DATABASE mydb`
    *   `DROP DATABASE mydb`
    *   `USE mydb` - Connect to a database.

*   **Table Operations**:
    *   `CREATE TABLE users` - Starts interactive column definition.
    *   `DROP TABLE users`
    *   `SHOW TABLES`

*   **Data Operations**:
    *   **Insert**: `INSERT INTO users` (Interactive prompt for values).
    *   **Select**: `SELECT * FROM users` or `SELECT id,name FROM users WHERE id=1`
    *   **Update**: `UPDATE users SET name=Bob WHERE id=1`
    *   **Delete**: `DELETE FROM users WHERE id=1`

## 🏗 Project Structure

```
DBMS_Bash/
├── bsql                  # Command Line Interface (SQL Shell)
├── main_menu.sh          # Main interactive menu script
├── commands/             # Core logic scripts
│   ├── helper.sh         # Shared utility functions
│   ├── in_db/            # Table-level operations (CRUD)
│   │   ├── create_table.sh
│   │   ├── insert.sh
│   │   ├── select.sh
│   │   ├── update.sh
│   │   ├── delete.sh
│   │   └── ...
│   └── out_db/           # Database-level operations
│       ├── create_db.sh
│       ├── drop_db.sh
│       └── ...
├── databases/            # Data storage directory (created at runtime)
├── LICENSE               # License file
└── README.md             # Project documentation
```

## 🤝 Contributing
Contributions are welcome! Feel free to open issues or submit pull requests to improve functionality or fix bugs.

## 📄 License
This project is licensed under the [MIT License](LICENSE).
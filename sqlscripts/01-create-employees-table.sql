IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'Employees'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.Employees (
        EmployeeID   INT           IDENTITY(1,1) PRIMARY KEY,
        FirstName    NVARCHAR(50)  NOT NULL,
        LastName     NVARCHAR(50)  NOT NULL,
        Email        NVARCHAR(100) NOT NULL,
        HireDate     DATE          NOT NULL,
        Salary       DECIMAL(18,2) NOT NULL
    );
END;
GO

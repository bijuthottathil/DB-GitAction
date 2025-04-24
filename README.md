# Deploy SQL scripts to an Azure SQL Database using gitactions

In this basic example , I am using Azure Managed SQL instance

![image](https://github.com/user-attachments/assets/c14c0e37-f620-4a08-97e5-04cc1a87518d)

I opened DB connection using VS Code extension for SQL Database

![image](https://github.com/user-attachments/assets/3d3c8983-6d36-4f42-83c4-e65d977128bd)

In Github, there is sqlscripts folder and added 2 scripts for creating schema and scripts of table rows

![image](https://github.com/user-attachments/assets/8823ce60-27d0-4017-a075-e12c72a0eac4)

![image](https://github.com/user-attachments/assets/70e21650-df9f-4ec6-beab-b145df8f397c)

01-create-employees-table.sql
----------------------------

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

02-insert-employees-data
-----------------------

INSERT INTO dbo.Employees (FirstName, LastName, Email,       HireDate,   Salary) VALUES
 ('Alice',   'Johnson',   'alice.johnson@example.com',   '2020-01-15',  60000.00),
 ('Bob',     'Smith',     'bob.smith@example.com',       '2019-03-22',  75000.00),
 ('Carol',   'Wong',      'carol.wong@example.com',      '2021-06-30',  58000.00),
 ('David',   'Lee',       'david.lee@example.com',       '2018-11-05',  82000.00),
 ('Eva',     'Davis',     'eva.davis@example.com',       '2022-02-14',  55000.00),
 ('Frank',   'Miller',    'frank.miller@example.com',    '2017-07-19',  90000.00),
 ('Grace',   'Garcia',    'grace.garcia@example.com',    '2020-10-01',  64000.00),
 ('Hector',  'Lopez',     'hector.lopez@example.com',    '2019-12-12',  71000.00),
 ('Ivy',     'Patel',     'ivy.patel@example.com',       '2021-08-23',  60000.00);

GO

Action workflow file will looks like below

![image](https://github.com/user-attachments/assets/3966dde9-adb7-4f7a-8831-7fcb819feff6)

name: Deploy SQL Scripts

on:
  push:
    branches: [ main ]

jobs:
  deploy-sql:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Azure login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      # Execute the first script
      - name: Run schema setup
        uses: azure/sql-action@v2.3
        with:
          connection-string: ${{ secrets.AZURE_SQL_CONNECTION_STRING }}
          path: 'sqlscripts/01-create-employees-table.sql'
          skip-firewall-check: false

      # Execute the second script
      - name: Insert sample data
        uses: azure/sql-action@v2.3
        with:
          connection-string: ${{ secrets.AZURE_SQL_CONNECTION_STRING }}
          path: 'sqlscripts/02-insert-employees-data.sql'
          skip-firewall-check: false



      2 secret variables are defined in git setting

      ![image](https://github.com/user-attachments/assets/33a77a32-0bfa-4dcd-a208-4b37b1e45160)

      I ran from Azure CLI to get secrets

      az ad sp create-for-rbac --name "my-service-principal" --role contributor --scopes /subscriptions/your-subscription-id--sdk-auth![image](https://github.com/user-attachments/assets/102f666f-2fe3-4674-bbed-1524209d6e78)

      Generated value is stored in secrets.AZURE_CREDENTIALS
      SQL Connection string from cloud is added in secrets.AZURE_SQL_CONNECTION_STRING 


      #Running Workflow file

      I dont have any table in DB

      ![image](https://github.com/user-attachments/assets/37d61884-0429-422b-82c4-0abde0b3cf0b)

      Ran workflow file

      ![image](https://github.com/user-attachments/assets/31fbd890-5a09-49a8-8a75-a3bd2324053a)
     
    ![image](https://github.com/user-attachments/assets/4660512d-81cf-4e3d-89ca-5a7c1832dc49)

    According to git log, sql statements are executed successfully

    Refer VSCode and check DB

    1st script created table structure and 2nd script inserted records mentioned in 2nd script

    ![image](https://github.com/user-attachments/assets/fd80fa91-1bd5-433f-a9e5-f0495b7fd437)


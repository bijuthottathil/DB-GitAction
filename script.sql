
IF NOT EXISTS (SELECT * 
               FROM sys.tables 
               WHERE name = 'customer' 
                 AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.customer (
        id INT ,
        customername NVARCHAR(100)
    );
insert into dbo.customer values (1,'biju');
END;

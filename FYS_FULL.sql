USE [master]
GO
/****** Object:  Database [fys_1]    Script Date: 5.01.2025 15:50:05 ******/
CREATE DATABASE [fys_1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'fys_1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\fys_1.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'fys_1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\fys_1_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [fys_1] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [fys_1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [fys_1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [fys_1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [fys_1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [fys_1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [fys_1] SET ARITHABORT OFF 
GO
ALTER DATABASE [fys_1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [fys_1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [fys_1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [fys_1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [fys_1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [fys_1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [fys_1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [fys_1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [fys_1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [fys_1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [fys_1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [fys_1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [fys_1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [fys_1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [fys_1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [fys_1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [fys_1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [fys_1] SET RECOVERY FULL 
GO
ALTER DATABASE [fys_1] SET  MULTI_USER 
GO
ALTER DATABASE [fys_1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [fys_1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [fys_1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [fys_1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [fys_1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [fys_1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'fys_1', N'ON'
GO
ALTER DATABASE [fys_1] SET QUERY_STORE = ON
GO
ALTER DATABASE [fys_1] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [fys_1]
GO
/****** Object:  UserDefinedTableType [dbo].[Service_Type]    Script Date: 5.01.2025 15:50:05 ******/
CREATE TYPE [dbo].[Service_Type] AS TABLE(
	[value] [nvarchar](50) NULL
)
GO
/****** Object:  Table [dbo].[BILL]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BILL](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[due_date] [date] NOT NULL,
	[paid_date] [date] NULL,
	[status] [nvarchar](50) NOT NULL,
	[billing_unit] [nvarchar](50) NOT NULL,
	[unit_usage] [decimal](10, 2) NOT NULL,
	[user_id] [int] NOT NULL,
	[remaining_amount] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVOICE]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVOICE](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[file_path] [nvarchar](255) NOT NULL,
	[bill_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTIFICATION]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTIFICATION](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[message] [nvarchar](255) NOT NULL,
	[notification_type] [nvarchar](50) NOT NULL,
	[user_id] [int] NOT NULL,
	[is_read] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAYMENT]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAYMENT](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[amount_paid] [decimal](10, 2) NOT NULL,
	[payment_date] [datetime] NOT NULL,
	[payment_method] [nvarchar](50) NOT NULL,
	[bill_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SERVICE_PROVIDER]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SERVICE_PROVIDER](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[service_type] [nvarchar](50) NOT NULL,
	[contact_info] [nvarchar](255) NULL,
	[unit_price] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SYSTEM_SETTINGS]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTEM_SETTINGS](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[setting_key] [nvarchar](100) NOT NULL,
	[setting_value] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[setting_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USER_SERVICE_PROVIDER]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_SERVICE_PROVIDER](
	[user_id] [int] NOT NULL,
	[service_provider_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[service_provider_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[email] [nvarchar](150) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[phone_number] [nvarchar](15) NULL,
	[address] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BILL] ADD  DEFAULT ((0)) FOR [remaining_amount]
GO
ALTER TABLE [dbo].[NOTIFICATION] ADD  DEFAULT ((0)) FOR [is_read]
GO
ALTER TABLE [dbo].[PAYMENT] ADD  DEFAULT (getdate()) FOR [payment_date]
GO
ALTER TABLE [dbo].[BILL]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INVOICE]  WITH CHECK ADD FOREIGN KEY([bill_id])
REFERENCES [dbo].[BILL] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NOTIFICATION]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAYMENT]  WITH CHECK ADD FOREIGN KEY([bill_id])
REFERENCES [dbo].[BILL] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_SERVICE_PROVIDER]  WITH CHECK ADD FOREIGN KEY([service_provider_id])
REFERENCES [dbo].[SERVICE_PROVIDER] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_SERVICE_PROVIDER]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BILL]  WITH CHECK ADD  CONSTRAINT [CK__BILL__billing_unit] CHECK  (([billing_unit]='GB' OR [billing_unit]='m³' OR [billing_unit]='kWh'))
GO
ALTER TABLE [dbo].[BILL] CHECK CONSTRAINT [CK__BILL__billing_unit]
GO
ALTER TABLE [dbo].[BILL]  WITH CHECK ADD CHECK  (([status]='Kısmi Ödenmiş' OR [status]='Ödenmemiş' OR [status]='Ödenmiş'))
GO
ALTER TABLE [dbo].[NOTIFICATION]  WITH CHECK ADD CHECK  (([notification_type]='Uygulama Bildirimi' OR [notification_type]='Email' OR [notification_type]='SMS'))
GO
ALTER TABLE [dbo].[PAYMENT]  WITH CHECK ADD CHECK  (([payment_method]='Nakit' OR [payment_method]='Banka Transferi' OR [payment_method]='Kredi Kartı'))
GO
ALTER TABLE [dbo].[SERVICE_PROVIDER]  WITH CHECK ADD CHECK  (([service_type]='İnternet' OR [service_type]='Su' OR [service_type]='Elektrik'))
GO
/****** Object:  StoredProcedure [dbo].[ProcessPayment]    Script Date: 5.01.2025 15:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcessPayment]
    @bill_id INT,
    @amount_paid DECIMAL(10,2),
    @payment_method NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Fatura ID'nin varlığını kontrol et
        IF NOT EXISTS (SELECT 1 FROM BILL WHERE id = @bill_id)
        BEGIN
            RAISERROR('Geçersiz fatura ID.', 16, 1);
            RETURN;
        END

        -- Fazla ödeme kontrolü
        DECLARE @total_amount DECIMAL(10,2);
        DECLARE @remaining_amount DECIMAL(10,2);

        SELECT @total_amount = amount, @remaining_amount = remaining_amount
        FROM BILL
        WHERE id = @bill_id;

        IF @remaining_amount < @amount_paid
        BEGIN
			PRINT 'Kalan tutar: ' + STR(@remaining_amount, 10, 2);
			RAISERROR('Ödeme miktarı kalan tutarı aşamaz. Lütfen kalan tutarı kontrol edin.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Ödeme bilgilerini ekle
        INSERT INTO PAYMENT (amount_paid, payment_date, payment_method, bill_id)
        VALUES (@amount_paid, GETDATE(), @payment_method, @bill_id);

        -- Kalan tutarı güncelle
        SET @remaining_amount = @remaining_amount - @amount_paid;

        UPDATE BILL
        SET remaining_amount = @remaining_amount
        WHERE id = @bill_id;

        -- Fatura durumu güncelle
        IF @remaining_amount = 0
        BEGIN
            UPDATE BILL
            SET status = 'Ödenmiş', paid_date = GETDATE()
            WHERE id = @bill_id;
        END
        ELSE
        BEGIN
            UPDATE BILL
            SET status = 'Kısmi Ödenmiş'
            WHERE id = @bill_id;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Hata durumunda işlemi geri al ve hata mesajını döndür
        ROLLBACK TRANSACTION;
        DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Hata: %s', 16, 1, @error_message);
    END CATCH;
END;
GO
USE [master]
GO
ALTER DATABASE [fys_1] SET  READ_WRITE 
GO

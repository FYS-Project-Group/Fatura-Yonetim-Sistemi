-- 1.TABLOLARIN OLU�TURULMASI

-- USERS Tablosu
CREATE TABLE USERS (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(15),
    address NVARCHAR(255)
);

-- SERVICE_PROVIDER Tablosu
CREATE TABLE SERVICE_PROVIDER (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    service_type NVARCHAR(50) NOT NULL CHECK (service_type IN ('Elektrik', 'Su', '�nternet')),
    contact_info NVARCHAR(255),
    unit_price DECIMAL(10,2) NOT NULL
);

-- USER_SERVICE_PROVIDER Tablosu
CREATE TABLE USER_SERVICE_PROVIDER (
    user_id INT NOT NULL,
    service_provider_id INT NOT NULL,
    PRIMARY KEY (user_id, service_provider_id),
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE,
    FOREIGN KEY (service_provider_id) REFERENCES SERVICE_PROVIDER (id) ON DELETE CASCADE
);

-- BILL Tablosu
CREATE TABLE BILL (
    id INT PRIMARY KEY IDENTITY(1,1),
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('�denmi�', '�denmemi�', 'K�smi �denmi�')),
    billing_unit NVARCHAR(50) NOT NULL CHECK (billing_unit IN ('kWh', 'm�', 'GB')),
    unit_usage DECIMAL(10,2) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE
);

-- PAYMENT Tablosu
CREATE TABLE PAYMENT (
    id INT PRIMARY KEY IDENTITY(1,1),
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT GETDATE(),
    payment_method NVARCHAR(50) NOT NULL CHECK (payment_method IN ('Kredi Kart�', 'Banka Transferi', 'Nakit')),
    bill_id INT NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES BILL (id) ON DELETE CASCADE
);

-- NOTIFICATION Tablosu
CREATE TABLE NOTIFICATION (
    id INT PRIMARY KEY IDENTITY(1,1),
    message NVARCHAR(255) NOT NULL,
    notification_type NVARCHAR(50) NOT NULL CHECK (notification_type IN ('SMS', 'Email', 'Uygulama Bildirimi')),
    user_id INT NOT NULL,
    is_read BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE
);

-- INVOICE Tablosu
CREATE TABLE INVOICE (
    id INT PRIMARY KEY IDENTITY(1,1),
    file_path NVARCHAR(255) NOT NULL,
    bill_id INT NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES BILL (id) ON DELETE CASCADE
);


-- 2. TABLOLARA �RNEK VER� EKLEN�M�

INSERT INTO USERS (name, email, password, phone_number, address)
VALUES
('Ali Veli', 'ali@ornek.com', '******', '555-111-1111', '�stanbul, T�rkiye'),
('Ay�e Y�lmaz', 'ayse@ornek.com', '******', '555-222-2222', 'Ankara, T�rkiye'),
('ServisAdmin', 'admin@servis.com', '******', '555-333-3333', '�zmir, T�rkiye'),
('Y�netici', 'yonetici@ornek.com', '******', '555-444-4444', 'Antalya, T�rkiye');

INSERT INTO SERVICE_PROVIDER (name, service_type, contact_info, unit_price)
VALUES
('Elektrik A�', 'Elektrik', 'elektrik@servis.com', 1.2),
('Su Da��t�m A�', 'Su', 'su@servis.com', 0.9),
('�nternet A�', '�nternet', 'internet@servis.com', 50.0);

INSERT INTO USER_SERVICE_PROVIDER (user_id, service_provider_id)
VALUES
(1, 1),  -- Kullan�c� 1, Elektrik A�
(1, 2),  -- Kullan�c� 1, Su Da��t�m A�
(2, 3),  -- Kullan�c� 2, �nternet A�
(2, 2);  -- Kullan�c� 2, Su A�

INSERT INTO BILL (amount, due_date, paid_date, status, billing_unit, unit_usage, user_id)
VALUES
(100.0, '2024-01-01', '2024-01-05', '�denmi�', 'kWh', 80, 1),
(50.0, '2024-02-01', NULL, '�denmemi�', 'm�', 10, 1),
(150.0, '2024-01-10', NULL, 'K�smi �denmi�', 'GB', 30, 1);

INSERT INTO PAYMENT (amount_paid, payment_date, payment_method, bill_id)
VALUES
(100.0, '2024-01-05', 'Kredi Kart�', 1),
(50.0, '2024-02-01', 'Banka Transferi', 2),
(50.0, '2024-01-10', 'Nakit', 3);

INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
VALUES
('Faturan�z �denmi�tir.', 'Email', 1, 1),
('Son �deme tarihi yakla��yor.', 'SMS', 2, 0),
('K�smi �deme yap�ld�.', 'Uygulama Bildirimi', 2, 1);

INSERT INTO INVOICE (file_path, bill_id)
VALUES
('/invoices/invoice1.pdf', 1),
('/invoices/invoice2.pdf', 2),
('/invoices/invoice3.pdf', 3);


-- 3. Gereksinimlere g�re �rnek script senaryolar�

-- 1. M��teri Gereksinimleri

-- 1.a) M��terinin Fatura G�r�nt�lemesi

-- Faturalar�n� g�r�nt�leyen kullan�c� i�in parametre
DECLARE @user_id INT = 1;

-- Kullan�c�n�n faturalar�n� listele
SELECT 
    b.id AS bill_id, 
    b.amount, 
    b.due_date, 
    b.status,
    b.remaining_amount,
    sp.name AS service_provider_name
FROM BILL b
INNER JOIN SERVICE_PROVIDER sp ON b.service_provider_id = sp.id
WHERE b.user_id = @user_id;


-- 1.b) M��terinin Bir Faturay� �demesi

-- Bunun i�in stored procedure olarak Process Payment ad�nda programlanabilir bir script yazd�k.
EXEC ProcessPayment @bill_id = 14, @amount_paid = 50.0, @payment_method = 'Kredi Kart�';

-- 1.c) M��terinin �deme Ge�mi�ini G�r�nt�leme

-- Kullan�c� ID'si �zerinden �deme ge�mi�ini sorgulama
DECLARE @user_id INT = 1; -- �deme ge�mi�ini g�r�nt�lemek isteyen kullan�c�n�n ID'si

-- Kullan�c�n�n �deme yapt��� faturalar� ve �deme detaylar�n� listeleme
SELECT 
    p.id AS payment_id,
    p.amount_paid,
    p.payment_date,
    p.payment_method,
    b.id AS bill_id,
    b.amount AS bill_amount,
    b.due_date,
    b.paid_date,
    b.status
FROM PAYMENT p
INNER JOIN BILL b ON p.bill_id = b.id
WHERE b.user_id = @user_id
ORDER BY p.payment_date DESC;



-- 1.d) M��terinin Bildirim Ge�mi�ini G�rme

-- Bildirimleri g�r�nt�leyecek kullan�c� i�in parametre
DECLARE @user_id INT = 2;

-- Kullan�c�n�n bildirimlerini listele
SELECT n.id AS notification_id,
       n.message,
       n.notification_type,
       CASE 
           WHEN n.is_read = 1 THEN 'Okundu'
           ELSE 'Okunmad�'
       END AS read_status,
       n.is_read,
       n.user_id
FROM NOTIFICATION n
WHERE n.user_id = @user_id
ORDER BY n.is_read ASC, n.id DESC; -- �nce okunmam�� bildirimler


-- 1.e) M��terinin �demesini Yapt��� Fi�lerin(INVOICE) G�r�nt�lenmesi

DECLARE @user_id INT = 1;

-- Kullan�c�n�n �denmi� faturalar�na ait belgeleri listele
SELECT b.id AS bill_id,
       b.amount,
       b.due_date,
       b.paid_date,
       b.status,
       i.file_path AS invoice_path
FROM BILL b
INNER JOIN INVOICE i ON b.id = i.bill_id
WHERE b.user_id = @user_id
  AND b.status = '�denmi�'
ORDER BY b.paid_date DESC;



-- 2. Servis Sa�lay�c� Gereksinimleri


-- 2.a Servis Sa�lay�c�n�n Bir M��teriye Ait Fatura Olu�turmas�

DECLARE @service_type NVARCHAR(50) = 'Su'; -- Se�ilecek hizmet t�r� (Elektrik, Su, �nternet)
DECLARE @user_id INT = 2; -- Kullan�c� ID
DECLARE @unit_usage DECIMAL(10,2) = 150.0; -- Kullan�m miktar�
DECLARE @due_date DATE = DATEADD(DAY, 30, GETDATE()); -- Son �deme tarihi
DECLARE @status NVARCHAR(50) = '�denmemi�'; -- Varsay�lan durum
DECLARE @billing_unit NVARCHAR(50); -- Hizmet t�r�ne g�re belirlenecek birim

-- Hizmet t�r�ne g�re billing_unit belirleme
SELECT TOP 1 @billing_unit = 
    CASE 
        WHEN @service_type = 'Elektrik' THEN 'kWh'
        WHEN @service_type = 'Su' THEN 'm�'
        WHEN @service_type = '�nternet' THEN 'GB'
        ELSE NULL
    END;

IF @billing_unit IS NULL
BEGIN
    RAISERROR('Ge�ersiz hizmet t�r�.', 16, 1);
    RETURN;
END;

-- Fatura olu�turma
INSERT INTO BILL (amount, due_date, status, billing_unit, unit_usage, user_id, remaining_amount)
SELECT 
    sp.unit_price * @unit_usage AS amount, -- Tutar hesaplan�yor
    @due_date AS due_date,
    @status AS status,
    @billing_unit AS billing_unit,
    @unit_usage AS unit_usage,
    @user_id AS user_id,
    sp.unit_price * @unit_usage AS remaining_amount -- Kalan tutar e�itleniyor
FROM USER_SERVICE_PROVIDER usp
JOIN SERVICE_PROVIDER sp ON usp.service_provider_id = sp.id
WHERE usp.user_id = @user_id
  AND sp.service_type = @service_type; -- Dinamik hizmet t�r� se�imi




-- 2.b Servis Sa�lay�c�n�n M��teriye Ait Bir Faturan�n G�ncellenmesi

DECLARE @bill_id INT = 1; -- G�ncellenecek fatura ID'si
DECLARE @new_due_date DATE = '2024-03-15';

UPDATE BILL
SET due_date = @new_due_date
WHERE id = @bill_id;


-- 2.c Servis Sa�lay�c�n�n M��terilerine Ait Fatura Detaylar�n�n G�r�nt�lenmesi
DECLARE @service_provider_id INT = 3;

SELECT b.id AS bill_id,
       b.amount,
       b.due_date,
       b.paid_date,
       b.status,
       b.billing_unit,
       b.unit_usage,
       u.name AS customer_name,
       u.email
FROM BILL b
JOIN USERS u ON b.user_id = u.id
JOIN USER_SERVICE_PROVIDER usp ON u.id = usp.user_id
WHERE usp.service_provider_id = @service_provider_id
ORDER BY b.due_date ASC;


-- 2.d Servis Sa�lay�c�n�n M��terilerine Toplu Bildirim G�ndermesi

DECLARE @message NVARCHAR(255) = 'Yeni fiyat tarifesi bilgisi!';
DECLARE @notification_type NVARCHAR(50) = 'Email';
DECLARE @service_provider_id INT = 2;

INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
SELECT @message, @notification_type, usp.user_id, 0
FROM USER_SERVICE_PROVIDER usp
WHERE usp.service_provider_id = @service_provider_id;



-- 2.e Bir Servis Sa�lay�c�n�n Kendisine Ba�l� M��terilerini G�rmesi

DECLARE @service_provider_id INT = 2;

SELECT u.id AS customer_id,
       u.name AS customer_name,
       u.email,
       u.phone_number
FROM USERS u
JOIN USER_SERVICE_PROVIDER usp ON u.id = usp.user_id
WHERE usp.service_provider_id = @service_provider_id
ORDER BY u.name ASC;


-- 2.e Bir Servis Sa�lay�c�n�n Hizmet Birim Fiyat�n� G�ncellemesi

DECLARE @service_provider_id INT = 1;
DECLARE @new_unit_price DECIMAL(10,2) = 1.5;

UPDATE SERVICE_PROVIDER
SET unit_price = @new_unit_price
WHERE id = @service_provider_id;



-- 2.f Bir Servis Sa�lay�c�n�n M��terilerinin �deme Durumlar�n� Takip Etmesi

DECLARE @service_provider_id INT = 2;

SELECT b.id AS bill_id,
       b.amount,
       b.due_date,
       b.paid_date,
       b.status,
       u.name AS customer_name,
       u.email
FROM BILL b
JOIN USERS u ON b.user_id = u.id
JOIN USER_SERVICE_PROVIDER usp ON u.id = usp.user_id
WHERE usp.service_provider_id = @service_provider_id
ORDER BY b.status ASC, b.due_date ASC;

-- E�er sadece bir m��terisinin durumunu takip etmek isterse

DECLARE @service_provider_id INT = 1; -- Servis sa�lay�c�n�n ID'si
DECLARE @user_id INT = 1; -- Kullan�c�n�n ID'si

SELECT b.id AS bill_id,
       b.amount,
       b.due_date,
       b.paid_date,
       b.status,
       b.billing_unit,
       b.unit_usage
FROM BILL b
JOIN USERS u ON b.user_id = u.id
JOIN USER_SERVICE_PROVIDER usp ON u.id = usp.user_id
WHERE usp.service_provider_id = @service_provider_id
  AND u.id = @user_id
ORDER BY b.due_date ASC;


-- 3. Y�netici Gereksinimleri

-- 3.a Yeni Kullan�c� Olu�turma

DECLARE @name NVARCHAR(100) = 'Zehra �elik';
DECLARE @email NVARCHAR(150) = 'zehra@ornek.com';
DECLARE @password NVARCHAR(100) = '******';
DECLARE @phone_number NVARCHAR(15) = '555-555-5555';
DECLARE @address NVARCHAR(255) = '�stanbul, T�rkiye';

INSERT INTO USERS (name, email, password, phone_number, address)
VALUES (@name, @email, @password, @phone_number, @address);


-- 3.b Bir Kullan�c�y� G�ncelleme

DECLARE @user_id INT = 1;
DECLARE @new_email NVARCHAR(150) = 'ali.veli@ornek.com';
DECLARE @new_phone NVARCHAR(15) = '555-666-7777';
DECLARE @new_address NVARCHAR(255) = 'Ankara, T�rkiye';

UPDATE USERS
SET email = @new_email,
    phone_number = @new_phone,
    address = @new_address
WHERE id = @user_id;


-- 3.c Bir Kullan�c�y� Silme

DECLARE @user_id INT = 6;

DELETE FROM USERS
WHERE id = @user_id;


-- 3.d Yeni Servis Sa�lay�c� Eklenmesi
DECLARE @name NVARCHAR(100) = 'Marsu A�';
DECLARE @service_type NVARCHAR(50) = 'Su';
DECLARE @contact_info NVARCHAR(255) = 'marsu@servis.com';
DECLARE @unit_price DECIMAL(10,2) = 2.5;

INSERT INTO SERVICE_PROVIDER (name, service_type, contact_info, unit_price)
VALUES (@name, @service_type, @contact_info, @unit_price)



-- 3.e Bir Servis Sa�lay�c�n�n G�ncellenmesi

DECLARE @service_provider_id INT = 5;
DECLARE @new_unit_price DECIMAL(10,2) = 1.5;

UPDATE SERVICE_PROVIDER
SET unit_price = @new_unit_price
WHERE id = @service_provider_id;




-- 3.f Bir Servis Sa�lay�c�n�n Silinmesi

DECLARE @service_provider_id INT = 5;

DELETE FROM SERVICE_PROVIDER
WHERE id = @service_provider_id;




-- 3.g Sistem Ayar� Eklemek

-- Sistem ayarlar� tablosu olu�turma
CREATE TABLE SYSTEM_SETTINGS (
    id INT PRIMARY KEY IDENTITY(1,1),
    setting_key NVARCHAR(100) UNIQUE NOT NULL,
    setting_value NVARCHAR(255) NOT NULL
);
-- Yeni bir sistem ayar� ekleme
DECLARE @setting_key NVARCHAR(100) = 'notification_enabled';
DECLARE @setting_value NVARCHAR(255) = 'true';

INSERT INTO SYSTEM_SETTINGS (setting_key, setting_value)
VALUES (@setting_key, @setting_value);


-- 3.h Sistem Ayar�n� G�ncellemek
-- Mevcut bir ayar� g�ncelleme
DECLARE @setting_key NVARCHAR(100) = 'notification_enabled';
DECLARE @new_setting_value NVARCHAR(255) = 'false';

UPDATE SYSTEM_SETTINGS
SET setting_value = @new_setting_value
WHERE setting_key = @setting_key;

-- 3.i T�m Kullan�c�lara Genel Bildirim G�nderilmesi

DECLARE @message NVARCHAR(255) = 'Sistem bak�m� yap�lacakt�r.';
DECLARE @notification_type NVARCHAR(50) = 'Email';

INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
SELECT @message, @notification_type, u.id, 0
FROM USERS u;

-- 3.j Belirli Bir Kullan�c� Grubuna Bildirim G�nderimi

-- Belirli bir gruba (�rne�in, belirli bir servis sa�lay�c�ya ba�l� olan kullan�c�lar) bildirim g�nderimi
DECLARE @message NVARCHAR(255) = 'Yeni fiyat tarifesi bilgisi!';
DECLARE @notification_type NVARCHAR(50) = 'SMS';
DECLARE @service_provider_id INT = 1;

INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
SELECT @message, @notification_type, usp.user_id, 0
FROM USER_SERVICE_PROVIDER usp
WHERE usp.service_provider_id = @service_provider_id;





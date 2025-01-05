ALTER PROCEDURE [dbo].[ProcessPayment]
    @bill_id INT,
    @amount_paid DECIMAL(10,2),
    @payment_method NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Fatura ID'nin varl���n� kontrol et
        IF NOT EXISTS (SELECT 1 FROM BILL WHERE id = @bill_id)
        BEGIN
            RAISERROR('Ge�ersiz fatura ID.', 16, 1);
            RETURN;
        END

        -- �deme bilgilerini ekle
        INSERT INTO PAYMENT (amount_paid, payment_date, payment_method, bill_id)
        VALUES (@amount_paid, GETDATE(), @payment_method, @bill_id);

        -- Faturan�n kalan tutar�n� hesapla
        DECLARE @total_amount DECIMAL(10,2);
        DECLARE @paid_amount DECIMAL(10,2);
        DECLARE @remaining_amount DECIMAL(10,2);

        SELECT @total_amount = amount FROM BILL WHERE id = @bill_id;
        SELECT @paid_amount = ISNULL(SUM(amount_paid), 0) FROM PAYMENT WHERE bill_id = @bill_id;

        SET @remaining_amount = @total_amount - @paid_amount;

        -- Kalan tutar negatif olmamal�
        IF @remaining_amount < 0
        BEGIN
            RAISERROR('�deme miktar�, toplam fatura tutar�n� a�amaz.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Fatura durumu g�ncelle
        IF @remaining_amount = 0
        BEGIN
            UPDATE BILL
            SET status = '�denmi�', paid_date = GETDATE()
            WHERE id = @bill_id;
        END
        ELSE
        BEGIN
            UPDATE BILL
            SET status = 'K�smi �denmi�'
            WHERE id = @bill_id;
        END

        -- Kullan�c�ya bildirim g�nder
        DECLARE @user_id INT;
        DECLARE @notification_message NVARCHAR(255);

        SELECT @user_id = user_id FROM BILL WHERE id = @bill_id;

        SET @notification_message = CONCAT('Fatura ID ', @bill_id, 
                                           ' i�in ', CAST(@amount_paid AS NVARCHAR(50)), 
                                           ' TL �deme yap�lm��t�r.');

        INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
        VALUES (@notification_message, 'Email', @user_id, 0);

        -- ��lemi tamamla
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Hata durumunda i�lemi geri al ve hata mesaj� ver
        ROLLBACK TRANSACTION;
        RAISERROR('Hata: %s', 16, 1, ERROR_MESSAGE());
    END CATCH;
END;

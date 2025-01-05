ALTER PROCEDURE [dbo].[ProcessPayment]
    @bill_id INT,
    @amount_paid DECIMAL(10,2),
    @payment_method NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Fatura ID'nin varlýðýný kontrol et
        IF NOT EXISTS (SELECT 1 FROM BILL WHERE id = @bill_id)
        BEGIN
            RAISERROR('Geçersiz fatura ID.', 16, 1);
            RETURN;
        END

        -- Ödeme bilgilerini ekle
        INSERT INTO PAYMENT (amount_paid, payment_date, payment_method, bill_id)
        VALUES (@amount_paid, GETDATE(), @payment_method, @bill_id);

        -- Faturanýn kalan tutarýný hesapla
        DECLARE @total_amount DECIMAL(10,2);
        DECLARE @paid_amount DECIMAL(10,2);
        DECLARE @remaining_amount DECIMAL(10,2);

        SELECT @total_amount = amount FROM BILL WHERE id = @bill_id;
        SELECT @paid_amount = ISNULL(SUM(amount_paid), 0) FROM PAYMENT WHERE bill_id = @bill_id;

        SET @remaining_amount = @total_amount - @paid_amount;

        -- Kalan tutar negatif olmamalý
        IF @remaining_amount < 0
        BEGIN
            RAISERROR('Ödeme miktarý, toplam fatura tutarýný aþamaz.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Fatura durumu güncelle
        IF @remaining_amount = 0
        BEGIN
            UPDATE BILL
            SET status = 'Ödenmiþ', paid_date = GETDATE()
            WHERE id = @bill_id;
        END
        ELSE
        BEGIN
            UPDATE BILL
            SET status = 'Kýsmi Ödenmiþ'
            WHERE id = @bill_id;
        END

        -- Kullanýcýya bildirim gönder
        DECLARE @user_id INT;
        DECLARE @notification_message NVARCHAR(255);

        SELECT @user_id = user_id FROM BILL WHERE id = @bill_id;

        SET @notification_message = CONCAT('Fatura ID ', @bill_id, 
                                           ' için ', CAST(@amount_paid AS NVARCHAR(50)), 
                                           ' TL ödeme yapýlmýþtýr.');

        INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
        VALUES (@notification_message, 'Email', @user_id, 0);

        -- Ýþlemi tamamla
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Hata durumunda iþlemi geri al ve hata mesajý ver
        ROLLBACK TRANSACTION;
        RAISERROR('Hata: %s', 16, 1, ERROR_MESSAGE());
    END CATCH;
END;

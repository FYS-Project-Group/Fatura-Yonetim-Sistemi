USE [fys_1]
GO
/****** Object:  Trigger [dbo].[AfterBillUpdate]    Script Date: 31.12.2024 13:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[AfterBillUpdate]
ON [dbo].[BILL]
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Çoklu satýr güncelleme için cursor kullanýmý
        DECLARE @bill_id INT;
        DECLARE @new_status NVARCHAR(50);
        DECLARE @user_id INT;
        DECLARE @notification_message NVARCHAR(255);

        DECLARE cursor_inserted CURSOR FOR
        SELECT id, status, user_id FROM inserted;

        OPEN cursor_inserted;

        FETCH NEXT FROM cursor_inserted INTO @bill_id, @new_status, @user_id;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Duruma göre bildirim oluþtur
            IF @new_status = 'Ödenmiþ'
            BEGIN
                SET @notification_message = CONCAT('Fatura ID ', @bill_id, ' baþarýyla ödenmiþtir. Teþekkür ederiz!');
            END
            ELSE IF @new_status = 'Kýsmi Ödenmiþ'
            BEGIN
                SET @notification_message = CONCAT('Fatura ID ', @bill_id, ' için kalan ödeme bulunmaktadýr.');
            END

            -- Bildirimi ekle
            INSERT INTO NOTIFICATION (message, notification_type, user_id, is_read)
            VALUES (@notification_message, 'SMS', @user_id, 0);

            FETCH NEXT FROM cursor_inserted INTO @bill_id, @new_status, @user_id;
        END;

        CLOSE cursor_inserted;
        DEALLOCATE cursor_inserted;
    END TRY
    BEGIN CATCH
        PRINT 'Tetikleyicide hata: ' + ERROR_MESSAGE();
    END CATCH;
END;

package com.dicore.fatura_yonetim_sistemi.dtos.response;

import com.dicore.fatura_yonetim_sistemi.enums.PaymentMethod;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PaymentResponseDTO {

    private Long id;

    private Long billId;

    private Long userId;

    private BigDecimal amountPaid;

    private PaymentMethod paymentMethod;

    private LocalDateTime paymentDate;
}

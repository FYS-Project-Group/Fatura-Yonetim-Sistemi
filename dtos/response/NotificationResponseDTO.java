package com.dicore.fatura_yonetim_sistemi.dtos.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NotificationResponseDTO {

    private Long id;

    private String message;

    private Long userId;

    @JsonProperty("isRead")
    private boolean isRead;
}


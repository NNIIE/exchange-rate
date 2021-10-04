package com.example.exchange.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Exchange {
    private String remittanceCountry; // 송금국가
    private String receptionCountry; // 수취국가
    private Double exchangeRate; // 환율
}

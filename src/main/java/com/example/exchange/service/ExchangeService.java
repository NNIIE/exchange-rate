package com.example.exchange.service;

import com.example.exchange.vo.Exchange;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class ExchangeService {

    public List<Exchange> exchangeRate(HashMap<String, String> response) {

        List<Exchange> exchange = new ArrayList<>();
        HashMap<String, Object> map = new HashMap<String, Object>();

        try {
            JSONObject json = new JSONObject(String.valueOf(response.get("exchange")));
            JSONObject quotes = (JSONObject) json.get("quotes");

            String country = response.get("country");
            Double exchangeRate = (Double) quotes.get(country);

            exchange.add(new Exchange("USD", country, exchangeRate));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exchange;
    }
}

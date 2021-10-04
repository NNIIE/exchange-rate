package com.example.exchange.controller;

import com.example.exchange.service.ExchangeService;
import com.example.exchange.vo.Exchange;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@RestController
public class ExchangeController {
    private ExchangeService service;

    public ExchangeController(ExchangeService service) {
        this.service = service;
    }

    @GetMapping("/exchange/{receptionCountry}")
    public List<Exchange> exchangeRate(@PathVariable String receptionCountry) throws IOException {

        String urlStr = "http://www.apilayer.net/api/live?access_key=ee50cd7cc73c9b7a7bb3d9617cfb6b9c";
        URL url = new URL(urlStr);

        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("GET");

        BufferedReader br;
        br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));

        String inputLine;
        StringBuffer response = new StringBuffer();

        while((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }

        urlConnection.disconnect();
        br.close();

        HashMap<String, String> map = new HashMap<String, String>();
        List<Exchange> result = new ArrayList<>();
        map.put("country", receptionCountry);
        map.put("exchange", response.toString());

        result = service.exchangeRate(map);

        if(result.isEmpty()) {
            throw new NullPointerException(String.format("receptionCountry[%s] not found", receptionCountry));
        }

        return result;
    }
}

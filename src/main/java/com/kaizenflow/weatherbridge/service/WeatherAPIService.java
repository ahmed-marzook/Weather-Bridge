/*
 * Copyright 2024 KaizenFlow. All rights reserved.
 */
package com.kaizenflow.weatherbridge.service;

import com.kaizenflow.weatherbridge.model.Day;
import com.kaizenflow.weatherbridge.model.WeatherResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.ObjectMapper;

import reactor.core.publisher.Mono;

@Service
public class WeatherAPIService {

  private WebClient webClient;

  @Autowired
  public WeatherAPIService(WebClient webClient) {
    this.webClient = webClient;
  }

  public void getWeatherForCity() {
    webClient.get()
            .uri("URL")
            .retrieve()
            .bodyToMono(WeatherResponse.class)
            .subscribe(response -> {

              System.out.println("Location: " + response.resolvedAddress());

              Day today = response.days().get(0);
              System.out.println("Temperature: " + today.temp());
            });
  }
}

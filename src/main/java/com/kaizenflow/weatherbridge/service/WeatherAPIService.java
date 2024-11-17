/*
 * Copyright 2024 KaizenFlow. All rights reserved.
 */
package com.kaizenflow.weatherbridge.service;

import com.kaizenflow.weatherbridge.model.WeatherDayResponse;
import com.kaizenflow.weatherbridge.model.WeatherResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Service
public class WeatherAPIService {

    private String apiKey;

  private WebClient webClient;

  @Autowired
  public WeatherAPIService(WebClient webClient, @Value("${visual.crossing.api.key}")String apiKey) {
    this.webClient = webClient;
    this.apiKey = apiKey;
  }

  public void getWeatherForCity(String location) {
      webClient.get()
              .uri(uriBuilder -> uriBuilder
                      .path("/{area}")
                      .queryParam("unitGroup", "metric")
                      .queryParam("include", "days,fcst,hours")
                      .queryParam("key", apiKey)
                      .queryParam("contentType", "json")
                      .build(location))
              .retrieve()
              .bodyToMono(WeatherResponse.class)
              .doOnError(error -> {
                  System.err.println("Error fetching weather data: " + error.getMessage());
              })
              .onErrorResume(error -> Mono.empty())
              .subscribe(response -> {
                  if (response != null && !response.days().isEmpty()) {
                      System.out.println("Location: " + response.resolvedAddress());
                      WeatherDayResponse today = response.days().get(0);
                      System.out.println("Temperature: " + today.temp());
                  }
              });
  }
}

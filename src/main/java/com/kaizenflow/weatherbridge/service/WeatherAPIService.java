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
import org.springframework.web.reactive.function.client.WebClientResponseException;
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

  public WeatherResponse getWeatherForCity(String location) {
      return webClient.get()
              .uri(uriBuilder -> uriBuilder
                      .path("/{area}")
                      .queryParam("unitGroup", "metric")
                      .queryParam("include", "days,fcst,hours")
                      .queryParam("key", apiKey)
                      .queryParam("contentType", "json")
                      .build(location))
              .retrieve()
              .bodyToMono(WeatherResponse.class)
              .doFirst(() -> {
                  System.out.println("Fetching weather data for: " + location);
              })
              .doOnError(WebClientResponseException.class, error -> {
                  System.err.println("API Error: " + error.getStatusCode() + " - " + error.getMessage());
              })
              .onErrorResume(error -> {
                  System.err.println("Error occurred: " + error.getMessage());
                  return Mono.empty();
              }).block();
  }
}

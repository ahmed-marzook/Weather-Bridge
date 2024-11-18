/*
 * Copyright 2024 KaizenFlow. All rights reserved.
 */
package com.kaizenflow.weatherbridge.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.kaizenflow.weatherbridge.exception.WeatherApiException;
import com.kaizenflow.weatherbridge.model.WeatherResponse;

import reactor.core.publisher.Mono;

@Service
public class WeatherAPIService {

    private static final Logger log = LoggerFactory.getLogger(WeatherAPIService.class);

    private final String apiKey;

    private final WebClient webClient;

    @Autowired
    public WeatherAPIService(
            WebClient webClient, @Value("${visual.crossing.api.key}") String apiKey) {
        this.webClient = webClient;
        this.apiKey = apiKey;
    }

    public WeatherResponse fetchWeatherFromApi(String location) throws WeatherApiException {
        WeatherResponse weatherResponse;
        try {
            weatherResponse =
                    webClient
                            .get()
                            .uri(
                                    uriBuilder ->
                                            uriBuilder
                                                    .path("/{area}")
                                                    .queryParam("unitGroup", "metric")
                                                    .queryParam("include", "days,fcst,hours")
                                                    .queryParam("iconSet", "icon2")
                                                    .queryParam("key", apiKey)
                                                    .queryParam("contentType", "json")
                                                    .build(location))
                            .retrieve()
                            .onStatus(
                                    HttpStatusCode::is4xxClientError,
                                    response ->
                                            response
                                                    .bodyToMono(String.class)
                                                    .flatMap(body -> Mono.error(new IllegalArgumentException(body))))
                            .onStatus(
                                    HttpStatusCode::is5xxServerError,
                                    response -> Mono.error(new RuntimeException("Weather API server error")))
                            .bodyToMono(WeatherResponse.class)
                            .block();
        } catch (IllegalArgumentException e) {
            log.debug("error", e);
            throw new WeatherApiException(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (RuntimeException e) {
            log.debug("error", e);
            throw new WeatherApiException(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return weatherResponse;
    }
}

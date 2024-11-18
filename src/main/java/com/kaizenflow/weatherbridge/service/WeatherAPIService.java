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
                                    uriBuilder -> {
                                        var uri =
                                                uriBuilder
                                                        .path("/{area}")
                                                        .queryParam("unitGroup", "metric")
                                                        .queryParam("include", "days,hours")
                                                        .queryParam("iconSet", "icons2")
                                                        .queryParam("key", apiKey)
                                                        .queryParam("contentType", "json")
                                                        .build(location);
                                        log.debug("Request URI: {}", maskApiKeyInUri(uri.toString()));
                                        return uri;
                                    })
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
                            .doOnSuccess(response -> logSuccessfulResponse(response, location))
                            .block();
        } catch (IllegalArgumentException e) {
            log.error(
                    "Client error while fetching weather data for location {}: {}", location, e.getMessage());
            log.debug("Detailed client error:", e);
            throw new WeatherApiException(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (RuntimeException e) {
            log.error(
                    "Server error while fetching weather data for location {}: {}", location, e.getMessage());
            log.debug("Detailed server error:", e);
            throw new WeatherApiException(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return weatherResponse;
    }

    private void logSuccessfulResponse(WeatherResponse response, String location) {
        log.info("Successfully retrieved weather data for location: {}", location);
        log.debug("Raw API response for location {}: {}", location, response);
    }

    private String maskApiKeyInUri(String uri) {
        return uri.replaceAll("key=[^&]+", "key=********");
    }
}

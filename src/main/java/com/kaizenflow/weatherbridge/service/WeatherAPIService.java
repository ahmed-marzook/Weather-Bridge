/*
 * Copyright 2024 KaizenFlow. All rights reserved.
 */
package com.kaizenflow.weatherbridge.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.kaizenflow.weatherbridge.model.WeatherResponse;

import reactor.core.publisher.Mono;

@Service
public class WeatherAPIService {

    private final String apiKey;

    private final WebClient webClient;

    private final RedisTemplate<String, WeatherResponse> weatherRedisTemplate;

    @Autowired
    public WeatherAPIService(
            WebClient webClient,
            @Value("${visual.crossing.api.key}") String apiKey,
            RedisTemplate<String, WeatherResponse> weatherRedisTemplate) {
        this.webClient = webClient;
        this.apiKey = apiKey;
        this.weatherRedisTemplate = weatherRedisTemplate;
    }

    public WeatherResponse fetchWeatherFromApi(String location) {
        WeatherResponse weatherResponse =
                webClient
                        .get()
                        .uri(
                                uriBuilder ->
                                        uriBuilder
                                                .path("/{area}")
                                                .queryParam("unitGroup", "metric")
                                                .queryParam("include", "days,fcst,hours")
                                                .queryParam("iconSet","icon2")
                                                .queryParam("key", apiKey)
                                                .queryParam("contentType", "json")
                                                .build(location))
                        .retrieve()
                        .bodyToMono(WeatherResponse.class)
                        .doFirst(
                                () -> {
                                    System.out.println("Fetching weather data for: " + location);
                                })
                        .doOnError(
                                WebClientResponseException.class,
                                error -> {
                                    System.err.println(
                                            "API Error: " + error.getStatusCode() + " - " + error.getMessage());
                                })
                        .onErrorResume(
                                error -> {
                                    System.err.println("Error occurred: " + error.getMessage());
                                    return Mono.empty();
                                })
                        .block();
        weatherRedisTemplate.opsForValue().set(location, weatherResponse);
        weatherRedisTemplate.hasKey(location);
        return weatherResponse;
    }
}

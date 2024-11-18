package com.kaizenflow.weatherbridge.service;

import java.time.Duration;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.kaizenflow.weatherbridge.exception.WeatherApiException;
import com.kaizenflow.weatherbridge.model.WeatherResponse;

@Service
public class WeatherService {

    private final WeatherAPIService weatherAPIService;

    private final RedisTemplate<String, WeatherResponse> weatherRedisTemplate;

    public WeatherService(
            WeatherAPIService weatherAPIService,
            RedisTemplate<String, WeatherResponse> weatherRedisTemplate) {
        this.weatherAPIService = weatherAPIService;
        this.weatherRedisTemplate = weatherRedisTemplate;
    }

    public WeatherResponse getWeatherData(String location) throws WeatherApiException {
        WeatherResponse cachedWeather = weatherRedisTemplate.opsForValue().get(location);
        if (cachedWeather != null) {
            return cachedWeather;
        }
        WeatherResponse newWeather = weatherAPIService.fetchWeatherFromApi(location);
        weatherRedisTemplate.opsForValue().set(location, newWeather, Duration.ofHours(1));
        return newWeather;
    }
}

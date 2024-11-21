package com.kaizenflow.weatherbridge.service;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.RedisConnectionFailureException;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.kaizenflow.weatherbridge.exception.WeatherApiException;
import com.kaizenflow.weatherbridge.model.WeatherResponse;

@Service
public class WeatherService {

    private static final Logger logger = LoggerFactory.getLogger(WeatherService.class);

    private final WeatherAPIService weatherAPIService;

    private final RedisTemplate<String, WeatherResponse> weatherRedisTemplate;

    public WeatherService(
            WeatherAPIService weatherAPIService,
            RedisTemplate<String, WeatherResponse> weatherRedisTemplate) {
        this.weatherAPIService = weatherAPIService;
        this.weatherRedisTemplate = weatherRedisTemplate;
    }

    public WeatherResponse getWeatherData(String location) throws WeatherApiException {
        WeatherResponse cachedWeather = null;

        try {
            cachedWeather = weatherRedisTemplate.opsForValue().get(location);
            if (cachedWeather != null) {
                return cachedWeather;
            }
        } catch (RedisConnectionFailureException e) {
            logger.warn("Redis connection failed. Skipping cache operations.", e);
        } catch (Exception e) {
            logger.warn("Error accessing Redis cache. Proceeding without cache.", e);
        }

        WeatherResponse newWeather = weatherAPIService.fetchWeatherFromApi(location);

        try {
            weatherRedisTemplate.opsForValue().set(location, newWeather, Duration.ofHours(1));
        } catch (RedisConnectionFailureException e) {
            logger.warn("Redis connection failed. Weather data not cached.", e);
        } catch (Exception e) {
            logger.warn("Error writing to Redis cache.", e);
        }

        return newWeather;
    }
}

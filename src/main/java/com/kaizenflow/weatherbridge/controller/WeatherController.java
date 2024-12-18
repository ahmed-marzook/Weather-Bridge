package com.kaizenflow.weatherbridge.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kaizenflow.weatherbridge.exception.WeatherApiException;
import com.kaizenflow.weatherbridge.model.WeatherSummary;
import com.kaizenflow.weatherbridge.service.WeatherService;

@RestController
@RequestMapping("/api/weather")
public class WeatherController {

    public final WeatherService weatherService;

    @Autowired
    public WeatherController(WeatherService weatherService) {
        this.weatherService = weatherService;
    }

    @GetMapping("/{location}")
    public ResponseEntity<WeatherSummary> getWeatherForLocation(
            @PathVariable("location") String location) throws WeatherApiException {
        return new ResponseEntity<>(
                WeatherSummary.fromDay(weatherService.getWeatherData(location.toLowerCase())),
                HttpStatus.OK);
    }
}

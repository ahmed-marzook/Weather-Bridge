package com.kaizenflow.weatherbridge.exception;

import org.springframework.http.HttpStatus;

import lombok.Getter;

@Getter
public class WeatherApiException extends Exception {
    private final HttpStatus statusCode;

    public WeatherApiException(String message, HttpStatus statusCode) {
        super(message);
        this.statusCode = statusCode;
    }
}

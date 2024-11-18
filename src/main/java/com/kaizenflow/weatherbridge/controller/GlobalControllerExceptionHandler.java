package com.kaizenflow.weatherbridge.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.kaizenflow.weatherbridge.exception.WeatherApiException;
import com.kaizenflow.weatherbridge.model.ApiError;

@ControllerAdvice
public class GlobalControllerExceptionHandler {

    @ExceptionHandler(WeatherApiException.class)
    protected ResponseEntity<ApiError> handleWebApiException(WeatherApiException ex) {
        ApiError apiError = new ApiError();
        apiError.setStatus(ex.getStatusCode());
        apiError.setMessage(ex.getMessage());
        // getLocalizedMessage() gets the error message in the locale language
        apiError.setDebugMessage(ex.getLocalizedMessage());
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    @ExceptionHandler(Exception.class)
    protected ResponseEntity<ApiError> handleEntityNotFound(Exception ex) {
        ApiError apiError = new ApiError();
        apiError.setStatus(HttpStatus.BAD_REQUEST);
        apiError.setMessage("UNCAUGHT ERROR");
        // getLocalizedMessage() gets the error message in the locale language
        apiError.setDebugMessage(ex.getLocalizedMessage());
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    private ResponseEntity<Object> buildResponseEntity(ApiError apiError) {
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }
}

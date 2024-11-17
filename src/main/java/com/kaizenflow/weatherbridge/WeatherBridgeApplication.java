/*
 * Copyright 2024 KaizenFlow. All rights reserved.
 */
package com.kaizenflow.weatherbridge;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.kaizenflow.weatherbridge.service.WeatherAPIService;

@SpringBootApplication
public class WeatherBridgeApplication {

    @Autowired private WeatherAPIService weatherAPIService;

    public static void main(String[] args) {
        SpringApplication.run(WeatherBridgeApplication.class, args);
    }
}

package com.kaizenflow.weatherbridge.model;

public record WeatherSummary(
        String datetime,
        Double temperature,
        String conditions,
        Double humidity
) {
}

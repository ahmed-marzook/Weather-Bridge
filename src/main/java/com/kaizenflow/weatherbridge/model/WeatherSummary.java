package com.kaizenflow.weatherbridge.model;

import java.util.List;
import java.util.stream.Collectors;

public record WeatherSummary(
        String icon,
        String location,
        String conditions,
        String date,
        Double temperature,
        Double humidity,
        List<WeatherHourSummary> hourlyForecast) {
    public static WeatherSummary fromDay(WeatherResponse weatherResponse) {
        WeatherDayResponse day = weatherResponse.days().getFirst();
        List<WeatherHourSummary> hourSummaries =
                day.hours().stream()
                        .map(
                                hour ->
                                        new WeatherHourSummary(
                                                hour.datetime(), hour.temp(), hour.conditions(), hour.icon()))
                        .collect(Collectors.toList());

        return new WeatherSummary(
                day.icon(),
                weatherResponse.resolvedAddress(),
                day.conditions(),
                day.datetime(),
                day.temp(),
                day.humidity(),
                hourSummaries);
    }
}

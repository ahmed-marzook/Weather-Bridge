package com.kaizenflow.weatherbridge.model;

import java.util.List;
import java.util.stream.Collectors;

public record WeatherSummary(
        String date, Double temperature, Double humidity, List<WeatherHourSummary> hourlyForecast) {
    public static WeatherSummary fromDay(WeatherDayResponse day) {
        List<WeatherHourSummary> hourSummaries =
                day.hours().stream()
                        .map(hour -> new WeatherHourSummary(hour.datetime(), hour.temp(), hour.conditions()))
                        .collect(Collectors.toList());

        return new WeatherSummary(day.datetime(), day.temp(), day.humidity(), hourSummaries);
    }
}

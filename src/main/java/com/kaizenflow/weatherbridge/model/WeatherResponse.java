package com.kaizenflow.weatherbridge.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record WeatherResponse(
        @JsonProperty("queryCost") Integer queryCost,
        @JsonProperty("latitude") Double latitude,
        @JsonProperty("longitude") Double longitude,
        @JsonProperty("resolvedAddress") String resolvedAddress,
        @JsonProperty("address") String address,
        @JsonProperty("timezone") String timezone,
        @JsonProperty("tzoffset") Integer tzoffset,
        @JsonProperty("description") String description,
        @JsonProperty("days") List<WeatherDayResponse> days) {}

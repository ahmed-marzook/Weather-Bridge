package com.kaizenflow.weatherbridge.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record WeatherHourResponse(
        @JsonProperty("datetime") String datetime,
        @JsonProperty("datetimeEpoch") Long datetimeEpoch,
        @JsonProperty("temp") Double temp,
        @JsonProperty("feelslike") Double feelslike,
        @JsonProperty("humidity") Double humidity,
        @JsonProperty("dew") Double dew,
        @JsonProperty("precip") Double precip,
        @JsonProperty("precipprob") Double precipprob,
        @JsonProperty("snow") Double snow,
        @JsonProperty("snowdepth") Double snowdepth,
        @JsonProperty("preciptype") List<String> preciptype,
        @JsonProperty("windgust") Double windgust,
        @JsonProperty("windspeed") Double windspeed,
        @JsonProperty("winddir") Double winddir,
        @JsonProperty("pressure") Double pressure,
        @JsonProperty("visibility") Double visibility,
        @JsonProperty("cloudcover") Double cloudcover,
        @JsonProperty("solarradiation") Double solarradiation,
        @JsonProperty("solarenergy") Double solarenergy,
        @JsonProperty("uvindex") Double uvindex,
        @JsonProperty("conditions") String conditions,
        @JsonProperty("icon") String icon,
        @JsonProperty("stations") Object stations,
        @JsonProperty("datetimeInstance") String datetimeInstance) {}

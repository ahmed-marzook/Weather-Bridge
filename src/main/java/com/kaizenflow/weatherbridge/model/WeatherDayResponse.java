package com.kaizenflow.weatherbridge.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;

@JsonIgnoreProperties(ignoreUnknown = true)
public record WeatherDayResponse(
        @JsonProperty("datetime") String datetime,
        @JsonProperty("datetimeEpoch") Long datetimeEpoch,
        @JsonProperty("tempmax") Double tempmax,
        @JsonProperty("tempmin") Double tempmin,
        @JsonProperty("temp") Double temp,
        @JsonProperty("feelslikemax") Double feelslikemax,
        @JsonProperty("feelslikemin") Double feelslikemin,
        @JsonProperty("feelslike") Double feelslike,
        @JsonProperty("dew") Double dew,
        @JsonProperty("humidity") Double humidity,
        @JsonProperty("precip") Double precip,
        @JsonProperty("precipprob") Double precipprob,
        @JsonProperty("precipcover") Double precipcover,
        @JsonProperty("preciptype") List<String> preciptype,
        @JsonProperty("snow") Integer snow,
        @JsonProperty("snowdepth") Integer snowdepth,
        @JsonProperty("windgust") Double windgust,
        @JsonProperty("windspeed") Double windspeed,
        @JsonProperty("winddir") Double winddir,
        @JsonProperty("pressure") Double pressure,
        @JsonProperty("cloudcover") Double cloudcover,
        @JsonProperty("visibility") Double visibility,
        @JsonProperty("solarradiation") Double solarradiation,
        @JsonProperty("solarenergy") Double solarenergy,
        @JsonProperty("uvindex") Integer uvindex,
        @JsonProperty("severerisk") Integer severerisk,
        @JsonProperty("sunrise") String sunrise,
        @JsonProperty("sunriseEpoch") Long sunriseEpoch,
        @JsonProperty("sunset") String sunset,
        @JsonProperty("sunsetEpoch") Long sunsetEpoch,
        @JsonProperty("moonphase") Double moonphase,
        @JsonProperty("conditions") String conditions,
        @JsonProperty("description") String description,
        @JsonProperty("icon") String icon,
        @JsonProperty("stations") JsonNode stations,
        @JsonProperty("source") String source,
        @JsonProperty("hours") List<WeatherHourResponse> hours,
        @JsonProperty("precipsum") Double precipsum,
        @JsonProperty("precipsumnormal") Double precipsumnormal,
        @JsonProperty("snowsum") Double snowsum,
        @JsonProperty("datetimeInstance") String datetimeInstance) {}

import { faLocationDot } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import moment from "moment";
import PropTypes from "prop-types";
import useWeatherApi from "../../api/useWeatherApi";
import "./Weather.css";
import { useEffect } from "react";

const getLocation = (locationStr) => {
  if (!locationStr) {
    return <div>No location data available</div>;
  }

  const [city, , country] = locationStr.split(",").map((item) => item.trim());

  return (
    <span className="city">
      {city}, {country}
    </span>
  );
};

function Weather({ location, onLoaded }) {
  const { currentWeather, isLoading, error } = useWeatherApi(location);
  const currentMoment = moment();

  // Call onLoaded when loading state changes to false
  useEffect(() => {
    if (!isLoading && onLoaded) {
      onLoaded();
    }
  }, [isLoading, onLoaded]);

  if (error) {
    return (
      <div className="weather-card error">
        <div className="error-message">
          {error.response?.status === 404
            ? `Location "${location}" not found`
            : "Failed to fetch weather data. Please try again."}
        </div>
      </div>
    );
  }

  return (
    <div className="weather-card">
      {isLoading ? (
        <div className="loading-message">Loading weather data...</div>
      ) : (
        <>
          <div className="location">
            <FontAwesomeIcon className="location-icon" icon={faLocationDot} />
            <>{getLocation(currentWeather.location)}</>
          </div>
          <div className="weather-info">
            <div className="temperature">
              {currentWeather.temperature}
              <sup>°C</sup>
            </div>
            <div className="time-date">
              <div className="time">{currentMoment.format("h:mma")}</div>
              <div className="date">{currentMoment.format("ddd, MMM D")}</div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}

Weather.propTypes = {
  location: PropTypes.string.isRequired,
  onLoaded: PropTypes.func,
};

export default Weather;

import { faLocationDot } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import moment from "moment";
import PropTypes from "prop-types";
import useWeatherApi from "../../api/useWeatherApi";
import "./Weather.css";

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

function Weather(props) {
  const { currentWeather, isLoading, error } = useWeatherApi(props.location);
  const currentMoment = moment();

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

  if (isLoading) {
    return (
      <div className="weather-card loading">
        <div className="loading-message">Loading weather data...</div>
      </div>
    );
  }

  return (
    <div className="weather-card">
      <div className="location">
        <FontAwesomeIcon className="location-icon" icon={faLocationDot} />
        <span className="city">
          {capitalizeFirstLetter(props.location)}, UK
        </span>
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
    </div>
  );
}

Weather.propTypes = {
  location: PropTypes.string.isRequired,
};

export default Weather;

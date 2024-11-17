import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLocationDot } from "@fortawesome/free-solid-svg-icons";
import useWeatherApi from "../../api/useWeatherApi";
import "./Weather.css";
import PropTypes from "prop-types";

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

function Weather(props) {
  const { currentWeather, isLoading, error } = useWeatherApi(props.location);
  const month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];
  const weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  const currentDate = new Date();

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
          <div className="time">
            {currentDate.toLocaleTimeString("en-UK", {
              hour: "numeric",
              minute: "numeric",
              hour12: true,
            })}
          </div>
          <div className="date">
            {weekday[currentDate.getDay()]}, {month[currentDate.getMonth()]}{" "}
            {currentDate.getDate()}
          </div>
        </div>
      </div>
    </div>
  );
}

Weather.propTypes = {
  location: PropTypes.string.isRequired,
};

export default Weather;

import PropTypes from "prop-types";
import weatherIconsMap from "../weather/weatherIconMap";

HourForecast.propTypes = {
  temp: PropTypes.number.isRequired,
  time: PropTypes.string.isRequired,
  icon: PropTypes.string.isRequired,
};

function HourForecast({ temp, time, icon }) {
  function getWeatherIcon(icon) {
    const iconData = weatherIconsMap[icon] || weatherIconsMap["cloudy"];
    return iconData?.icon || "";
  }

  const iconUrl = getWeatherIcon(icon);

  return (
    <div className="hour-forecast">
      <div className="hour-time">{time}</div>
      <img src={iconUrl} alt="weather icon" className="icon-space" />
      <div>
        {temp} <sup>°C</sup>
      </div>
    </div>
  );
}

export default HourForecast;

import HourForecast from "../hour-forecast/HourForecast";
import "./HourlyWeather.css";
import PropTypes from "prop-types";
import { useState } from "react";

HourlyWeather.propTypes = {
  hoursList: PropTypes.arrayOf(
    PropTypes.shape({
      temperature: PropTypes.number.isRequired,
      time: PropTypes.string.isRequired,
      icon: PropTypes.string,
    })
  ).isRequired,
};

function HourlyWeather({ hoursList }) {
  const [startIndex, setStartIndex] = useState(0);
  const itemsToShow = 4;

  const handleNext = () => {
    if (startIndex + itemsToShow < hoursList.length) {
      setStartIndex((prev) => prev + itemsToShow);
    }
  };

  const handlePrev = () => {
    if (startIndex - itemsToShow >= 0) {
      setStartIndex((prev) => prev - itemsToShow);
    }
  };

  const visibleHours = hoursList.slice(startIndex, startIndex + itemsToShow);

  return (
    <div className="container">
      <button
        className="arrow arrow-left"
        onClick={handlePrev}
        disabled={startIndex === 0}
      >
        ←
      </button>
      <div className="hour-grid">
        {visibleHours.map((hour, index) => (
          <HourForecast
            key={startIndex + index}
            temp={hour.temperature}
            time={hour.time}
            icon={hour.icon}
          />
        ))}
      </div>
      <button
        className="arrow arrow-right"
        onClick={handleNext}
        disabled={startIndex + itemsToShow >= hoursList.length}
      >
        →
      </button>
    </div>
  );
}

export default HourlyWeather;

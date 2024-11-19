import { useState } from "react";
import Weather from "../../components/weather/Weather";
import "./HomePage.css";

function Home() {
  const [formData, setFormData] = useState({
    location: "",
  });
  const [currentLocation, setCurrentLocation] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    const payload = {
      ...formData,
    };
    setIsLoading(true); // Start loading when form is submitted
    setCurrentLocation(payload.location);
    setFormData({ location: "" });
  }

  function handleChange(e) {
    const { name, value } = e.target;
    setFormData((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  }

  // Callback function to handle when weather data is loaded
  const handleWeatherLoaded = () => {
    setIsLoading(false);
  };

  return (
    <div>
      <div className="heading">
        <h1 className="heading-title">Weather Wrapper</h1>
        <span>Showing the current weather on Earth</span>
      </div>

      <form onSubmit={handleSubmit} className="weather-form">
        <div className="input-wrapper">
          <input
            className="location-search"
            id="location"
            name="location"
            value={formData.location}
            type="text"
            placeholder="Enter location..."
            onChange={handleChange}
            autoComplete="off"
          />
        </div>
        <button type="submit" className="submit-button" disabled={isLoading}>
          {isLoading ? "Searching..." : "Search"}
        </button>
      </form>

      {currentLocation && (
        <Weather
          key={currentLocation}
          location={currentLocation}
          onLoaded={handleWeatherLoaded}
        />
      )}
    </div>
  );
}

export default Home;

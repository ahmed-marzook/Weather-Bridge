import { useState } from "react";
import Weather from "../../components/weather/Weather";
import "./HomePage.css";

function Home() {
  const [formData, setFormData] = useState({
    location: "",
  });
  const [currentLocation, setCurrentLocation] = useState("");

  function handleSubmit(e) {
    e.preventDefault();
    const payload = {
      ...formData,
    };
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
  return (
    <div>
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
        <button type="submit" className="submit-button">
          Search
        </button>
      </form>

      {currentLocation && (
        <Weather key={currentLocation} location={currentLocation} />
      )}
    </div>
  );
}

export default Home;

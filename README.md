# WeatherBridge API🌤️

A modern Weather API wrapper service providing seamless access to weather data through a unified interface. WeatherBridge acts as an elegant connector between your applications and weather data providers.

**Project to learn how to use Redis and call external APIs using Spring WebClient. Using [Visual Crossing API](https://www.visualcrossing.com/)**

## Technology Stack🛠️

- Java 21
- Spring Boot
- Redis
- Gradle
- React Frontend

## Prerequisites📋

Required installations:

- JDK 21
- Gradle 8.x
- Node v22.9.0
- Docker

## Getting Started🚀

### Environment Variables🔑

```env
VISUAL_CROSSING_API_KEY=*******
```

### Backend Setup

```bash
git clone git@github.com:your-username/weather-bridge.git
cd weather-bridge
docker-compose up -d
./gradlew build
./gradlew bootRun
```

### Frontend setup

```bash
cd frontend
npm install
npm run dev
```

- Server runs on `http://localhost:8080`
- Frontend runs on `http://localhost:5173/`

## Project Structure🏗️

```bash
WEATHERBRIDGE/
├── .gradle/
├── .idea/
├── bin/
├── build/
├── docker/
├── frontend/
├── gradle/
├── src/
├── build.gradle
├── docker-compose.yml
├── gradlew
├── gradlew.bat
├── README.md
└── settings.gradle
```

## Features✨

- Real-time weather data access
- Caching
- Easy to use UI
- Detailed weather metrics

## API Documentation📖

Swagger UI: `http://localhost:8080/swagger-ui.html`

### Available Endpoints

- `/api/weather/{location}` - Get current weather for specified location

## Error Handling🚨

The API uses standard HTTP response codes:

- 200: Success
- 400: Bad request
- 401: Unauthorized
- 403: Forbidden
- 404: Not found
- 500: Internal server error

## Contributing🤝

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## Testing🧪

Run tests with:

```bash
./gradlew test
```

## Future Features

### User Sign Up and Login

- Implement secure user authentication system
- Enable email and social media login options
- Create user profile management
- Store user preferences and settings securely
- Password recovery and reset functionality

### Set and Manage Locations

- Add multiple location tracking
- Save favorite/frequent locations
- Enable location detection via GPS
- Custom naming for saved locations
- Location sharing capabilities
- History of previously tracked locations
- Autocomplete search functionality for locations
- Support for international location search
- Quick access to recently searched locations

### Historical Weather Data

- Access detailed historical weather records
- View weather patterns over custom date ranges
- Compare historical weather trends
- Download historical weather reports
- Analyze seasonal weather patterns
- View historical extreme weather events
- Generate historical weather graphs and charts

### Extended Forecast Features

- Long-range weather predictions (up to 14 days)
- Detailed hourly forecasts
- Weather trend analysis and predictions
- Seasonal forecasting
- Custom forecast period selection
- Weather pattern visualization
- Forecast accuracy tracking
- Agricultural forecast features

### Receive Weather Alerts

- Customizable weather alert notifications
- Real-time severe weather warnings
- Push notifications for weather changes
- Email alerts for severe conditions
- Custom alert thresholds
- Daily weather summaries
- Storm tracking notifications

### Customize Preferences

- Personalized weather display units (°F/°C)
- Custom notification settings
- Dashboard layout customization
- Preferred weather data sources
- Alert frequency preferences
- Language preferences
- Display theme options (light/dark mode)
- Custom weather parameters to track

## Docker Image Build Commands

```bash
docker build -t kaizenflow/weather-bridge:1.0 .
docker run -e VISUAL_CROSSING_API_KEY=********** -p 8080:8080 kaizenflow/weather-bridge:1.0
docker push kaizenflow/weather-bridge:1.0
```

## Terraform Setup

Using AWS S3 and DynamoDB to store state

# Test development

npm run dev

# Test production locally

npm run build
npm run preview

# Or use serve to test the production build

npm install -g serve
serve dist

## License📄

MIT License - see LICENSE.md

## Contact📬

For any queries, please contact [Your Contact Information].

KaizenFlow Technologies - Continuously Improving Your Narrative Experience

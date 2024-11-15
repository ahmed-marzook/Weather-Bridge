# WeatherBridge API🌤️

A modern Weather API wrapper service providing seamless access to weather data through a unified interface. WeatherBridge acts as an elegant connector between your applications and various weather data providers.

## Technology Stack🛠️

- Java 21
- Spring Boot
- Gradle
- React Frontend

## Prerequisites📋

Required installations:

- JDK 21
- Gradle 8.x
- Docker

## Getting Started🚀

Clone and setup:

```bash
git clone git@github.com:your-username/weather-bridge.git
cd weather-bridge
./gradlew build
./gradlew bootRun
```

Frontend setup:

```bash
cd frontend
npm install
npm run dev
```

Server runs on `http://localhost:8080`
Frontend runs on `http://localhost:3000`

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
├── build.gradle.kts
├── docker-compose.yml
├── gradlew
├── gradlew.bat
├── README.md
└── settings.gradle.kts
```

## Features✨

- Real-time weather data access
- Multiple weather provider integration
- Rate limiting and caching
- Detailed weather metrics
- Historical weather data
- Weather alerts and notifications
- Geolocation support
- Customizable data formats
- Batch request processing
- Comprehensive error handling

## API Documentation📖

Swagger UI: `http://localhost:8080/swagger-ui.html`

### Available Endpoints

- `/api/v1/current` - Get current weather
- `/api/v1/forecast` - Get weather forecast
- `/api/v1/historical` - Get historical weather data
- `/api/v1/alerts` - Get weather alerts
- `/api/v1/locations` - Manage location data

## Environment Variables🔑

```
WEATHER_API_KEY=your_api_key
DATABASE_URL=your_db_url
REDIS_URL=your_redis_url
PORT=8080
```

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

## License📄

MIT License - see LICENSE.md

## Contact📬

For any queries, please contact [Your Contact Information].

KaizenFlow Technologies - Continuously Improving Your Narrative Experience

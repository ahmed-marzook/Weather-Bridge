const weatherIconsMap = {
    // Snow conditions
    snow: {
        id: 'snow',
        description: 'Amount of snow is greater than zero',
        icon: '../../assets/weather-icons/snow.svg'
    },
    'snow-showers-day': {
        id: 'snow-showers-day',
        description: 'Periods of snow during the day',
        icon: '../../assets/weather-icons/snow-showers-day.svg'
    },
    'snow-showers-night': {
        id: 'snow-showers-night',
        description: 'Periods of snow during the night',
        icon: '../../assets/weather-icons/snow-showers-night.svg'
    },

    // Thunder conditions
    'thunder-rain': {
        id: 'thunder-rain',
        description: 'Thunderstorms throughout the day or night',
        icon: '../../assets/weather-icons/thunder-rain.svg'
    },
    'thunder-showers-day': {
        id: 'thunder-showers-day',
        description: 'Possible thunderstorms throughout the day',
        icon: '../../assets/weather-icons/thunder-showers-day.svg'
    },
    'thunder-showers-night': {
        id: 'thunder-showers-night',
        description: 'Possible thunderstorms throughout the night',
        icon: '../../assets/weather-icons/thunder-showers-night.svg'
    },

    // Rain conditions
    rain: {
        id: 'rain',
        description: 'Amount of rainfall is greater than zero',
        icon: '../../assets/weather-icons/rain.svg'
    },
    'showers-day': {
        id: 'showers-day',
        description: 'Rain showers during the day',
        icon: '../../assets/weather-icons/showers-day.svg'
    },
    'showers-night': {
        id: 'showers-night',
        description: 'Rain showers during the night',
        icon: '../../assets/weather-icons/showers-night.svg'
    },

    // Other weather conditions
    fog: {
        id: 'fog',
        description: 'Visibility is low (lower than one kilometer or mile)',
        icon: '../../assets/weather-icons/fog.svg'
    },
    wind: {
        id: 'wind',
        description: 'Wind speed is high (greater than 30 kph or mph)',
        icon: '../../assets/weather-icons/wind.svg'
    },
    cloudy: {
        id: 'cloudy',
        description: 'Cloud cover is greater than 90% cover',
        icon: '../../assets/weather-icons/cloudy.svg'
    },
    'partly-cloudy-day': {
        id: 'partly-cloudy-day',
        description: 'Cloud cover is greater than 20% cover during day time.',
        icon: '../../assets/weather-icons/partly-cloudy-day.svg'
    },
    'partly-cloudy-night': {
        id: 'partly-cloudy-night',
        description: 'Cloud cover is greater than 20% cover during night time.',
        icon: '../../assets/weather-icons/partly-cloudy-night.svg'
    },
    'clear-day': {
        id: 'clear-day',
        description: 'Cloud cover is less than 20% cover during day time',
        icon: '../../assets/weather-icons/clear-day.svg'
    },
    'clear-night': {
        id: 'clear-night',
        description: 'Cloud cover is less than 20% cover during night time',
        icon: '../../assets/weather-icons/clear-night.svg'
    }
};

export default weatherIconsMap;
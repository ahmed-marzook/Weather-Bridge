// Snow conditions
import clearDayIcon from '../../assets/weather-icons/clear-day.svg';
import clearNightIcon from '../../assets/weather-icons/clear-night.svg';
import cloudyIcon from '../../assets/weather-icons/cloudy.svg';
import fogIcon from '../../assets/weather-icons/fog.svg';
import partlyCloudyDayIcon from '../../assets/weather-icons/partly-cloudy-day.svg';
import partlyCloudyNightIcon from '../../assets/weather-icons/partly-cloudy-night.svg';
import rainIcon from '../../assets/weather-icons/rain.svg';
import showersDayIcon from '../../assets/weather-icons/showers-day.svg';
import showersNightIcon from '../../assets/weather-icons/showers-night.svg';
import snowShowersDayIcon from '../../assets/weather-icons/snow-showers-day.svg';
import snowShowersNightIcon from '../../assets/weather-icons/snow-showers-night.svg';
import snowIcon from '../../assets/weather-icons/snow.svg';
import thunderRainIcon from '../../assets/weather-icons/thunder-rain.svg';
import thunderShowersDayIcon from '../../assets/weather-icons/thunder-showers-day.svg';
import thunderShowersNightIcon from '../../assets/weather-icons/thunder-showers-night.svg';
import windIcon from '../../assets/weather-icons/wind.svg';

const weatherIconsMap = {
    // Snow conditions
    snow: {
        id: 'snow',
        description: 'Amount of snow is greater than zero',
        icon: snowIcon
    },
    'snow-showers-day': {
        id: 'snow-showers-day',
        description: 'Periods of snow during the day',
        icon: snowShowersDayIcon
    },
    'snow-showers-night': {
        id: 'snow-showers-night',
        description: 'Periods of snow during the night',
        icon: snowShowersNightIcon
    },

    // Thunder conditions
    'thunder-rain': {
        id: 'thunder-rain',
        description: 'Thunderstorms throughout the day or night',
        icon: thunderRainIcon
    },
    'thunder-showers-day': {
        id: 'thunder-showers-day',
        description: 'Possible thunderstorms throughout the day',
        icon: thunderShowersDayIcon
    },
    'thunder-showers-night': {
        id: 'thunder-showers-night',
        description: 'Possible thunderstorms throughout the night',
        icon: thunderShowersNightIcon
    },

    // Rain conditions
    rain: {
        id: 'rain',
        description: 'Amount of rainfall is greater than zero',
        icon: rainIcon
    },
    'showers-day': {
        id: 'showers-day',
        description: 'Rain showers during the day',
        icon: showersDayIcon
    },
    'showers-night': {
        id: 'showers-night',
        description: 'Rain showers during the night',
        icon: showersNightIcon
    },

    // Other weather conditions
    fog: {
        id: 'fog',
        description: 'Visibility is low (lower than one kilometer or mile)',
        icon: fogIcon
    },
    wind: {
        id: 'wind',
        description: 'Wind speed is high (greater than 30 kph or mph)',
        icon: windIcon
    },
    cloudy: {
        id: 'cloudy',
        description: 'Cloud cover is greater than 90% cover',
        icon: cloudyIcon
    },
    'partly-cloudy-day': {
        id: 'partly-cloudy-day',
        description: 'Cloud cover is greater than 20% cover during day time.',
        icon: partlyCloudyDayIcon
    },
    'partly-cloudy-night': {
        id: 'partly-cloudy-night',
        description: 'Cloud cover is greater than 20% cover during night time.',
        icon: partlyCloudyNightIcon
    },
    'clear-day': {
        id: 'clear-day',
        description: 'Cloud cover is less than 20% cover during day time',
        icon: clearDayIcon
    },
    'clear-night': {
        id: 'clear-night',
        description: 'Cloud cover is less than 20% cover during night time',
        icon: clearNightIcon
    }
};

export default weatherIconsMap;
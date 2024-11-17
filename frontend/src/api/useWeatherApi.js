import axios, { isCancel } from "axios";

import { useCallback, useEffect, useRef, useState } from "react";

function useWeatherApi(location) {
    const [error, setError] = useState(null); // Stores any API errors
    const [isLoading, setIsLoading] = useState(true); // Tracks loading state
    const [currentWeather, setCurrentWeather] = useState('');

    const abortControllerRef = useRef(null);

    const getWeather = useCallback(async () => {
        if (abortControllerRef.current) {
            abortControllerRef.current.abort();
        }

        abortControllerRef.current = new AbortController();

        try {
            setIsLoading(true);
            const response = await axios.get(`http://localhost:8080/api/weather/${location}`, {
                signal: abortControllerRef.current.signal,
            });
            setCurrentWeather(response.data);
        } catch (err) {
            if (isCancel(err)) {
                console.log("Request aborted:", err.message);
                return;
            }
            setError(err);
        } finally {
            setIsLoading(false);
        }
    }, []);

    useEffect(() => {
        getWeather();
        return () => {
            if (abortControllerRef.current) {
                abortControllerRef.current.abort();
            }
        };
    }, [getWeather]);

    return { currentWeather, isLoading, error, refetch: getWeather }
}

export default useWeatherApi;
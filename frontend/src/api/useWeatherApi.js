import axios, { isCancel } from "axios";

import { useCallback, useEffect, useRef, useState } from "react";

/**
 * Custom hook to fetch weather data for a given location
 * @param {string} location - The location to fetch weather data for
 */
function useWeatherApi(location) {
    // State Management
    const [error, setError] = useState(null);          // Stores API errors or validation errors
    const [isLoading, setIsLoading] = useState(true);  // Tracks if a request is in progress
    const [currentWeather, setCurrentWeather] = useState(''); // Stores the weather data

    // Used to store the AbortController instance for cancelling in-flight requests
    // We use useRef because we want the same reference across re-renders
    const abortControllerRef = useRef(null);

    /**
     * Main function to fetch weather data
     * Wrapped in useCallback to prevent unnecessary re-renders
     * Only re-creates when location changes
     */
    const getWeather = useCallback(async () => {
        // Reset error state at the start of each request
        setError(null);
        // Input validation - if location is empty or just whitespace, exit early
        if (!location.trim()) {
            setIsLoading(false);
            return;
        }

        // If there's an existing request, cancel it before making a new one
        // This prevents race conditions where responses come back in wrong order
        if (abortControllerRef.current) {
            abortControllerRef.current.abort();
        }

        // Create new AbortController for this request
        abortControllerRef.current = new AbortController();

        try {
            // Start loading state
            setIsLoading(true);

            // Make the API request with abort signal attached
            const response = await axios.get(
                `http://localhost:8080/api/weather/${location}`,
                {
                    signal: abortControllerRef.current.signal,
                }
            );

            // Update state with successful response
            setCurrentWeather(response.data);

        } catch (err) {
            // Special handling for cancelled requests
            // If request was cancelled, we don't want to update error state
            if (isCancel(err)) {
                console.log("Request aborted:", err.message);
                return;
            }

            // For all other errors, update error state and clear weather data
            setError(err);
            setCurrentWeather('');

        } finally {
            // Always mark loading as finished, regardless of success/failure
            setIsLoading(false);
        }
    }, [location]); // Only recreate this function if location changes

    /**
     * Effect to trigger weather fetch when location changes
     * Also handles cleanup by cancelling any in-flight requests
     */
    useEffect(() => {
        // Fetch weather data when component mounts or location changes
        getWeather();

        // Cleanup function runs before next effect or component unmount
        return () => {
            // Cancel any in-flight request when component unmounts
            // or when location changes
            if (abortControllerRef.current) {
                abortControllerRef.current.abort();
            }
        };
    }, [getWeather]); // Depend on getWeather which depends on location

    // Return all necessary state and the refetch function
    // refetch can be used to manually trigger a new request
    return {
        currentWeather,
        isLoading,
        error,
        refetch: getWeather
    };
}

export default useWeatherApi;
import pandas as pd
import time
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import folium

geolocator = Nominatim(user_agent="geoapiExercises")

def geocode_location(location):
    try:
        time.sleep(1)
        location_data = geolocator.geocode(location)
        if location_data:
            return location_data.latitude, location_data.longitude
        else:
            print(f"Geocoding failed for location: {location}")
            return None, None
    except (GeocoderTimedOut, GeocoderServiceError) as e:
        print(f"Error for {location}: {e}")
        return None, None

df = pd.read_csv('scraped_articles.csv')

df['Latitude'], df['Longitude'] = zip(*df['REFINE LOCATION'].apply(geocode_location))

df.dropna(subset=['Latitude', 'Longitude'], inplace=True)

df.to_csv('geocoded_results.csv', index=False)

if not df.empty:
    location_map = folium.Map(location=[df['Latitude'].mean(), df['Longitude'].mean()], zoom_start=5)
    for idx, row in df.iterrows():
        folium.Marker(
            location=[row['Latitude'], row['Longitude']],
            popup=row['REFINE LOCATION'],
            icon=folium.Icon(color='red')
        ).add_to(location_map)
    location_map.save('crime_hotspots_map2.html')
    print("Map has been saved as 'crime_hotspots_map2.html'.")
else:
    print("No valid locations available for mapping.")

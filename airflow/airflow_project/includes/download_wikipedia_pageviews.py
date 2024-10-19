import requests
import os
from datetime import datetime

current_datetime = datetime.now()

year = current_datetime.year
month = current_datetime.month
day = current_datetime.day
hour = current_datetime.hour - 11

path_to_folder = "/workspaces/airflow/dags/airflow_project/pageviews"

# Generate the Wikipedia URL based on the provided date and time components
def generate_wikipedia_url(year, month, day, hour):
    return f"https://dumps.wikimedia.org/other/pageviews/{year}/{year}-{month}/pageviews-{year}{month}{day}-{hour}0000.gz"

# Download the Wikipedia pageviews
def download_wikipedia_pageviews(**kwargs):
    url = generate_wikipedia_url(year, month, day, hour)
    file_path = f"{path_to_folder}/pageviews-{year}{month}{day}-{hour}0000.gz"
    
    # Check if the folder exists, if not, create it
    if not os.path.exists(path_to_folder):
        os.makedirs(path_to_folder)
        print(f"Created directory: {path_to_folder}")
    else:
        print(f"Directory already exists: {path_to_folder}")

    print(f"Downloading data for {hour}:00...")  # Optional print for tracking
    
    response = requests.get(url)
    
    # Add error handling for file writing
    try:
        print(f"Saving file to: {file_path}")
        with open(file_path, 'wb') as f:
            f.write(response.content)
        print(f"Data saved to {file_path}")
    except Exception as e:
        print(f"Failed to save file: {e}")

# Example of how to use the function
download_wikipedia_pageviews()
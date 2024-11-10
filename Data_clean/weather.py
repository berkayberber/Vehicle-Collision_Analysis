import pandas as pd
import csv
from datetime import datetime

# Read data from CSV file, modify date format, and write to new CSV file
with open('input.csv', 'r') as input_file, open('output.csv', 'w', newline='') as output_file:
    csv_reader = csv.DictReader(input_file)
    csv_writer = csv.DictWriter(output_file, fieldnames=csv_reader.fieldnames)
    csv_writer.writeheader()

    for row in csv_reader:
        row['Date'] = datetime.strptime(row['Date'], "%Y-%m-%d").strftime("%d-%m-%Y")
        csv_writer.writerow(row)


# Set display options to show all columns and rows
pd.set_option('display.max_columns', None)  # Show all columns
pd.set_option('display.max_rows', None)     # Show all rows

# Veri setini yükle
data = pd.read_csv("weather.csv")  # Veri setinin dosya yolunu değiştir

# Latitude ve Longitude sütunlarını sil
#data.drop(columns=['temp', 'feelslikemax', 'feelslike', 'feelslikemin', 'feelslike', 'dew', 'precip','precipprob','snow','snowdepth','windgust','winddir','sealevelpressure','cloudcover','solarradiation','solarenergy','uvindex','severerisk','sunrise', 'sunset', 'moonphase', 'conditions', 'icon', 'stations'], inplace=True)

data.drop(columns=['precipcover','preciptype'], inplace=True)

# sütununda boş değerlere sahip satırları komple sil
columns_to_check = ['tempmax', 'tempmin', 'humidity', 'windspeed',
                    'visibility', 'description',
                    ]
# Drop rows where any of the specified columns are null
data.dropna(subset=columns_to_check, how='any', inplace=True)



# Temizlenmiş veriyi yeni bir dosyaya kaydet (isteğe bağlı)
data.to_csv("WeatherCondition.csv", index=False)  # Yeni dosyanın adını ve yolunu belirle

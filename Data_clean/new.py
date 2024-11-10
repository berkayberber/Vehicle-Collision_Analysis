import pandas as pd

# CSV dosyasını oku
data = pd.read_csv("WeatherCondition1.csv")

# Sütun uzunluklarını kontrol et ve düzenle
max_length = 50  # Örneğin, maksimum 50 karakter

# Belirli sütunların uzunluklarını kontrol edip düzenle
for column in ['name', 'datetime', 'tempmax', 'tempmin', 'humidity', 'windspeed', 'visibility', 'description']:
    data[column] = data[column].astype(str).str[:max_length]

# Temizlenmiş verileri yeni bir CSV dosyasına kaydet
data.to_csv("WeatherCondition.csv", index=False, encoding='utf-8')

print("Data cleaned and saved to 'WeatherCondition.csv'")


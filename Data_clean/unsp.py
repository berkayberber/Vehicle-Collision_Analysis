import pandas as pd

# CSV dosyasını bir DataFrame'e oku
df = pd.read_csv("VehicleCollision.csv")

# 'CRASH DATE' sütununu datetime veri tipine dönüştür
df['CRASH DATE'] = pd.to_datetime(df['CRASH DATE'])

# DataFrame'i, tarihi 2016'dan önceki ve 2019'dan sonraki olan satırları içerecek şekilde filtrele
df = df[(df['CRASH DATE'].dt.year >= 2016) & (df['CRASH DATE'].dt.year <= 2019)]

# Latitude ve Longitude sütunlarını sil
df.drop(columns=['CONTRIBUTING FACTOR VEHICLE 2', 'CONTRIBUTING FACTOR VEHICLE 3', 'CONTRIBUTING FACTOR VEHICLE 4', 'CONTRIBUTING FACTOR VEHICLE 5'], inplace=True)
df.drop(columns=['VEHICLE TYPE CODE 2', 'VEHICLE TYPE CODE 3', 'VEHICLE TYPE CODE 4', 'VEHICLE TYPE CODE 5', 'COLLISION_ID'], inplace=True)

df.dropna(inplace=True)
# Değiştirilmiş DataFrame'i yeni bir CSV dosyasına kaydet
df.to_csv("VehicleCollisions.csv", index=False, encoding='utf-8')

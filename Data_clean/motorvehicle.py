import pandas as pd

# Set display options to show all columns and rows
pd.set_option('display.max_columns', None)  # Show all columns
pd.set_option('display.max_rows', None)     # Show all rows

# Veri setini yükle
data = pd.read_csv("VehicleCollisions.csv")  # Veri setinin dosya yolunu değiştir

# Latitude ve Longitude sütunlarını sil
data.drop(columns=['LATITUDE', 'LONGITUDE', 'LOCATION'], inplace=True)

# Boş değerleri doldur
# Define the columns to fill with 'Unknown'
columns_to_fill = ['VEHICLE TYPE CODE 1', 'VEHICLE TYPE CODE 2', 'VEHICLE TYPE CODE 3',
                   'VEHICLE TYPE CODE 4', 'VEHICLE TYPE CODE 5', 'CONTRIBUTING FACTOR VEHICLE 1',
                   'CONTRIBUTING FACTOR VEHICLE 2', 'CONTRIBUTING FACTOR VEHICLE 3',
                   'CONTRIBUTING FACTOR VEHICLE 4', 'CONTRIBUTING FACTOR VEHICLE 5',
                   'ON STREET NAME', 'CROSS STREET NAME', 'OFF STREET NAME']

# Fill missing values in specified columns with 'Unknown' using a loop
for column in columns_to_fill:
    data[column].fillna('Unknown', inplace=True)

# sütununda boş değerlere sahip satırları komple sil
columns_to_check = ['CRASH DATE', 'CRASH TIME', 'BOROUGH', 'NUMBER OF PERSONS KILLED',
                    'NUMBER OF PEDESTRIANS KILLED', 'NUMBER OF CYCLIST KILLED',
                    'NUMBER OF MOTORIST KILLED']

# Drop rows where any of the specified columns are null
data.dropna(subset=columns_to_check, how='any', inplace=True)


# 'VEHICLE TYPE CODE 1' sütununda null olan satırları kaldır
data = data[data['VEHICLE TYPE CODE 1'].notna()]
data = data[data['CONTRIBUTING FACTOR VEHICLE 1'].notna()]

# Temizlenmiş veriyi göster
#print(data.head())

# Temizlenmiş veriyi yeni bir dosyaya kaydet (isteğe bağlı)
data.to_csv("MotorVehicleCollisions.csv", index=False)  # Yeni dosyanın adını ve yolunu belirle

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:rashid2007@localhost:5432/football_analysis')

df = pd.read_csv(r"C:\Users\rashid\Desktop\analysis_project\notebook\data\processed\cleaned_data.csv")

df.to_sql('players', engine, if_exists='replace', index=False)

print("Data loaded successfully to PostgreSQL!")
print(len(df))
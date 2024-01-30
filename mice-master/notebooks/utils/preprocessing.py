from sklearn.preprocessing import MinMaxScaler
import pandas as pd


def standardize_df(df):
    data = dict()
    scaler = MinMaxScaler()
    for column in df.columns:
        series = df[column]
        data[column] = (series - series.min()) / (series.max() - series.min())
    df_scaled = pd.DataFrame(data)
    return df_scaled

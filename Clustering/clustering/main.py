from preprocessor import preprocessor
from classify import classify
import pandas as pd

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    p = preprocessor()
    df, countries, err_msg = p.preprocess('Dataset.xlsx')
    # df, countries, err_msg = p.preprocess('C:\\Users\\שקד\\Documents\\business_intelligence\\Clustering\\Dataset.xlsx')
    #print(df.columns)
    #cluster = classify()
    #cluster.KMean(countries, 5, 3)
    # print(len(countries))


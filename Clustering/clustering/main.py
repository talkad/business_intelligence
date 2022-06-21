from preprocessor import preprocessor
import pandas as pd

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    p = preprocessor()
    df, countries, err_msg = p.preprocess('C:\\Users\\tal74\\PycharmProjects\\clustering\\Dataset.xlsx')
    # df, countries, err_msg = p.preprocess('C:\\Users\\שקד\\Documents\\business_intelligence\\Clustering\\Dataset.xlsx')

    # print(len(countries))


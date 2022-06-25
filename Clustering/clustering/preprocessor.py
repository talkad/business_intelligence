import pandas as pd
from sklearn.preprocessing import StandardScaler


class preprocessor:

    def __init__(self):
        self.df = None
        self.df_countries = None

    def load_data(self, filepath):  # todo needs to call the rest of the processing
        try:
            self.df = pd.read_excel(filepath, index_col=0)

            if len(df) == 0:
                self.df = None
                return f'file is empty'

        except FileNotFoundError:
            self.df = None
            return f'file not found at path: {filepath}'

        return ''

    def impute_data(self):
        mean = self.df.mean(numeric_only=True)
        self.df.fillna(mean, inplace=True)

    def data_normalization(self):
        #print(self.df[self.df.columns])
        self.df[self.df.columns] = StandardScaler().fit_transform(self.df[self.df.columns])

    def data_grouping(self):
        self.df_countries = self.df.groupby(['country']).mean()
        self.df_countries.drop(['year'], axis=1, inplace=True)

    def preprocess(self, filename):
        err_msg = self.load_data(filename)

        if len(err_msg) > 0:
            self.df_countries = None
            return None, None, err_msg

        self.impute_data()
        self.data_normalization()
        self.data_grouping()

        return self.df, self.df_countries, 'Preprocessing completed successfully!'

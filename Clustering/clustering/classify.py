import os
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import plotly.express as px
import pycountry
#import plotly.plotly as py
import chart_studio.plotly as py
import seaborn as sns
import numpy as np


class classify:

    def __init__(self):
        self.ma = None

    def KMean(self, countries, n_clusters=3, n_init=3):
        #np.random.seed(42)
        #inertia = []
        #for i in range(2, 50):
        #    kmeans = KMeans(n_clusters=i).fit(countries)
        #    inertia.append(kmeans.inertia_)

        # visualization of the model
        #sns.pointplot(x=list(range(2, 50)), y=inertia)
        #plt.title('SSE on K-Means based on # of clusters')
        #plt.show()
        #for col_name in countries.columns:
        #    if not col_name == "Generosity" and not col_name == "Social support":
        #        print(col_name)
        #        countries.drop(col_name, axis=1, inplace=True)

        # run kmean
        kmeans = KMeans(n_clusters=n_clusters, n_init=n_init).fit(countries)
        centroids = kmeans.cluster_centers_

        # scatter graph
        plt.scatter(countries['Generosity'], countries['Social support'], c=kmeans.labels_.astype(float), s=50, alpha=0.5)
        plt.scatter(centroids[:, 0], centroids[:, 1], c='red', s=40, alpha=0.8)
        plt.title("Scatter Graph")
        plt.xlabel("Generosity")
        plt.ylabel("Social support")
        plt.savefig("scatterGraph.png")
        #plt.show()

        # predict the model
        countries['cluster'] = kmeans.predict(countries)
        # fix some columns name
        countries.reset_index(inplace=True)
        # convert the type
        countries["cluster"] = countries["cluster"].apply(str)
        # save excel
        countries.to_excel('data_with_labels.xlsx', index=False)

        # map country by code
        countries_code = {}
        for country in pycountry.countries:
            countries_code[country.name] = country.alpha_2

        code_temp = countries["country"].copy()
        convert_ISO_3166_2_to_1 = {
            'AF': 'AFG',
            'AX': 'ALA',
            'AL': 'ALB',
            'DZ': 'DZA',
            'AS': 'ASM',
            'AD': 'AND',
            'AO': 'AGO',
            'AI': 'AIA',
            'AQ': 'ATA',
            'AG': 'ATG',
            'AR': 'ARG',
            'AM': 'ARM',
            'AW': 'ABW',
            'AU': 'AUS',
            'AT': 'AUT',
            'AZ': 'AZE',
            'BS': 'BHS',
            'BH': 'BHR',
            'BD': 'BGD',
            'BB': 'BRB',
            'BY': 'BLR',
            'BE': 'BEL',
            'BZ': 'BLZ',
            'BJ': 'BEN',
            'BM': 'BMU',
            'BT': 'BTN',
            'BO': 'BOL',
            'BA': 'BIH',
            'BW': 'BWA',
            'BV': 'BVT',
            'BR': 'BRA',
            'IO': 'IOT',
            'BN': 'BRN',
            'BG': 'BGR',
            'BF': 'BFA',
            'BI': 'BDI',
            'KH': 'KHM',
            'CM': 'CMR',
            'CA': 'CAN',
            'CV': 'CPV',
            'KY': 'CYM',
            'CF': 'CAF',
            'TD': 'TCD',
            'CL': 'CHL',
            'CN': 'CHN',
            'CX': 'CXR',
            'CC': 'CCK',
            'CO': 'COL',
            'KM': 'COM',
            'CG': 'COG',
            'CD': 'COD',
            'CK': 'COK',
            'CR': 'CRI',
            'CI': 'CIV',
            'HR': 'HRV',
            'CU': 'CUB',
            'CY': 'CYP',
            'CZ': 'CZE',
            'DK': 'DNK',
            'DJ': 'DJI',
            'DM': 'DMA',
            'DO': 'DOM',
            'EC': 'ECU',
            'EG': 'EGY',
            'SV': 'SLV',
            'GQ': 'GNQ',
            'ER': 'ERI',
            'EE': 'EST',
            'ET': 'ETH',
            'FK': 'FLK',
            'FO': 'FRO',
            'FJ': 'FJI',
            'FI': 'FIN',
            'FR': 'FRA',
            'GF': 'GUF',
            'PF': 'PYF',
            'TF': 'ATF',
            'GA': 'GAB',
            'GM': 'GMB',
            'GE': 'GEO',
            'DE': 'DEU',
            'GH': 'GHA',
            'GI': 'GIB',
            'GR': 'GRC',
            'GL': 'GRL',
            'GD': 'GRD',
            'GP': 'GLP',
            'GU': 'GUM',
            'GT': 'GTM',
            'GG': 'GGY',
            'GN': 'GIN',
            'GW': 'GNB',
            'GY': 'GUY',
            'HT': 'HTI',
            'HM': 'HMD',
            'VA': 'VAT',
            'HN': 'HND',
            'HK': 'HKG',
            'HU': 'HUN',
            'IS': 'ISL',
            'IN': 'IND',
            'ID': 'IDN',
            'IR': 'IRN',
            'IQ': 'IRQ',
            'IE': 'IRL',
            'IM': 'IMN',
            'IL': 'ISR',
            'IT': 'ITA',
            'JM': 'JAM',
            'JP': 'JPN',
            'JE': 'JEY',
            'JO': 'JOR',
            'KZ': 'KAZ',
            'KE': 'KEN',
            'KI': 'KIR',
            'KP': 'PRK',
            'KR': 'KOR',
            'KW': 'KWT',
            'KG': 'KGZ',
            'LA': 'LAO',
            'LV': 'LVA',
            'LB': 'LBN',
            'LS': 'LSO',
            'LR': 'LBR',
            'LY': 'LBY',
            'LI': 'LIE',
            'LT': 'LTU',
            'LU': 'LUX',
            'MO': 'MAC',
            'MK': 'MKD',
            'MG': 'MDG',
            'MW': 'MWI',
            'MY': 'MYS',
            'MV': 'MDV',
            'ML': 'MLI',
            'MT': 'MLT',
            'MH': 'MHL',
            'MQ': 'MTQ',
            'MR': 'MRT',
            'MU': 'MUS',
            'YT': 'MYT',
            'MX': 'MEX',
            'FM': 'FSM',
            'MD': 'MDA',
            'MC': 'MCO',
            'MN': 'MNG',
            'ME': 'MNE',
            'MS': 'MSR',
            'MA': 'MAR',
            'MZ': 'MOZ',
            'MM': 'MMR',
            'NA': 'NAM',
            'NR': 'NRU',
            'NP': 'NPL',
            'NL': 'NLD',
            'AN': 'ANT',
            'NC': 'NCL',
            'NZ': 'NZL',
            'NI': 'NIC',
            'NE': 'NER',
            'NG': 'NGA',
            'NU': 'NIU',
            'NF': 'NFK',
            'MP': 'MNP',
            'NO': 'NOR',
            'OM': 'OMN',
            'PK': 'PAK',
            'PW': 'PLW',
            'PS': 'PSE',
            'PA': 'PAN',
            'PG': 'PNG',
            'PY': 'PRY',
            'PE': 'PER',
            'PH': 'PHL',
            'PN': 'PCN',
            'PL': 'POL',
            'PT': 'PRT',
            'PR': 'PRI',
            'QA': 'QAT',
            'RE': 'REU',
            'RO': 'ROU',
            'RU': 'RUS',
            'RW': 'RWA',
            'BL': 'BLM',
            'SH': 'SHN',
            'KN': 'KNA',
            'LC': 'LCA',
            'MF': 'MAF',
            'PM': 'SPM',
            'VC': 'VCT',
            'WS': 'WSM',
            'SM': 'SMR',
            'ST': 'STP',
            'SA': 'SAU',
            'SN': 'SEN',
            'RS': 'SRB',
            'SC': 'SYC',
            'SL': 'SLE',
            'SG': 'SGP',
            'SK': 'SVK',
            'SI': 'SVN',
            'SB': 'SLB',
            'SO': 'SOM',
            'ZA': 'ZAF',
            'GS': 'SGS',
            'ES': 'ESP',
            'LK': 'LKA',
            'SD': 'SDN',
            'SR': 'SUR',
            'SJ': 'SJM',
            'SZ': 'SWZ',
            'SE': 'SWE',
            'CH': 'CHE',
            'SY': 'SYR',
            'TW': 'TWN',
            'TJ': 'TJK',
            'TZ': 'TZA',
            'TH': 'THA',
            'TL': 'TLS',
            'TG': 'TGO',
            'TK': 'TKL',
            'TO': 'TON',
            'TT': 'TTO',
            'TN': 'TUN',
            'TR': 'TUR',
            'TM': 'TKM',
            'TC': 'TCA',
            'TV': 'TUV',
            'UG': 'UGA',
            'UA': 'UKR',
            'AE': 'ARE',
            'GB': 'GBR',
            'US': 'USA',
            'UM': 'UMI',
            'UY': 'URY',
            'UZ': 'UZB',
            'VU': 'VUT',
            'VE': 'VEN',
            'VN': 'VNM',
            'VG': 'VGB',
            'VI': 'VIR',
            'WF': 'WLF',
            'EH': 'ESH',
            'YE': 'YEM',
            'ZM': 'ZMB',
            'ZW': 'ZWE'
        }
        index = 0
        for country in countries["country"]:
            if countries_code.__contains__(country) and convert_ISO_3166_2_to_1.__contains__(countries_code[country]):
                code_temp.update(pd.Series([convert_ISO_3166_2_to_1[countries_code[country]]], index=[index]))
            else:
                code_temp.update(pd.Series(['Unknown code'], index=[index]))
            index += 1
        countries["code"] = code_temp
        countries = countries[countries["code"] != 'Unknown code'].copy()

        # country map
        fig = px.choropleth(countries, locations="code", color="cluster")
        fig.update_layout(title_text="Horopleth Map")
        py.sign_in("almogar", "mLHBievIbPjHU25fPKj2")
        fileName = os.path.join(os.getcwd(), "countryMap.png")
        py.image.save_as(fig, filename=fileName)
        #fig.show()
        return "Clustering process finished"




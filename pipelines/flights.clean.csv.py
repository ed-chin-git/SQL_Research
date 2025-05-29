# __________ Remove NA from CSV __________
import pandas as pd

csv_url = "flights-2007-NA.csv"

def main():
    # ____ Load csv into dataframe___
    df = pd.read_csv(csv_url)   
    
    # ____ set NANs to 0 ____
    df.fillna(0, inplace=True)

    # ____ Save to new csv file ____
    df.to_csv('Flights-2007-Clean.csv', index=False)

    return

#  Launched from the command line
if __name__ == '__main__':
    main()

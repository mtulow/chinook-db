import os
import re
import glob
import string
import sqlite3
import openpyxl
import pandas as pd
from itertools import chain
from collections import defaultdict
from contextlib import contextmanager


# ==
# Utility Functions
# ==

def convert_snake_to_camel(text: str) -> str:
    """Converts a text string from snake case to camel case.

    Args:
        text (str): The text string to convert.

    Returns:
        str: The converted text string in camel case.
    """
    components = text.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])

@contextmanager
def connect_to_sqlite(db_file: str = './chinook_db/chinook.db'):
    """Connect to a sqlite3 database."""
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        yield conn
    finally:
        if conn:
            conn.close()

@contextmanager
def get_sql_script(sql_file: str):
    """Yield the contents of a SQL file."""
    with open(sql_file, 'r') as f:
        yield f.read()

# ==
# I/O Functions
# ==

def load_sql_to_dataframe(sql_file: str, db_file: str = None) -> pd.DataFrame:
    """Return a pandas.DataFrame from a sqlite3 script."""
    # Default database file: ./chinook_db/chinook.db
    db_file = db_file or './chinook_db/chinook.db'

    # Connect to sqlite3 and get sql script
    with connect_to_sqlite(db_file) as conn, \
         get_sql_script(sql_file) as script:

        # Read SQL script        
        df = pd.read_sql_query(script, con=conn)

    return df

def write_to_excel(df: pd.DataFrame, sheet_name: str, xlsx_file: str) -> str:
    """Writes a pandas dataframe to an excel worksheet.
    
    Args:
        df (pd.DataFrame): Dataframe to write to excel.
        sheet_name (str): Name of the sheet to write to.
        xlsx_file (str): Path to the excel file.
    """

    # Try to load the workbook. If it doesn't exist, create a new one.
    try:
        wb = openpyxl.load_workbook(xlsx_file)
    except FileNotFoundError:
        wb = openpyxl.Workbook()

    # If the sheet already exists, remove it
    if sheet_name in wb.sheetnames:
        wb.remove(wb[sheet_name])

    # Create the sheet
    wb.create_sheet(sheet_name)
    ws = wb[sheet_name]
    
    # Write headers to first row
    ws.append([*df.columns])
    
    # Iterate over the rows in the dataframe
    for idx, row in df.iterrows():
        # Write each row to sheet
        ws.append(row.tolist())

    # Save the workbook
    wb.save(xlsx_file)

    return xlsx_file


def main():
    # Get all sql files
    sql_files = ('data/sql/albums/top_albums_by_location.sql',
                 'data/sql/artists/top_artists_by_location.sql',
                 'data/sql/genres/top_genres_by_location.sql',
                 'data/sql/tracks/top_tracks_by_location.sql',
                 'data/sql/employees/top_performing_employees.sql',)
    
    # Get all csv files
    csv_files = map(lambda x: x.replace('sql', 'csv'), sql_files)

    # Construct excel file path
    xlsx_file = './data/excel/chinook.xlsx'

    # Iterate over sql files
    for sql_file, csv_file in zip(sql_files, csv_files):


        # Connect to sqlite3
        with connect_to_sqlite() as conn,\
             get_sql_script(sql_file) as script:
            
            # Read data into pandas.DataFrame
            df = pd.read_sql_query(script, con=conn)
        
        # Sheet name within spreadsheet
        sheetname = convert_snake_to_camel(os.path.basename(csv_file).removesuffix('.csv'))
        print(sheetname)
        
        # Write dataframe to excel spreadsheet
        write_to_excel(df, sheetname, xlsx_file)

    # Open spreadsheet file
    os.system(f'open {xlsx_file}')


            
            
if __name__ == '__main__':
    print()
    main()
    print()


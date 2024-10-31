import os
import sys
import glob
import sqlite3
import openpyxl
import pandas as pd




def execute_read_script(sql_file: str, db_file: str = './chinook_db/chinook.db'):
    """Run a SQL file in sqlite3."""
    with sqlite3.connect(db_file) as conn:
        with open(sql_file, 'r') as f:
            df = pd.read_sql(f.read(), con=conn)
            return df
        
def write_to_csv(df: pd.DataFrame, csv_file: str, verbose: bool = False):
    """Writes a pandas.DataFrame to a csv file."""
    try:
        if verbose:
            ui = input(f'Press Enter to write to csv file: {csv_file} ...')
            if ui:
                df.to_csv(csv_file,)
                print('Success!')
        else:
            # print(f'Writing to SQL script {} to CSV file {} ... ')
            df.to_csv(csv_file,)
            print('Success!')

    except Exception as err:
        print('Failed!')
        print(err)
        return

def write_to_spreadsheet(df: pd.DataFrame, sheet_name: str, xlsx_file: str) -> str:
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


def run_project_queries():
    project_queries = map(
        sorted, [glob.glob('data/sql/project/*.sql')]
    )
    for queries in project_queries:
        for script in queries:
            # 
            df = execute_read_script(script)

            csv_file = script.replace('sql', 'csv')
            write_to_csv(df, csv_file)

            xlsx_file = os.path.dirname(script).replace('sql','xlsx')+'.xlsx'
            sheet_name = os.path.basename(script).removesuffix('.sql')
            write_to_spreadsheet(df, sheet_name, xlsx_file)

def run_qustion_sets():

    question_sets = map(
        sorted, [glob.glob('data/sql/question_set_1/*.sql'),
                 glob.glob('data/sql/question_set_2/*.sql'),
                 glob.glob('data/sql/question_set_3/*.sql'),
                 glob.glob('data/sql/project/*.sql'),
                 ]
    )

def main():
    """Run the application."""

    # run_project_queries()
    with sqlite3.connect('chinook-db/chinook.db') as conn:
        q = 'SELECT name FROM sqlite_master WHERE type="table";'
        tables = pd.read_sql(q, con=conn)

        for table in tables.values:
            table = table[0]
            query = f'SELECT * FROM {table};'
            df = pd.read_sql(query, con=conn)
            print(table, ':\t', ' | '.join(df.columns))

        

if __name__ == '__main__':
    print()
    main()
    print()
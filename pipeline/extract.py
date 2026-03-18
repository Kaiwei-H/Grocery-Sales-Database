from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR.parent / "data"


def extract_csv(file_name: str) -> pd.DataFrame:
    """
    Load a CSV file from the data directory into a pandas DataFrame.

    Args:
        file_name: Name of the CSV file (e.g. 'sales.csv').

    Returns:
        A pandas DataFrame containing the CSV data.

    Raises:
        FileNotFoundError: If the file does not exist.
        ValueError: If the file is not a CSV file.
    """
    if not file_name.endswith(".csv"):
        raise ValueError(f"Expected a CSV file, got: {file_name}")

    file_path = DATA_DIR / file_name

    if not file_path.exists():
        raise FileNotFoundError(f"File not found: {file_path}")

    df = pd.read_csv(file_path)
    return df


def extract_all_csv() -> dict[str, pd.DataFrame]:
    """
    Load all CSV files from the data directory.

    Returns:
        A dictionary where:
        - key = file stem (e.g. 'sales')
        - value = pandas DataFrame
    """
    dataframes = {}

    for file_path in DATA_DIR.glob("*.csv"):
        dataframes[file_path.stem] = pd.read_csv(file_path)

    return dataframes


if __name__ == "__main__":
    all_data = extract_all_csv()

    for name, df in all_data.items():
        print(f"{name}: {df.shape[0]} rows x {df.shape[1]} columns")
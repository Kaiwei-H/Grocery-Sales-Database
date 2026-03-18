from extract import extract_all_csv
from transforme import transform_all
from load import get_engine, load_all


DB_CONFIG = {
    "user": "postgres",
    "password": "Hkw123qp.",
    "host": "localhost",
    "port": 5432,
    "database": "grocery_sale",
}


def run_pipeline() -> None:
    print("Step 1: Extracting CSV files...")
    raw_data = extract_all_csv()

    print("Step 2: Transforming data...")
    clean_data = transform_all(raw_data)

    print("Step 3: Connecting to PostgreSQL...")
    engine = get_engine(
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
        database=DB_CONFIG["database"],
    )

    with engine.connect() as conn:
        print("Connection successful.")

    print("Step 4: Loading transformed data into PostgreSQL...")
    load_all(clean_data, engine)

    print("Pipeline completed successfully.")


if __name__ == "__main__":
    run_pipeline()
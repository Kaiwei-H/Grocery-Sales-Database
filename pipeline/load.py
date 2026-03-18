from __future__ import annotations

from typing import Dict
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL


def get_engine(user: str, password: str, host: str, port: int, database: str):
    db_url = URL.create(
        drivername="postgresql+psycopg2",
        username=user,
        password=password,
        host=host,
        port=port,
        database=database,
    )
    return create_engine(db_url)


def load_dataframe(
    df: pd.DataFrame,
    table_name: str,
    engine,
    schema: str = "raw",
    if_exists: str = "append",
    chunksize: int = 5000,
) -> None:
    """
    Load one DataFrame into PostgreSQL.
    Assumes the target table already exists.
    """
    df.to_sql(
        name=table_name,
        con=engine,
        schema=schema,
        if_exists=if_exists,
        index=False,
        method="multi",
        chunksize=chunksize,
    )


def load_all(
    dataframes: Dict[str, pd.DataFrame],
    engine,
    schema: str = "raw",
    if_exists: str = "append",
) -> None:
    """
    Load all transformed DataFrames into PostgreSQL raw tables.
    """
    load_order = [
        "countries",
        "cities",
        "customers",
        "employees",
        "categories",
        "products",
        "sales",
    ]

    for table_name in load_order:
        if table_name not in dataframes:
            raise KeyError(f"Missing DataFrame for table: {table_name}")

        df = dataframes[table_name]
        print(f"Loading {table_name} into {schema}.{table_name} ... rows={len(df)}")

        load_dataframe(
            df=df,
            table_name=table_name,
            engine=engine,
            schema=schema,
            if_exists=if_exists,
            chunksize=5000,
        )

        print(f"Finished loading {table_name}")

    print("All tables loaded successfully.")
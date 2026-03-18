from __future__ import annotations

import pandas as pd


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Normalize column names:
    - strip spaces
    - convert CamelCase / PascalCase to snake_case manually via mapping when needed
    """
    df = df.copy()
    df.columns = [col.strip() for col in df.columns]
    return df


def empty_strings_to_na(df: pd.DataFrame) -> pd.DataFrame:
    """
    Replace empty strings or whitespace-only strings with pandas NA.
    """
    df = df.copy()
    df = df.replace(r"^\s*$", pd.NA, regex=True)
    return df


def transform_countries(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "CountryID": "country_id",
        "CountryName": "country_name",
        "CountryCode": "country_code",
    }
    df = df.rename(columns=rename_map)

    df["country_id"] = pd.to_numeric(df["country_id"], errors="coerce").astype("Int64")

    return df[["country_id", "country_name", "country_code"]]


def transform_cities(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "CityID": "city_id",
        "CityName": "city_name",
        "Zipcode": "zipcode",
        "CountryID": "country_id",
    }
    df = df.rename(columns=rename_map)

    df["city_id"] = pd.to_numeric(df["city_id"], errors="coerce").astype("Int64")
    df["country_id"] = pd.to_numeric(df["country_id"], errors="coerce").astype("Int64")

    return df[["city_id", "city_name", "zipcode", "country_id"]]


def transform_customers(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "CustomerID": "customer_id",
        "FirstName": "first_name",
        "MiddleInitial": "middle_initial",
        "LastName": "last_name",
        "CityID": "city_id",
        "Address": "address",
    }
    df = df.rename(columns=rename_map)

    df["customer_id"] = pd.to_numeric(df["customer_id"], errors="coerce").astype("Int64")
    df["city_id"] = pd.to_numeric(df["city_id"], errors="coerce").astype("Int64")

    return df[
        [
            "customer_id",
            "first_name",
            "middle_initial",
            "last_name",
            "city_id",
            "address",
        ]
    ]


def transform_employees(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "EmployeeID": "employee_id",
        "FirstName": "first_name",
        "MiddleInitial": "middle_initial",
        "LastName": "last_name",
        "BirthDate": "birth_date",
        "Gender": "gender",
        "CityID": "city_id",
        "HireDate": "hire_date",
    }
    df = df.rename(columns=rename_map)

    df["employee_id"] = pd.to_numeric(df["employee_id"], errors="coerce").astype("Int64")
    df["city_id"] = pd.to_numeric(df["city_id"], errors="coerce").astype("Int64")
    df["birth_date"] = pd.to_datetime(df["birth_date"], errors="coerce")
    df["hire_date"] = pd.to_datetime(df["hire_date"], errors="coerce")

    return df[
        [
            "employee_id",
            "first_name",
            "middle_initial",
            "last_name",
            "birth_date",
            "gender",
            "city_id",
            "hire_date",
        ]
    ]


def transform_categories(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "CategoryID": "category_id",
        "CategoryName": "category_name",
    }
    df = df.rename(columns=rename_map)

    df["category_id"] = pd.to_numeric(df["category_id"], errors="coerce").astype("Int64")

    return df[["category_id", "category_name"]]


def transform_products(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "ProductID": "product_id",
        "ProductName": "product_name",
        "Price": "price",
        "CategoryID": "category_id",
        "Class": "class",
        "ModifyDate": "modify_date",
        "Resistant": "resistant",
        "IsAllergic": "is_allergic",
        "VitalityDays": "vitality_days",
    }
    df = df.rename(columns=rename_map)

    df["product_id"] = pd.to_numeric(df["product_id"], errors="coerce").astype("Int64")
    df["category_id"] = pd.to_numeric(df["category_id"], errors="coerce").astype("Int64")
    df["price"] = pd.to_numeric(df["price"], errors="coerce")
    df["modify_date"] = pd.to_datetime(df["modify_date"], errors="coerce")
    df["vitality_days"] = pd.to_numeric(df["vitality_days"], errors="coerce")

    return df[
        [
            "product_id",
            "product_name",
            "price",
            "category_id",
            "class",
            "modify_date",
            "resistant",
            "is_allergic",
            "vitality_days",
        ]
    ]


def transform_sales(df: pd.DataFrame) -> pd.DataFrame:
    df = normalize_columns(df)
    df = empty_strings_to_na(df)

    rename_map = {
        "SalesID": "sales_id",
        "SalesPersonID": "salesperson_id",
        "CustomerID": "customer_id",
        "ProductID": "product_id",
        "Quantity": "quantity",
        "Discount": "discount",
        "TotalPrice": "total_price",
        "SalesDate": "sales_date",
        "TransactionNumber": "transaction_number",
    }
    df = df.rename(columns=rename_map)

    int_cols = ["sales_id", "salesperson_id", "customer_id", "product_id", "quantity"]
    for col in int_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")

    numeric_cols = ["discount", "total_price"]
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    df["sales_date"] = pd.to_datetime(df["sales_date"], errors="coerce")

    return df[
        [
            "sales_id",
            "salesperson_id",
            "customer_id",
            "product_id",
            "quantity",
            "discount",
            "total_price",
            "sales_date",
            "transaction_number",
        ]
    ]


def transform_all(dataframes: dict[str, pd.DataFrame]) -> dict[str, pd.DataFrame]:
    """
    Transform all extracted source tables into raw-schema-compatible DataFrames.
    Expected keys:
    countries, cities, customers, employees, categories, products, sales
    """
    return {
        "countries": transform_countries(dataframes["countries"]),
        "cities": transform_cities(dataframes["cities"]),
        "customers": transform_customers(dataframes["customers"]),
        "employees": transform_employees(dataframes["employees"]),
        "categories": transform_categories(dataframes["categories"]),
        "products": transform_products(dataframes["products"]),
        "sales": transform_sales(dataframes["sales"]),
    }


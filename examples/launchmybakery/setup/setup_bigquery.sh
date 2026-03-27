#!/bin/bash

PROJECT_ID=$(gcloud config get-value project)
DATASET_NAME="petrol"
LOCATION="US"

# Generate bucket name if not provided
if [ -z "$1" ]; then
    BUCKET_NAME="gs://mcp-petrol-data-$PROJECT_ID"
    echo "No bucket provided. Using default: $BUCKET_NAME"
else
    BUCKET_NAME=$1
fi

echo "----------------------------------------------------------------"
echo "MCP Bakery Demo Setup"
echo "Project: $PROJECT_ID"
echo "Dataset: $DATASET_NAME"
echo "Bucket:  $BUCKET_NAME"
echo "----------------------------------------------------------------"

# 1. Create Bucket if it doesn't exist
echo "[1/7] Checking bucket $BUCKET_NAME..."
if gcloud storage buckets describe $BUCKET_NAME >/dev/null 2>&1; then
    echo "      Bucket already exists."
else
    echo "      Creating bucket $BUCKET_NAME..."
    gcloud storage buckets create $BUCKET_NAME --location=$LOCATION
fi

# 2. Upload Data
echo "[2/7] Uploading data to $BUCKET_NAME..."
gcloud storage cp data/*.csv $BUCKET_NAME

# 3. Create Dataset
echo "[3/7] Creating Dataset '$DATASET_NAME'..."
if bq show "$PROJECT_ID:$DATASET_NAME" >/dev/null 2>&1; then
    echo "      Dataset already exists. Skipping creation."
else    
    bq mk --location=$LOCATION --dataset \
        --description "$DATASET_DESCRIPTION" \
        "$PROJECT_ID:$DATASET_NAME"
    echo "      Dataset created."
fi

# 4. Create Demographics Table
#!/bin/bash

echo "Creating and loading Fuel dataset tables..."

echo "[1/4] fuel_prices"
bq query --use_legacy_sql=false 
"CREATE OR REPLACE TABLE `$PROJECT_ID.$DATASET_NAME.fuel_prices` (
state STRING,
city STRING,
petrol_price FLOAT64,
diesel_price FLOAT64,
last_updated DATE
);"

bq load --source_format=CSV --skip_leading_rows=1 --replace 
$PROJECT_ID:$DATASET_NAME.fuel_prices 
$BUCKET_NAME/fuel_prices_india.csv

echo "[2/4] fuel_trends"
bq query --use_legacy_sql=false 
"CREATE OR REPLACE TABLE `$PROJECT_ID.$DATASET_NAME.fuel_trends` (
state STRING,
month STRING,
avg_petrol_price FLOAT64,
avg_diesel_price FLOAT64
);"

bq load --source_format=CSV --skip_leading_rows=1 --replace 
$PROJECT_ID:$DATASET_NAME.fuel_trends 
$BUCKET_NAME/fuel_trends.csv

echo "[3/4] fuel_consumption"
bq query --use_legacy_sql=false 
"CREATE OR REPLACE TABLE `$PROJECT_ID.$DATASET_NAME.fuel_consumption` (
state STRING,
fuel_type STRING,
monthly_consumption FLOAT64,
year INT64
);"

bq load --source_format=CSV --skip_leading_rows=1 --replace 
$PROJECT_ID:$DATASET_NAME.fuel_consumption 
$BUCKET_NAME/fuel_consumption.csv

echo "[4/4] fuel_tax"
bq query --use_legacy_sql=false 
"CREATE OR REPLACE TABLE `$PROJECT_ID.$DATASET_NAME.fuel_tax` (
state STRING,
petrol_tax_pct FLOAT64,
diesel_tax_pct FLOAT64
);"

bq load --source_format=CSV --skip_leading_rows=1 --replace 
$PROJECT_ID:$DATASET_NAME.fuel_tax 
$BUCKET_NAME/fuel_tax.csv

echo "All tables created and data loaded successfully!"

echo "----------------------------------------------------------------"
echo "Setup Complete!"
echo "----------------------------------------------------------------"

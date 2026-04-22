# Travel Data Analysis Agent

This project is a travel data analysis agent built with Google ADK and BigQuery.

It allows users to ask natural language questions about custom travel datasets and get structured answers based on BigQuery query results.

## Overview

This project was adapted from the `google/mcp` example and customized into a BigQuery-powered travel analysis assistant.

The current version focuses on data analysis only and does not use Google Maps.

## Features

- Natural language querying over travel-related datasets
- BigQuery integration for structured data access
- Attraction-to-park lookup
- Basic aggregation and summary analysis
- Lightweight and cost-conscious setup

## Dataset

The agent currently works with the following BigQuery dataset:

- `travelbot.attraction_park`
  - Maps attractions to parks
  - Example questions:
    - Which park does Bumper Cars belong to?
    - List attractions in PortAventura World.
    - Which park has the most attractions?

- `travelbot.review_ratings`
  - Contains category-based travel rating data
  - Example questions:
    - What columns are available in review_ratings?
    - Give me a summary of the review_ratings table.
    - Which rating categories have the highest average scores?

## Tech Stack

- Google ADK
- BigQuery
- Python
- Cloud Run

## Project Scope

This project is designed as a simple travel data analysis assistant.

It does not provide:
- Google Maps integration
- route planning
- live location lookup
- external travel recommendation APIs

## Example Questions

- Which park does Bumper Cars belong to?
- List 10 attractions in PortAventura World.
- Which park has the most attractions?
- What columns are available in travelbot.review_ratings?
- Give me a summary of the review_ratings table.

## Deployment

This project can be deployed to Cloud Run using ADK.

Example:

```bash
uvx --from google-adk==1.14.0 \
adk deploy cloud_run \
  --project=$PROJECT_ID \
  --region=europe-west1 \
  --service_name=travelo \
  --with_ui \
  . \
  -- \
  --labels=ddr-tutorial=codelab-adk \
  --service-account=$SERVICE_ACCOUNT
```
## Notes
This project uses BigQuery as the main data source.
Google Maps functionality has been removed.
The current version is intended for demo and learning purposes.

## Demo

[![Watch the demo](https://img.youtube.com/vi/IzfEXGgclxo/0.jpg)](https://youtu.be/IzfEXGgclxo)
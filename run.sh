#!/bin/bash

source .env
source ".venv/bin/activate"

# Notify Healthchecks.io that the script is starting
curl -fsS --retry 3 "${HEALTHCHECKS_URL}/start"

# Run the Python script
OUTPUT=$(python GMSync.py -d 2>&1)


# Notify Healthchecks.io that the script has finished
if [ $? -eq 0 ]; then
    curl -fsS --retry 3 --data-raw "${OUTPUT}" "$HEALTHCHECKS_URL" 
else
    curl -fsS --retry 3 --data-raw "${OUTPUT}" "${HEALTHCHECKS_URL}/fail" 
fi

# Deactivate virtual environment
deactivate

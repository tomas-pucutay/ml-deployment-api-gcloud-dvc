# API Deployment of an ML Regression Model to Predict Worldwide Gross for Movies
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

## Objective
First deployment of an ML model.

## TL/DR Summary
Not quite long! This project was not intended to make a "good" ML model but for deployment training. The data is from movies, and the goal is to predict worldwide gross. You will see the steps used in the step-by-step section. At the end, you'll get a URL as an API with a POST method to send this JSON:

```http
  POST /v1/prediction
```

| Parameter | Type     |
| :-------- | :------- |
| `opening_gross`      | `float` |
| `screens`      | `float` |
| `production_budget`      | `float` |
| `title_year`      | `float` |
| `aspect_ratio`      | `float` |
| `duration`      | `float` |
| `cast_total_facebook_likes`      | `float` |
| `budget`      | `float` |
| `imdb_score`      | `float` |

and get the worldwide gross in return.

## Technologies
- Programming Language: Python.
- Tracking: DVC + Git.
- API Deployment: FastAPI
- Containerization: Docker.
- Workflows CI/CD: GitHub Actions.
- Cloud: Google Cloud Platform.

## Requirements
Environment variables as secrets in the GitHub Repository required:
- SERVICE_ACCOUNT_KEY: JSON obtained from the service account with the IAM roles roles/storage.admin, roles/run.admin, roles/artifactregistry.admin, roles/iam.serviceAccountUser. Should be decoded with base64 before adding.
- REGISTRY_NAME: Name for the container.
- REGION: ID for the region in Cloud Run Service.
- PROJECT_ID: ID for the project in Google Cloud Platform.
- SERVICE_NAME: ID for the Cloud Run service.

These will be added safely in the YAML for GitHub Actions.

## First Step
Fork the repository, clone it, and install the virtual environment, then activate.
```bash
git clone [repository-url]
pipenv install -r requirements.txt
```
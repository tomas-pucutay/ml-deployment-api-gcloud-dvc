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

## Step by Step
1. Get the data: Gather data.
   - The dataframe names are finantials, movies, opening_gross.

2. Make an ML model: Preprocessing and modelling.
   - Preprocessing the dataframes and converting into full_data.
   - Modeling with cross-validation and hyperparameter tuning with Grid Search CV.
   - Export a .pkl model in the model folder.

3. Serialization and data pipeline: Tracking for the data and model.
   - Creating storage in a cloud provider (w/ Google Storage in this case), these steps are in gstorage-config.sh.
   - Tracking .csv (data) and .pkl (model) with DVC.
   - Yaml for dvc to reproduce steps on preprocessing and training the model.

4. Build API locally: Building an endpoint to get the prediction.
   - Using FastAPI in the api folder to create an API from the .pkl model.
   - Configuring tests with pytest for predictions.

5. Build container locally: Containerization.
   - Using Docker to make a Dockerfile to package and deploy API.
   - Creating initializer.sh with gunicorn for container deploy with workers.

6. Implementing workflows: For testing, continuous training, and CI/CD purposes.
   - Creating a serverless service in a cloud provider (w/ Cloud Run in this case), these steps are in gcloudrun-config.sh.
   - Workflows with GitHub actions in .github/workflows.
   - Testing with the test with pytest made.
   - Continuous training with DVC repro and CML (Continuous Machine Learning).
   - CI/CD with Google Cloud and Docker (w/ logic to be called after Continuous Training).

## Improvement areas
There are many opportunities, some of them are:
- Test more regression models, different than GradientBoostingRegressor to avoid overfitting.
- Implement improvements in code readability like OOP programming.
- Implement a workflow for data gathering.
- Trying other cloud providers.
- Using different frameworks: Streamlit, Gradio, MLflow, and so on.

## Acknowledgments
This project has been made possible thanks to the support of [Gerson Perdomo](https://github.com/gersonrpq) for their valuable knowledge in Platzi Course [ML Ops](https://platzi.com/cursos/ml-ops/).

If you have any questions, comments, or suggestions, feel free to reach out to me.

Best of luck!
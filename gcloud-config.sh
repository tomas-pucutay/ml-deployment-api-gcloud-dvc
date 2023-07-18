#!/bin/bash


# --------------- LOGIN ---------------


# VERIFY LOGOUT
# Execute command to logout
echo "----- Verifying is there is an account logged in"
printf "\n"
output_revoke=$(gcloud auth revoke 2>&1)
# If it captures the error, then it returns a more readable message
if [[ $output_revoke == *"Invalid value for [accounts]: No credentials available to revoke"* ]]; then
  echo "Error: There are no credentials available to revoke."
else
  echo "Result: $output_revoke"
fi
printf "\n"


# EXECUTE LOGIN
echo "----- Logging in"
printf "\n"
gcloud auth login
printf "\n"


# --------------- CONFIG PROJECT ---------------


# LIST ALL CURRENT PROJECTS
echo "----- Listing all current projects"
printf "\n"
gcloud projects list
printf "\n"

# SELECT PROJECT (CREATE IF NOT EXISTS)
# Choose the ID for the project
echo "----- Selecting the project"
printf "\n"
echo "Which project ID will you use? (You can use an existing one or a new one, it will be created): "

# Validate the project ID, give max attempts
attempts=0
max_attempts=5

while [ $attempts -lt $max_attempts ]; do
  read -p "Project ID: " PROJECT_ID

  # Validate if the Project ID exists
  if gcloud projects describe $PROJECT_ID &>/dev/null; then
    echo "$PROJECT_ID already exists. It will be used."
    printf "\n"
    break

  # Else, if not exists
  else
    # Before creating, validate Project ID can be used
    output_create_project=$(gcloud projects create $PROJECT_ID --name=$PROJECT_ID 2>&1)
    if [ $? -eq 0 ]; then
      echo "$PROJECT_ID created successfully."
      printf "\n"
      break
    else
      echo "$output_create_project. $((max_attempts-attempts-1)) attempts left"
      printf "\n"
      attempts=$((attempts+1))
    fi
  fi

  # Break for maximum attempts reached
  if [ $attempts -eq $max_attempts ]; then
    echo "Maximum number of attempts has been reached. Could not create project. Execute the script again"
    exit 0
  fi

done

# CONFIG PROJECT
echo "----- Setting config project"
printf "\n"
gcloud config set project $PROJECT_ID
printf "\n"


# --------------- CREDENTIAL WITH IAM FOR STORAGE ADMIN ---------------


# LIST ALL CURRENT SERVICE ACCOUNTS
echo "----- Listing all current Service Accounts"
printf "\n"
gcloud iam service-accounts list --project=$PROJECT_ID
printf "\n"

# SELECT SERVICE ACCOUNT (CREATE IF NOT EXISTS)
# Choose the Service Account
echo "----- Selecting the service account"
printf "\n"
echo "Write the Credential name for Service Account (Could be an existing or a new one):"
read -p "Service Account name: " SERVICE_ACCOUNT_NAME

#Validate if service account exists
if gcloud iam service-accounts describe $SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com --project $PROJECT_ID &>/dev/null; then
  echo "$SERVICE_ACCOUNT_NAME service account already exists. It will be used."
  printf "\n"
#Else, if not exists then create
else
  gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --display-name=$SERVICE_ACCOUNT_NAME --project $PROJECT_ID
  echo "$SERVICE_ACCOUNT_NAME service account successfully created."
  printf "\n"
fi

# IAM POLICY AND KEY.JSON
# Add IAM policy as a storage admin
echo "----- Adding IAM policy"
printf "\n"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"
printf "\n"

# Create key and add to .gitignore
echo "----- Creating Key and adding to .gitignore"
printf "\n"
gcloud iam service-accounts keys create key.json --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com --project $PROJECT_ID
if ! grep -qxF "key.json" .gitignore; then
  echo "key.json" >> .gitignore
fi
echo "key.json successfully created and added to .gitignore"
printf "\n"


# --------------- CREATE RESOURCE: CLOUD STORAGE - BUCKET ---------------


# LIST ALL CURRENT BUCKETS
echo "----- Listing all current buckets"
printf "\n"
gsutil ls -p $PROJECT_ID
printf "\n"

# SELECT BUCKET (CREATE IF NOT EXISTS)
# Choose the Bucket for the project
echo "----- Selecting the bucket"
printf "\n"
echo "Which Bucket will you use? (You can use an existing one or a new one, it will be created): "

# Validate the Bucket name, give max attempts
attempts=0
max_attempts=5

while [ $attempts -lt $max_attempts ]; do
  read -p "Bucket name: " BUCKET_NAME

  # Validate if the Bucket exists
  if gsutil ls -b gs://$BUCKET_NAME >/dev/null 2>&1; then
    echo "$BUCKET_NAME already exists. Create a new one."
    printf "\n"

  # Else, if not exists
  else
    # Before creating, validate Bucket name can be used
    output_create_bucket=$(gsutil mb -l us -c standard gs://$BUCKET_NAME 2>&1)
    if [ $? -eq 0 ]; then
      gsutil uniformbucketlevelaccess set on gs://$BUCKET_NAME
      gsutil defstorageclass set STANDARD gs://$BUCKET_NAME
      echo "Bucket $BUCKET_NAME successfully created."
      printf "\n"
      break
    else
      echo "$output_create_bucket $((max_attempts-attempts-1)) attempts left"
      printf "\n"
      attempts=$((attempts+1))
    fi
  fi

  # Break for maximum attempts reached
  if [ $attempts -eq $max_attempts ]; then
    echo "Maximum number of attempts has been reached. Could not create bucket. Execute the script again"
    exit 0
  fi
done
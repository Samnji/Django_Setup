#!/bin/bash

# Advanced Django setup script with PostgreSQL configuration and Docker deployment support.

# Function to display messages
echo_message() {
  echo -e "\n\033[1;32m$1\033[0m"
}

# Function to handle errors
error_handler() {
  echo -e "\033[1;31mAn error occurred. Exiting...\033[0m"
  exit 1
}

# Trap errors
trap error_handler ERR

# Check if directory argument is provided
if [ -z "$1" ]; then
  echo -e "\033[1;31mError: No directory specified.\033[0m"
  echo "Usage: $0 /path/to/your/project"
  exit 1
fi

PROJECT_DIR="$1"

# Prompt user for project and app names
echo_message "Enter the name of your Django project:"
read PROJECT_NAME

echo_message "Enter the name of your Django app:"
read APP_NAME

echo_message "Enter the name of your PostgreSQL database:"
read DB_NAME

echo_message "Enter the PostgreSQL database user:"
read DB_USER

echo_message "Enter the PostgreSQL database password:"
read -s DB_PASSWORD

# Step 1: Install required tools
echo_message "Installing required tools..."
sudo apt update && sudo apt install -y python3 python3-pip python3-venv git curl libpq-dev

# Step 2: Create project directory and virtual environment
echo_message "Creating project directory at $PROJECT_DIR..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo_message "Setting up virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Step 3: Install Django and common packages
echo_message "Installing Django and PostgreSQL dependencies..."
pip install --upgrade pip
pip install django djangorestframework django-environ gunicorn psycopg2-binary
pip freeze > requirements.txt

# Step 4: Create Django project and app
echo_message "Creating Django project and app..."
django-admin startproject "$PROJECT_NAME" .
python manage.py startapp "$APP_NAME"

# Step 5: Add app to INSTALLED_APPS
echo_message "Adding app to INSTALLED_APPS..."
sed -i "/INSTALLED_APPS = \[/a\ \ \ \ '$APP_NAME'," "$PROJECT_NAME/settings.py"

# Step 6: Add environment variable initialization to settings.py
echo_message "Configuring settings.py to load environment variables..."
cat >> "$PROJECT_NAME/settings.py" <<EOL

# Environment variable setup
import os
from pathlib import Path
import environ

BASE_DIR = Path(__file__).resolve().parent.parent

# Initialize environment variables
env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

# PostgreSQL Database Configuration
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': env('DB_NAME'),
        'USER': env('DB_USER'),
        'PASSWORD': env('DB_PASSWORD'),
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
EOL

# Step 7: Create .env file with database credentials
echo_message "Creating .env file with database credentials..."
cat > .env <<EOL
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
EOL

# Step 8: Set up static folder under app
echo_message "Setting up static folder under the app..."
mkdir -p "$APP_NAME/static/$APP_NAME"
echo "STATICFILES_DIRS = [BASE_DIR / '$APP_NAME/static']" >> "$PROJECT_NAME/settings.py"

# Step 9: Apply migrations and create superuser
echo_message "Applying initial migrations..."
python manage.py migrate

echo_message "Creating superuser for Django Admin (Optional, press Ctrl+C to skip)..."
python manage.py createsuperuser

# Step 10: Git initialization
echo_message "Initializing Git repository..."
git init
git add .
git commit -m "Initial Django project setup with PostgreSQL configuration"

# Final instructions
echo_message "Setup complete. To run the development server:"
echo_message "1. Activate the virtual environment: source .venv/bin/activate"
echo_message "2. Start the server: python manage.py runserver"

echo_message "Project created at $PROJECT_DIR. Happy coding! 🎉"

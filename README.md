# Advanced Django Setup Script with PostgreSQL and Docker Support

## Overview
This script automates the setup of a Django project with:
- PostgreSQL as the database.
- Secure environment variable configuration.
- Static files management under the app directory.
- Optional Docker and Google Cloud deployment support.

---

## Features
- **Django Project and App Creation**: Automates creating a new Django project and app.
- **PostgreSQL Integration**: Configures the project to use PostgreSQL with environment variables for secure credentials.
- **Environment Variables**: Automatically generates a `.env` file to store sensitive information.
- **Static Files Management**: Places static files under the app directory and updates `settings.py`.
- **Docker Support**: Generates `Dockerfile` and `docker-compose.yml` for containerization.
- **Google Cloud Deployment**: Creates a `cloudbuild.yaml` for Google Cloud deployment.
- **Git Integration**: Initializes a Git repository with an initial commit.

---

## Requirements
### System Requirements
- Ubuntu/Debian-based Linux distribution.
- Python 3.8 or higher.
- PostgreSQL installed and running.

### Dependencies
The script installs the following:
- `python3-venv`
- `libpq-dev`
- `git`
- `curl`

---

## Usage
### Step 1: Save the Script
Save the script as `django_setup.sh` on your local machine.

### Step 2: Make the Script Executable
```bash
chmod +x django_setup.sh
```

### Step 3: Run the Script
Execute the script by specifying the desired project directory:
```bash
./django_setup.sh /path/to/your/project
```

### Step 4: Follow the Prompts
Provide the requested details such as:
- `Project name.`
- `App name.`
- `PostgreSQL database name, username, and password.`
#!/bin/bash
#Ensures PostgreSQL is ready before running Django.Runs migrations and collects static files automatically.Creates a default superuser if one doesn’t exist.Uses exec to replace the shell process (better signal handling).
# Exit immediately if any command fails
set -e

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
while ! nc -z "$DATABASE_HOST" "$DATABASE_PORT"; do    #nc(netcat) checks if specific network port is open ,-z tesll nc to scan the port without sending data ,"$DATABASE_HOST" and "$DATABASE_PORT" are environment variables defined in docker-compose.yml (e.g., db and 5432).If the port is not open, the ! (NOT) operator makes the condition true, so the loop continues.. 
   sleep 1
done
echo "PostgreSQL is ready!"

# Run migrations
echo "Applying migrations..."
python manage.py migrate --noinput

# Collect static files (for production use)
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Create a superuser (if not exists)
echo "Creating a superuser..."
echo "from django.contrib.auth import get_user_model;
User = get_user_model();
User.objects.filter(username='admin').exists(); 
User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell    #Idempotent: This block ensures that the superuser is created only if it doesn't already exist. This prevents errors and duplicate superuser creations.Automatic Setup: When deploying the application, this ensures that a superuser is created without manual intervention, making it easier to manage the application in production.
#Imports the get_user_model function, which retrieves the user model used by Django, nitializes the User model, which represents the database table for users.Checks if a user with the username 'admin' already exists in the database.filter(username='admin') queries the User table for an entry with the username 'admin'..exists() returns True if the 'admin' user already exists, otherwise False.create_superuser is a built-in Django method that creates a superuser and automatically marks the user as an admin.

# Start Django server
echo "Starting Django server..."
exec python manage.py runserver 0.0.0.0:8000


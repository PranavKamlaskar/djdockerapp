@echo off

REM ensure docker desktop is running , and ensure you are inside the project directory 
docker-compose up -d --build
docker-compose exec web python manage.py migrate

@echo off

REM ensure docker desktop is running , and ensure you are inside the project directory , warning only this file is not tested for  windows 
docker-compose up -d --build
docker-compose exec web python manage.py migrate

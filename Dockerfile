FROM python:3.11

ENV PYTHONUNBUFFERED=1

WORKDIR /app

#RUN apt-get update && apt-get install -y nc
RUN apt-get update && apt-get install -y netcat-openbsd

# addedd this  becoz it is  conflicting with entrypoint.sh loop command 

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy and set permissions for the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use entrypoint.sh as the default command
ENTRYPOINT ["/entrypoint.sh"]


# Set base image (host OS)
FROM python:3.9-alpine as base
#RUN python3 -m venv /opt/venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV FLASK_ENV="docker"
ENV FLASK_APP=app.py
# By default, listen on port 5000
EXPOSE 5000/tcp

FROM base as debug
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

RUN pip install debugpy
# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install any dependencies
RUN pip install -r requirements.txt
#RUN . /opt/venv/bin/activate && pip install -r requirements.txt
# Copy the content of the local src directory to the working directory
COPY app.py .

# Specify the command to run on container start
CMD [ "python", "./app.py" ]
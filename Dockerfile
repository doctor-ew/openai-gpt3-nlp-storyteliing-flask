# Set base image (host OS)
#FROM python:3.9-alpine
#FROM python:3.9.7-slim-buster
FROM public.ecr.aws/lambda/python:3.9

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV FLASK_ENV="docker"
ENV FLASK_APP=app.py

# By default, listen on port 5000
EXPOSE 5000
EXPOSE 8000
EXPOSE 80

#FROM base as debug
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

#RUN apt-get update; apt-get install -y curl

RUN pip install debugpy

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

RUN pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

# Run the application:
#COPY app.py .
COPY app.py ${LAMBDA_TASK_ROOT}
CMD ["python", "app.py"]
CMD ["flask", "run", "-h", "0.0.0.0", "-p", "5000"]
CMD [ "app.handler" ]


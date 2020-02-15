FROM python:3.8-slim
WORKDIR /app
COPY requirements.txt .
RUN apt-get update \
  && apt-get install -y build-essential libpq-dev \
  && pip install -r requirements.txt \
  && apt-get remove -y build-essential libpq-dev \
  && apt-get -y autoremove && apt-get clean
COPY . .
CMD [ "python", "start.py" ]

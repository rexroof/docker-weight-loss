from flask import Flask
from healthcheck import HealthCheck

app = Flask(__name__)
health = HealthCheck()

@app.route('/')
def hello():
    return "base-image-slim flask app... Hello World!"

app.add_url_rule("/healthz", "healthz", view_func=lambda: health.run())

if __name__ == '__main__':
    app.run(host='0.0.0.0')

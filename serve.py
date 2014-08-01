from flask import Flask
from flask import jsonify
from flask import request
app = Flask(__name__)


@app.route('/')
def root():
    return jsonify(request.headers)


if __name__ == '__main__':
    app.run()

import os
from flask import Flask # type: ignore

app = Flask(__name__)

@app.route('/')
def hello_world():
    # Obtém o ID curto do container
    container_id = os.getenv('HOSTNAME', 'unknown')
    return f'Hello, World! This is replica: {container_id}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
from flask import Flask, request, jsonify
from handler import Handler
import socket
import os

application = Flask(__name__)
global_workflows = {}


class App:

    def __init__(self):
        pass

    def register_workflows(self, workflows):
        global global_workflows
        global_workflows = workflows

    @staticmethod
    @application.route('/execute')
    def execute():
        step = request.args.get('step')
        workflow = request.args.get('workflow')
        obj_name = request.args.get('obj_name')
        handler_instance = Handler()
        handler_instance.flow_data.obj_name = obj_name
        try:
            global_workflows[workflow][step](handler_instance)
            response = {
                "message": "",
                "status": "success"
            }
        except Exception as err:
            response = {
                "message": err,
                "status": "failure"
            }
        return jsonify(response)

    @staticmethod
    def start():
        port = select_port()
        write_port_to_file(port)
        application.run(host='0.0.0.0', port=port)


def create_app():
    return App()


def is_port_in_use(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(('localhost', port)) == 0


def select_port():
    port = 8080
    while True:
        if is_port_in_use(port):
            port += 1
        else:
            break
    return port


def write_port_to_file(port):
    with open('/tmp/flint_python_executor_port', 'w') as writer:
        writer.write(str(port))

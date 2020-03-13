from flask import Flask, request, jsonify
from handler import Handler

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
        application.run(host='0.0.0.0', port=8080)


def create_app():
    return App()



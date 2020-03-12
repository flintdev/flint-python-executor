from flask import Flask, request

application = Flask(__name__)
gloabl_workflows = {}


class App:

    def __init__(self):
        pass

    def register_workflows(self, workflows):
        global gloabl_workflows
        gloabl_workflows = workflows

    @staticmethod
    @application.route('/execute')
    def execute():
        step = request.args.get('step')
        workflow = request.args.get('workflow')
        gloabl_workflows[workflow][step]()
        return "complete"

    @staticmethod
    def start():
        application.run(host='0.0.0.0', port=8080)


def create_app():
    return App()



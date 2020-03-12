# executor-python

```python
# pip install flint-executor

from flint.executor import create_app
from workflow1 import step1

workflows = {
    "workflow1": {
        "step1": step1.execute
    }
}

app = create_app()
app.register_workflows(workflows)

if __name__ == "__main__":
    app.start()



# step1.py

def execute(handler):
    handler.flow_data.get()

    
    
    
```
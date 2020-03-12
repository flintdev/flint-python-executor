# executor-python

## Installation
```shell script
pip install flint-python-executor
```

## File structure

```
|--flint-python-executor-example 
|  |--app.py
|  |--workflows
|    |--__init__.py
|    |--workflow1
|      |--__init__.py
|      |--step1.py
|      |--step2.py
|      |--step3.py
|      |--step4.py

```

```python
# pip install flint-python-executor

from flint import create_app
from workflows.workflow1 import step1, step2, step3, step4

workflows = {
    "workflow1": {
        "step1": step1.execute,
        "step2": step2.execute,
        "step3": step3.execute,
        "step4": step4.execute
    }
}

app = create_app()
app.register_workflows(workflows)

if __name__ == "__main__":
    app.start()

```

## Start App
```shell script
python app.py
```

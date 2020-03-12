from setuptools import setup
import os
import sys

github_token = os.environ['GITHUB_TOKEN']

_here = os.path.abspath(os.path.dirname(__file__))

if sys.version_info[0] < 3:
    with open(os.path.join(_here, 'README.md')) as f:
        long_description = f.read()
else:
    with open(os.path.join(_here, 'README.md'), encoding='utf-8') as f:
        long_description = f.read()

version = {}
with open(os.path.join(_here, 'flint', 'version.py')) as f:
    exec(f.read(), version)

setup(
    name='flint-python-executor',
    version=version['__version__'],
    description=('flint python executor'),
    long_description=long_description,
    author='Gaoxin Dai',
    author_email='daigx1990@gmail.com',
    url='https://github.com/flintdev/flint-python-executor',
    license='Apache License 2.0',
    packages=['flint'],
    install_requires=[
      'Flask==1.1.1',
    ],
    dependency_links=[
        'git+https://{github_token}@github.com/flintdev/{package}.git'.format(github_token=github_token, package="flintdev")
    ],
    include_package_data=True,
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3'
    ]
    )

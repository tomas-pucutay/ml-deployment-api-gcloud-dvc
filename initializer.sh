#!/bin/bash

gunicorn api.main:app -b 0.0.0.0 -w 2 -k uvicorn.workers.UvicornWorker
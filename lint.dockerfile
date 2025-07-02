FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
RUN pip install flake8 pylint
RUN flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
RUN pylint app.py

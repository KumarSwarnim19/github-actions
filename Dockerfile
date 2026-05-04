FROM python:3.13-slim

WORKDIR /APP

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80
 
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
FROM python:3.10-slim
RUN apt-get update && apt-get install -y openscad && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY BOSL2 ./BOSL2
COPY screw_generator.scad .
COPY app.py .
COPY templates ./templates
RUN pip install flask
EXPOSE 5000
ENV OPENSCADPATH=/app
CMD ["python", "app.py"]
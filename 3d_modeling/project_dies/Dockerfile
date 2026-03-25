FROM python:3.12-slim-bookworm
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends openscad \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY BOSL2 ./BOSL2
COPY dies_gen.scad .
COPY app.py .
COPY templates ./templates
RUN pip install flask
EXPOSE 5000
ENV OPENSCADPATH=/app
CMD ["python", "app.py"]

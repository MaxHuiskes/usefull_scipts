FROM python:3.12-slim-bookworm

# Refresh OS packages and install only required runtime deps
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
       openscad \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python runtime deps
RUN pip install --no-cache-dir streamlit streamlit-stl

COPY app.py .
COPY generator.scad .

EXPOSE 8501

# Run as non-root
RUN useradd --create-home --shell /usr/sbin/nologin appuser \
    && chown -R appuser:appuser /app
USER appuser

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
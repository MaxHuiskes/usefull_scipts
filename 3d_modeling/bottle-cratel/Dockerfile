FROM python:3.11-slim

# Install OpenSCAD
RUN apt-get update && apt-get install -y openscad && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies
RUN pip install streamlit solidpython2

COPY app.py .

# Expose Streamlit port
EXPOSE 8501

# Run the web app
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
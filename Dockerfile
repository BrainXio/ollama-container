# Stage 1: Build
FROM alpine:3.20.0 as build

# Install Python and build dependencies
RUN apk add --no-cache python3-dev py3-pip build-base

# Set the working directory
WORKDIR /app

# Create a virtual environment
RUN python3 -m venv venv

# Activate virtual environment and install dependencies
COPY requirements.txt .
RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

# Copy the application source code
COPY src/ .

# Stage 2: Run
FROM alpine:3.20.0

# Install Python runtime
RUN apk add --no-cache python3

# Set the working directory
WORKDIR /app

# Copy the application source code and virtual environment from the build stage
COPY --from=build /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/app/venv/bin:$PATH"

# Run the application
CMD ["python3", "app/main.py"]

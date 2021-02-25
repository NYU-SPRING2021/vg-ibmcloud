# Start with a Linux micro-container to keep the image tiny
FROM alpine:3.7

# Document who is responsible for this image
MAINTAINER Seetharami R. Seelam "sseelam@nyu.edu"

# Install just the Python runtime (no dev)
RUN apk add --no-cache \
    python \
    py-pip \
    ca-certificates

# Expose any ports the app is expecting in the environment
ENV PORT 8001
EXPOSE $PORT

# Set up a working folder and install the pre-reqs
WORKDIR /app
ADD hello-app/requirements.txt /app
RUN pip install -r requirements.txt

# Add the code as the last Docker layer because it changes the most
ADD hello-app/hello.py  /app/hello.py

# Run the service
CMD [ "python", "hello.py" ]


FROM alpine:latest
WORKDIR /usr/src/app

# Install necessary packages (e.g., Docker CLI)
RUN apk add --no-cache bash

# Copy the setup script
COPY setup.sh .

# Make the script executable
RUN chmod +x setup.sh

# Run the script
CMD ["./setup.sh"]
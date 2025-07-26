# Use a lightweight image to serve static files
FROM node:20-alpine

# Install a static file server (serve)
RUN npm install -g serve

# Set working directory
WORKDIR /app

# Copy the already built static files
COPY dist/ .

# Expose port
EXPOSE 3000

# Start the static server
CMD ["serve", "-s", ".", "-l", "3000"]

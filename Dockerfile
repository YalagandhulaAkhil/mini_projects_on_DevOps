# Use an official HashiCorp Terraform image as the base
FROM hashicorp/terraform:latest

# Install AWS CLI
RUN apk add --no-cache python3 py3-pip jq && \
    pip install --upgrade awscli

# Set the working directory
WORKDIR /app

# Copy Terraform scripts into the container
COPY . /app

# Default command when the container runs
ENTRYPOINT [ "terraform" ]

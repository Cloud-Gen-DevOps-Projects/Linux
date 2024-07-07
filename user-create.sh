#!/bin/bash

# Function to check if a user already exists
check_user_existence() {
    if id "$1" &>/dev/null; then
        echo "User '$1' already exists."
        exit 1
    fi
}

# Function to securely prompt for password
prompt_for_password() {
    # Prompt for password (hidden input)
    read -s -p "Enter password for $username: " password
    echo
    # Prompt for password confirmation
    read -s -p "Confirm password: " password_confirm
    echo

    # Check if passwords match
    if [ "$password" != "$password_confirm" ]; then
        echo "Passwords do not match. Please try again."
        prompt_for_password
    fi
}

# Prompt for username
read -p "Enter username: " username

# Check if the user already exists
check_user_existence "$username"

# Prompt for full name
read -p "Enter full name: " full_name

# Prompt for home directory (optional)
read -p "Enter home directory (leave blank for default /home/$username): " home_dir
home_dir=${home_dir:-/home/$username}

# Create the user with useradd
sudo useradd -m -d "$home_dir" -c "$full_name" "$username"

# Check if useradd was successful
if [ $? -ne 0 ]; then
    echo "Failed to create user '$username'."
    exit 1
fi

# Prompt for password and set it securely
prompt_for_password

# Set password for the user
echo "$username:$password" | sudo chpasswd

# Check if setting password was successful
if [ $? -ne 0 ]; then
    echo "Failed to set password for user '$username'."
    exit 1
fi

# Display success message
echo "User '$username' created successfully."

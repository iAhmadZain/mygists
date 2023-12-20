#!/bin/bash

# Update Homebrew
brew update

# Install Composer if it doesn't exist
if ! type "composer" > /dev/null; then
  echo "Installing Composer..."
  brew install composer
else
  echo "Composer already installed."
fi

# Install Valet for Laravel
echo "Installing Valet for Laravel..."
composer global require laravel/valet
valet install

# Install Redis and Redis Cluster if they don't exist
if ! type "redis-server" > /dev/null; then
  echo "Installing Redis..."
  brew install redis
else
  echo "Redis already installed."
fi

# Install Redis extension for all available PHP versions
for version in $(ls -d /usr/local/Cellar/php/*/ | cut -d'/' -f6)
do
  echo "Installing Redis extension for PHP $version..."
  pecl install -f redis
  echo "extension=redis.so" >> /usr/local/etc/php/$version/php.ini
done

# Restart Valet to apply changes
valet restart

echo "Installation process completed."

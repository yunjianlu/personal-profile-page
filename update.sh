#!/bin/bash

# Quick update script for your profile page
# Run this on your droplet to update from GitHub

echo "🔄 Updating profile page..."

# Navigate to temporary directory
cd /tmp

# Remove old clone if exists
rm -rf personal-profile-page

# Clone latest version
git clone https://github.com/yunjianlu/personal-profile-page.git

# Copy updated files
sudo cp -r personal-profile-page/* /var/www/profile/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/profile
sudo chmod -R 755 /var/www/profile

# Restart nginx to clear any caches
sudo systemctl restart nginx

echo "✅ Profile page updated successfully!"
echo "🌐 Your updated page is live at: http://$(curl -s ifconfig.me)"

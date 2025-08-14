#!/bin/bash

# DigitalOcean Droplet Setup Script for Personal Profile Page
# Run this script on your Ubuntu droplet

echo "🚀 Setting up Personal Profile Page on DigitalOcean..."

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Nginx web server
sudo apt install nginx -y

# Install Git
sudo apt install git -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create web directory
sudo mkdir -p /var/www/profile

# Clone your repository
cd /tmp
git clone https://github.com/yunjianlu/personal-profile-page.git

# Copy files to web directory
sudo cp -r personal-profile-page/* /var/www/profile/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/profile
sudo chmod -R 755 /var/www/profile

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/profile << EOF
server {
    listen 80;
    server_name your-droplet-ip;
    
    root /var/www/profile/profilePage;
    index profile.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Cache static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable the site
sudo ln -s /etc/nginx/sites-available/profile /etc/nginx/sites-enabled/

# Remove default Nginx site
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Configure firewall
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable

echo "✅ Setup complete!"
echo "🌐 Your profile page should be accessible at: http://your-droplet-ip"
echo "📝 Don't forget to replace 'your-droplet-ip' in the Nginx config with your actual IP"

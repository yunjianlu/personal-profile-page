# DigitalOcean Deployment Guide

## Prerequisites
1. A DigitalOcean account
2. A droplet running Ubuntu 20.04/22.04
3. SSH access to your droplet

## Step 1: Create a DigitalOcean Droplet

1. **Login to DigitalOcean**
   - Go to https://cloud.digitalocean.com/
   - Click "Create" → "Droplets"

2. **Configure Droplet**
   - **Image**: Ubuntu 22.04 LTS x64
   - **Plan**: Basic ($4-6/month is sufficient)
   - **CPU**: Regular Intel/AMD
   - **Datacenter**: Choose closest to your location
   - **Authentication**: SSH Key (recommended) or Password
   - **Hostname**: `profile-server` or similar

3. **Create Droplet**
   - Click "Create Droplet"
   - Note down the IP address once created

## Step 2: Connect to Your Droplet

```bash
# Replace YOUR_DROPLET_IP with actual IP
ssh root@YOUR_DROPLET_IP
```

## Step 3: Deploy Your Profile Page

### Option A: Quick Deploy (Recommended)

1. **Download and run the setup script:**
```bash
wget https://raw.githubusercontent.com/yunjianlu/personal-profile-page/main/deploy.sh
chmod +x deploy.sh
sudo ./deploy.sh
```

2. **Update the Nginx configuration with your IP:**
```bash
sudo nano /etc/nginx/sites-available/profile
# Replace 'your-droplet-ip' with your actual droplet IP
sudo systemctl restart nginx
```

### Option B: Manual Setup

1. **Update system and install requirements:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx git -y
```

2. **Clone your repository:**
```bash
cd /tmp
git clone https://github.com/yunjianlu/personal-profile-page.git
```

3. **Setup web directory:**
```bash
sudo mkdir -p /var/www/profile
sudo cp -r personal-profile-page/* /var/www/profile/
sudo chown -R www-data:www-data /var/www/profile
sudo chmod -R 755 /var/www/profile
```

4. **Configure Nginx:**
```bash
sudo nano /etc/nginx/sites-available/profile
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name YOUR_DROPLET_IP;
    
    root /var/www/profile/profilePage;
    index profile.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

5. **Enable the site:**
```bash
sudo ln -s /etc/nginx/sites-available/profile /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

6. **Configure firewall:**
```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable
```

## Step 4: Access Your Profile Page

Visit: `http://YOUR_DROPLET_IP`

## Optional: Setup Domain Name

1. **Point your domain to the droplet IP**
   - Add an A record in your DNS settings
   - Point to your droplet's IP address

2. **Update Nginx configuration:**
```bash
sudo nano /etc/nginx/sites-available/profile
# Change server_name to your domain
server_name yourdomain.com www.yourdomain.com;
sudo systemctl restart nginx
```

3. **Setup SSL (recommended):**
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

## Updating Your Profile

To update your profile page:
```bash
cd /tmp
git clone https://github.com/yunjianlu/personal-profile-page.git
sudo cp -r personal-profile-page/* /var/www/profile/
sudo systemctl restart nginx
```

## Troubleshooting

1. **Check Nginx status:**
```bash
sudo systemctl status nginx
```

2. **Check Nginx error logs:**
```bash
sudo tail -f /var/log/nginx/error.log
```

3. **Test Nginx configuration:**
```bash
sudo nginx -t
```

4. **Check firewall status:**
```bash
sudo ufw status
```

## Costs
- **Basic Droplet**: $4-6/month
- **Optional Domain**: $10-15/year
- **Total**: ~$50-80/year for a professional web presence

Your solar system-themed profile page will be live and accessible worldwide! 🌟

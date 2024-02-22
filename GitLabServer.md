# ServerSetup
## GitLab Server

#### Install Dependencies:
```
sudo yum install -y curl policycoreutils openssh-server openssh-clients --allowerasing
```
#### Enable and Start SSH:
```
sudo systemctl enable sshd
sudo systemctl start sshd
```
#### Downloading GitLab Package
##### Community Edition :
```
sudo curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
```
##### Enterprice Edition :
```
sudo curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
```
#### To Viewlist of gitlab version on Amazon Linux
```
sudo yum list gitlab-ce --showduplicates
```
#### Install the GitLab with our Domain name with specific version or latest. 
#### Here I am using Community Edition
```
sudo EXTERNAL_URL="http://gitlab.yourdomain.com" yum install -y gitlab-ce
```
#### Changing ownership to user git 
```
sudo chown -R git:git /var/opt/gitlab/backups
```
#### Reconfigure
```
sudo gitlab-ctl reconfigure
```
#### Start
```
sudo gitlab-ctl start
```
#### Gitlab info
```
sudo gitlab-rake gitlab:env:info
```
#### Enable the GitLab service to start on boot:
```
sudo systemctl enable gitlab-runsvdir
```
#### Check GitLab Status
```
sudo gitlab-ctl status
```
#### Now GitLab instance should be accessible via http://gitlab.yourdomain.com or instance ip

## Steps for Configuring the SSL
#### Install Certbot: 
```
sudo yum install certbot
sudo yum install python-certbot-nginx
```
#### Stop GitLab services temporarily
```
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop puma
```
#### Obtain SSL Certificate:
```
sudo certbot --nginx -d gitlab.yourdomain.com -d www.gitlab.yourdomain.com
```
#### Configure GitLab for SSL:
```
sudo vi /etc/gitlab/gitlab.rb
```
#### In gitlab.rb file
##### 1. Press 'i' to edit 
##### 2. Change the url from http to https
```
external_url 'https://gitlab.yourdomain.com'
```
##### 3. Uncomment the ssl certificate and key path Then add the correct certificate and key path
```
nginx['ssl_certificate'] = "/etc/letsencrypt/live/gitlab.yourdomain.com/fullchain.pem"
nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/gitlab.yourdomain.com/privkey.pem"
```
##### 4. Save the file and Exit from editor 
```
:wq
```
#### Reconfigure and Restart
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```
#### Now GitLab instance should be accessible via https://gitlab.yourdomain.com

### BACKUP
#### Create a BACKUP
```
sudo gitlab-rake gitlab:backup:create
```
#### It will be saved as 1707992112_2024_02_15_14.0.0_gitlab_backup.tar at /var/opt/gitlab/backups/
#### For accessing that location need root privileges


### Restore from Existing Backup
#### a. Copy the backup file to the instance and move the file to /var/opt/gitlab/backups/
#### b. Stop the Gitlab Services (unicorn, puma, sidekiq)
```
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop puma
sudo gitlab-ctl stop sidekiq
```
#### c. Restore from Backup
##### For BACKUP= Copy the {timestamp + version} = (1708411210_2024_02_20_16.9.0) from 1708411210_2024_02_20_16.9.0_gitlab_backup.tar
```
sudo gitlab-rake gitlab:backup:restore BACKUP=1708411210_2024_02_20_16.9.0
```
#### Reconfigure and Restart
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```

### Upgrading to latest version 
```
sudo apt-get install gitlab-ce
sudo gitlab-ctl restart redis
sudo gitlab-rake db:migrate
sudo gitlab-rake gitlab:background_migrations:finalize[ProjectNamespaces::BackfillProjectNamespaces,projects,id,'[null\,"up"]']\
```
#### Reconfigure and Restart
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```

## For Ubuntu 
#### Downloading GitLab Package
##### Community Edition :
```
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
```
##### Enterprice Edition :
```
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
```
#### To Viewlist of gitlab version on ubuntu
```
sudo apt list -a gitlab-ce
```
#### Install the GitLab with our Domain name with specific version or latest.
#### Here I am using Community Edition
```
sudo EXTERNAL_URL="http://gitlab.yourdomain.com" apt install -y gitlab-ce
```





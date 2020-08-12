wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz
mkdir /opt/tomcat8
mv apache-tomcat-8.5.50.tar.gz /opt/tomcat8
cd /opt/tomcat8
tar -xzvf /opt/tomcat8/apache-tomcat-8.5.50.tar.gz
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat8 tomcat
chgrp -R tomcat /opt/tomcat8
cd /opt/tomcat8/apache-tomcat-8.5.50
chmod -R g+r conf
chmod g+x conf
chmod -R 777 webapps/
chown -R tomcat webapps/ work/ temp/ logs/
cat >> /etc/systemd/system/tomcat.service <<EOL
[Unit]
Description=Apache Tomcat
After=syslog.target network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/
Environment=CATALINA_PID=/opt/tomcat8/apache-tomcat-8.5.50/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat8/apache-tomcat-8.5.50
Environment=CATALINA_BASE=/opt/tomcat8/apache-tomcat-8.5.50
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
WorkingDirectory=/opt/tomcat8/apache-tomcat-8.5.50
ExecStart=/opt/tomcat8/apache-tomcat-8.5.50/bin/startup.sh
ExecStop=/opt/tomcat8/apache-tomcat-8.5.50/bin/shutdown.sh
User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target
EOL
cd /opt/tomcat8/apache-tomcat-8.5.50/conf/
sudo sed -i 's/8080/8000/g' server.xml
systemctl daemon-reload
systemctl start tomcat

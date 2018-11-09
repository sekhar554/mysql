#!/bin/bash
SRC_DIR=/home/admin/BOA/AS-BAC-BPA
cd $SRC_DIR
cat $SRC_DIR/src/environments/environment.prod.ts | sed 's/8447/7447/g' | tee $SRC_DIR/src/environments/environment.prod.ts
#npm install --unsafe-perm
npm run build:prod
docker-compose up -d



Router NAT Configuration

8447 7447 - One Port    - 192.168.0.121
8082 7082 - Second Port - 192.168.0.121


Team, Please find below Global URL for BOA Portal.
https://noida.infinitylabs.in:7082
admin/admin

rsync -av --delete --exclude=node_modules/* /home/priyanka/mvp_main/* admin@192.168.0.128:/home/admin/BOA/AS-BAC-BPA-mvp_main


 npm run build:prod
 docker-compose up -d

A/c No: 50100160128161 


root/root@123

root/Infi@app1234
admin/admin123

app@1234
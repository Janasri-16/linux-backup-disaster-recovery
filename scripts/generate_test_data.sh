#!/bin/bash

set -e

HOME_DIR="./test-data/home"
ETC_DIR="./test-data/etc"
WWW_DIR="./test-data/www"

echo "Starting test data generation..."
mkdir -p "$HOME_DIR/Documents"
mkdir -p "$HOME_DIR/Downloads"
mkdir -p "$HOME_DIR/Pictures"

mkdir -p "$ETC_DIR"

mkdir -p "$WWW_DIR/css"
mkdir -p "$WWW_DIR/js"
mkdir -p "$WWW_DIR/images"

mkdir -p "$HOME_DIR/logs"
mkdir -p "$HOME_DIR/projects/project1"
mkdir -p "$HOME_DIR/projects/project2"

echo "Directories created."

for i in {1..10}
do
    echo "This is sample document $i" > "$HOME_DIR/Documents/document$i.txt"
done

cat <<EOF > "$ETC_DIR/app.conf"
APP_NAME=BackupSystem
ENVIRONMENT=Production
PORT=8080
LOG_LEVEL=INFO
EOF

cat <<EOF > "$WWW_DIR/index.html"
<!DOCTYPE html>
<html>
<head>
<title>Backup Demo</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<h1>Linux Backup Project</h1>

<p>Generated Automatically</p>

</body>
</html>
EOF

cat <<EOF > "$WWW_DIR/css/style.css"
body{
font-family:Arial;
background:#f5f5f5;
}

h1{
color:blue;
}
EOF


cat <<EOF > "$WWW_DIR/js/app.js"
console.log("Backup Demo");
EOF


for i in {1..50}
do
    echo "$(date) INFO User Login Successful" >> "$HOME_DIR/logs/system.log"
done



dd if=/dev/zero of="$HOME_DIR/Downloads/sample.img" bs=1M count=10 status=none


for i in {1..5}
do
    head -c 10240 /dev/urandom > "$HOME_DIR/Documents/random$i.bin"
done



echo
echo "========================================="
echo " Test data generated successfully!"
echo "========================================="

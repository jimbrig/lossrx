docker build -t lossreservingapi:latest .
docker run -p 80:80 -d lossreservingapi:latest

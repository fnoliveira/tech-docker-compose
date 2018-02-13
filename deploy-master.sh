echo "setup deploy"

if [ -d /var/tc/docker ]; then

        echo "YES"
        docker stop $(docker ps -a -q)
        docker start $(docker ps -a -q)

else

        echo "NO"
        docker stop $(docker ps -a -q)

        docker network prune -f
        docker network create -d bridge prod-network

        docker volume prune -f
        docker volume create mysqldb-vol

        docker rm $(docker ps -a -q)

        docker run -d -p 3306:3306 --name mysql-docker-container --net=prod-network -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=tecdb -e MYSQL_USER=root -e MYSQL_PASSWORD=root -v mysqldb-vol:/var/lib/mysql mysql:latest

        docker start mysql-docker-container

        sudo mkdir -p /var/tc/docker/deploy
        sudo chmod -R 777 /var/tc/docker/deploy
        cd /var/tc/docker
        sudo git init

        sudo mkdir -p /var/tc/docker/deploy/prod/final
        sudo chmod -R 777 /var/tc/docker/deploy/prod/final

        sudo mkdir -p /var/tc/docker/deploy/prod/as
        sudo chmod -R 777 /var/tc/docker/deploy/prod/as
        cd /var/tc/docker/deploy/prod/as
        sudo git init

        sudo mkdir -p /var/tc/docker/deploy/prod/rs
        sudo chmod -R 777 /var/tc/docker/deploy/prod/rs
        cd /var/tc/docker/deploy/prod/rs
        sudo git init

        sudo mkdir -p /var/tc/www
        sudo chmod -R 777 /var/tc/www
        cd /var/tc/www
        sudo git init

        sudo mkdir -p /var/www
        sudo chmod -R 777 /var/www

fi

function build(){
        echo "build project"
        if mvn clean package; then
                echo build ok
        else
                echo Something wrong.
                exit 1
        fi

}

echo "as"
cd /var/tc/docker/deploy/prod/as
sudo git pull https://github.com/fnoliveira/tech-control-authorization-server.git
build
echo "moving file"
mv -f  target/authorization-0.0.1-SNAPSHOT.jar /var/tc/docker/deploy/prod/final

echo "rs"
cd /var/tc/docker/deploy/prod/rs
sudo git pull https://github.com/fnoliveira/tech-control-rest.git
build
echo "moving file"
mv -f  target/rest-0.0.1-SNAPSHOT.jar /var/tc/docker/deploy/prod/final

echo "docker"
cd /var/tc/docker
sudo git pull https://github.com/fnoliveira/tech-docker-compose.git
if [ -d /var/tc/docker ]; then
        docker-compose up -d --build
else
sudo    sudo docker-compose up -d
fi

echo "ui"
cd /var/tc/www
sudo git pull https://github.com/fnoliveira/tech-control-ui.git
sudo npm cache verify
sudo pm2 stop server.js
sudo npm install --unsafe-perm
sudo npm start

echo "deploy finish"
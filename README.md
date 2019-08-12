## About
The Dockerfile creates a docker image of an [elog](https://elog.psi.ch/elog/) server (3.1.2) built on Debain 9 (stretch-slim).  

The example configuration file creates 3 logbooks: Experiment, Hardware, and Simulation.

## Docker image
Pull the Dockerfile from github
```
git clone --recursive https://github.com/ad3ller/elog-docker
cd ./elog-docker
```

Edit elog.conf to suit your needs and then build the docker image
```
docker build -t elog .
```

Alternatively, pull the automated-build image from [dockerhub](https://hub.docker.com/r/de1lz/elog-docker/)
```
docker pull de1lz/elog-docker
docker tag de1lz/elog-docker elog
```

## Example usage
Create docker volumes to store the config file and logbooks,
```
docker volume create --name elog_conf
docker volume create --name logbooks
```

Run the docker image,
```
docker run --name elog-1 --restart always -d -p 8080:8080 -v elog_conf:/etc/elog -v logbooks:/var/lib/elog elog
```

This forwards port 8080 from the container to [localhost:8080](http://localhost:8080)

Nb.  This method allows you to preserve modifications made to elog.conf.  Instead, you may wish to use a static config file.  In this case modify elog.conf before building the image and omit the elog_conf volume when running.  You may also wish to make /etc/elog/elog.conf read only using chmod in the Dockerfile.

## Notes
In the example config, Latex math can be rendered using [MathJax](https://www.mathjax.org/).  This recognises inline math `$ ... $` and numbered equations `\being{equation} ... \end{equation}` in elog entries.

SMTP (email notification) is not tested (and very probably doesn't work).

## Warning
SSL is not supported. Passwords sent over the network are vulnerable to sniffing attacks. It's strongly recommended that you use an SSL-enabled proxy (e.g., Apache or nginx). 

For setting-up, *Self registration = 1*.  It's advisable to set the *Admin user* and disable *Self registration*.  See elog.conf [syntax](https://midas.psi.ch/elog/config.html).

# docker-mumble

A nice and easy way to get a Mumble server up and running using docker.
For help on getting started with docker see the [official getting started guide](https://docker.github.io/engine/getstarted/).
For more information on Mumble check out its [website](http://wiki.mumble.info/wiki/Main_Page).


## Running docker-mumble

To build and run the image

```sh
# Build image
docker build -t mumble .
# Create a root-only data directory on the host system.
# "mumble" direcotry would be chowned to the mumble user, user id of which might
# collide with some other user on the host system, so we have a root-only
# "docker-volumes" which won't allow anyone without root to access "mumble",
# even if user ids collide.
mkdir -p /var/lib/docker-volumes/mumble
chmod 700 /var/lib/docker-volumes
chown root:root /var/lib/docker-volumes
# 100M of RAM and unlimited swap should be enough for 10 mumble users
docker run -d \
           -m 100M \
           --memory-swap -1 \
           --name mumble \
           -v /var/lib/docker-volumes/mumble:/data \
           -p 64738:64738 \
           -p 64738:64738/udp \
           mumble
```

The very first time you run the container, it will create a user database, a file containing the SuperUser password and a sed'ed by scripts/start script configuration file in the `/var/lib/docker-volumes/mumble` directory.
You can modify the configuration file in that directory and restart the container for the changes to take place.
Also, on the first run, the SuperUser password will be printed to the stdout, which you can access with `docker logs mumble`.
If you need to troubleshoot something, mumble logs are also stored in the `/var/lib/docker-volumes/mumble` directory.

The mumble server is configured to require a SSL certificate in order to run.
You can edit the configuration file to disable this requirement, though I would really advise against this, [especially given how easy is to get a free SSL certificate and automate its renewal nowadays]( https://letsencrypt.org/).

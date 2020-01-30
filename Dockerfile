# Set the base as the nvidia-cuda Docker
FROM jakubsacha/docker-xmlstarlet
# Create directory for all of the files to go into and cd into it

RUN apt-get update
RUN apt-get install perl

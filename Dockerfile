FROM ubuntu:16.04
# Create directory for all of the files to go into and cd into it

RUN apt-get update && apt-get install -y --no-install-recommends \
perl \
xmlstarlet

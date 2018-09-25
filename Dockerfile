#
# Build with e.g. `docker build --force-rm=true -t imis3/sedtest .'
#

FROM httpd:2.4
MAINTAINER mlechner@bfs.de

ENV DEBIAN_FRONTEND noninteractive

#
# Install required packages
#

# RUN apt-get update -y && apt-get -y upgrade

ADD app.js .

RUN GITINFO=" $(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" &&  echo ${GITINFO}

RUN GITINFO=" $(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" && \
    echo ${GITINFO} && sed -i -e "/Lada.clientVersion/s/';/${GITINFO}';/" app.js

RUN echo build $(grep Lada.clientVersion app.js)

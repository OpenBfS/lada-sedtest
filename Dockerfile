#
# Build with e.g. `docker build --force-rm=true -t openbfs/sedtest .'
#

FROM httpd:2.4
MAINTAINER mlechner@bfs.de

ENV DEBIAN_FRONTEND noninteractive

#
# Install required packages
#

RUN apt-get update -y && apt-get -y install git

ADD bar.js ./
ADD .git ./

RUN cat bar.js

RUN GITINFO_0="$(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" &&\
    echo ${GITINFO_0}

RUN GITINFO_1=" $(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" &&\
    echo ${GITINFO_1} &&\
    sed -i "s/Foo.clientVersion = '0.1-SNAPSHOT';/Foo.clientVersion = '0.1-SNAPSHOT${GITINFO_1}';/g" bar.js

RUN echo $(grep Foo.clientVersion bar.js)

RUN GITINFO_2=" $(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" &&\
    echo ${GITINFO_2} &&\
    sed -i -e "/Foo.serverVersion/s/';/${GITINFO_2}';/" bar.js

RUN echo $(grep Foo.serverVersion bar.js)

RUN GITINFO_3=" $(git name-rev --name-only HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)" &&\
    echo ${GITINFO_3} &&\
    sed -i -e "/Foo.username/s/'*';/${GITINFO_3}';/" bar.js

RUN echo $(grep Foo.username bar.js)

RUN cat bar.js

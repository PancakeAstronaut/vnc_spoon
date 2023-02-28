FROM alpine:3.14


# Install Corretto
ARG version=8.362.08.1

# Please note that the THIRD-PARTY-LICENSE could be out of date if the base image has been updated recently. 
# The Corretto team will update this file but you may see a few days' delay.
RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-8=$version-r0
    
ENV LANG C.UTF-8

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

# Copy the files for PDI
ADD data-integration /pentaho/pdi7/
RUN chmod +x /pentaho/pdi7/spoon.sh

WORKDIR /

# Install other stuff
RUN apk add glib-dev
RUN apk add gtk+2.0

# Install VNC
RUN apk update
RUN apk add x11vnc
RUN apk add xvfb
RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
RUN apk add glibc-2.28-r0.apk
RUN apk add mesa-egl
RUN apk add pciutils-dev
RUN apk add xfce4 lxdm
RUN echo "exec /pentaho/pdi7/spoon.sh" > ~/.xinitrc && chmod +x ~/.xinitrc

# Expose Default VNC port
EXPOSE 5900  

# Run the x11vnc server
CMD "x11vnc" "-create" "-forever"





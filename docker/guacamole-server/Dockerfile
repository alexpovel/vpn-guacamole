# Use Debian 11 so `freerdp2` is a release version and guacamole doesn't complain,
# see http://apache-guacamole-general-user-mailing-list.2363388.n4.nabble.com/Guacamole-v1-3-0-FreeRDP-v2-0-0-Debian-10-td9889.html
FROM debian:bullseye

ARG VERSION=1.3.0

# Official `guacamola/guacd` Docker image doesn't have RDP support, see also
# http://apache-guacamole-general-user-mailing-list.2363388.n4.nabble.com/Support-for-protocol-rdp-vnc-is-not-installed-td7473.html
# Hence, build from source ourselves.

# https://guacamole.apache.org/doc/gug/installing-guacamole.html#building-guacamole-server
RUN apt-get update && apt-get install --yes --no-install-recommends \
    # make, gcc etc.:
    build-essential \
    # Required dependencies:
    libcairo2-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libtool-bin \
    libossp-uuid-dev \
    # Optional dependencies:
    libvncserver-dev \
    # RDP Support:
    freerdp2-dev \
    # SSH support:
    libssh2-1-dev \
    # Telnet support:
    libtelnet-dev \
    # Required for Kubernetes support:
    libwebsockets-dev \
    # (Experimental) VNC audio support:
    libpulse-dev \
    # Compressed sound:
    libvorbis-dev \
    # Replace JPG where applicable:
    libwebp-dev \
    # Encryption support:
    libssl-dev \
    # Text layout for SSH etc.:
    libpango1.0-dev \
    # FFmpeg:
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    # Other:
    ca-certificates \
    wget

RUN wget --output-document=guac.tar.gz \
    "https://apache.org/dyn/closer.lua/guacamole/$VERSION/source/guacamole-server-$VERSION.tar.gz?action=download" \
    && tar -xvf guac.tar.gz \
    && cd "guacamole-server-$VERSION" \
    && ./configure \
    && make \
    && make install \
    && ldconfig


# `-f`: run in foreground
# `-b`: bind to address
ENTRYPOINT [ "guacd", "-b", "0.0.0.0", "-f" ]

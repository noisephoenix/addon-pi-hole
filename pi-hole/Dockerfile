ARG BUILD_FROM=hassioaddons/base-amd64:1.0.1
FROM ${BUILD_FROM}

ENV PATH="${PATH}:/opt/pihole" \
    CORE_TAG="v3.1.4" \
    WEB_TAG="v3.1" \
    FTL_TAG="v2.11.1"

# Copy root filesystem
COPY rootfs /

# Setup base
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc \
        musl-dev \
        make \
    \
    && apk add --no-cache \
        bind-tools \
        wget \
        libcap \
        dnsmasq-dnssec \
        nginx \
        php7-fpm \
        php7-json \
        php7-openssl \
        php7-opcache \
        php7-zip \
        php7-session \
        php7-sockets \
        logrotate \
        libxml2 \
        bc \
        bash \
        curl \
        perl \
        sudo \
        git \
        procps \
        openssl \
    \
    && addgroup -S pihole \
    && adduser -S -s /sbin/nologin pihole pihole \
    && addgroup -S dnsmasq \
    && adduser -S -s /sbin/nologin dnsmasq dnsmasq \
    && addgroup pihole nginx \
    \
    && git clone --branch "${CORE_TAG}" --depth=1 \
        https://github.com/pi-hole/pi-hole.git /etc/.pihole \
    && git -C /etc/.pihole checkout -b master \
    \
    && git clone --branch "${WEB_TAG}" --depth=1 \
        https://github.com/pi-hole/AdminLTE.git /var/www/html/admin \
    && git -C /var/www/html/admin checkout -b master \
    \
    && git clone --branch "${FTL_TAG}" --depth=1 \
        https://github.com/pi-hole/FTL.git /root/FTL \
    \
    && cd /root/FTL \
    && make \
    && mv /root/FTL/pihole-FTL /usr/bin \
    && cd - \
    \
    && install -o pihole -Dm755 -d "/opt/pihole" \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/gravity.sh \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/advanced/Scripts/*.sh \
    && install -o pihole -Dm755 -t "/usr/local/bin" /etc/.pihole/pihole \
    \
    && rm -f -r /root/FTL \
    && apk del --purge .build-dependencies

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Pi-hole" \
    io.hass.description="Network-wide ad blocking using your Hass.io instance" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Network-wide ad blocking using your Hass.io instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Pi-hole" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-pi-hole/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-pi-hole" \
    org.label-schema.vendor="Community Hass.io Addons"
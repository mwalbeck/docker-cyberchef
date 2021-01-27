FROM node:10.23.2-buster@sha256:7a823c87112084325eb7df99977db1780ab1284b8935260f4b5034f1e3595c64 as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v9.21.0

RUN set -ex; \
    \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git /cyberchef; \
    cd /cyberchef; \
    npm install -g grunt-cli; \
    npm install; \
    grunt prod; \
    rm /cyberchef/build/prod/BundleAnalyzerReport.html /cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM busybox:1.33.0-uclibc@sha256:7c8148f0113e488fea668b1ba5a45397dc522278835ad672c182332e034b8aa1
COPY --from=build /cyberchef/build/prod /cyberchef
COPY entrypoint.sh /entrypoint.sh
RUN set -ex; \
    \
    chmod +x /entrypoint.sh;

VOLUME /var/www/cyberchef
ENTRYPOINT ["/entrypoint.sh"]
CMD ["true"]

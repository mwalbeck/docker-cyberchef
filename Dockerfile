FROM node:10.23.0-buster as build

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

FROM busybox:1.32.0-uclibc
COPY --from=build /cyberchef/build/prod /cyberchef
COPY entrypoint.sh /entrypoint.sh
RUN set -ex; \
    \
    chmod +x /entrypoint.sh;

VOLUME /var/www/cyberchef
ENTRYPOINT ["/entrypoint.sh"]
CMD ["true"]
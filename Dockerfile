FROM node:10.23.0-buster@sha256:8ea581a393d4a1a22c469901f9c08d822ea3383ba6129b41e8dac4717e681d4b as build

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

FROM busybox:1.32.0-uclibc@sha256:31a54a0cf86d7354788a8265f60ae6acb4b348a67efbcf7c1007dd3cf7af05ab
COPY --from=build /cyberchef/build/prod /cyberchef
COPY entrypoint.sh /entrypoint.sh
RUN set -ex; \
    \
    chmod +x /entrypoint.sh;

VOLUME /var/www/cyberchef
ENTRYPOINT ["/entrypoint.sh"]
CMD ["true"]

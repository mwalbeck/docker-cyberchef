FROM node:10.23.2-buster@sha256:54d24218dbb112e2fb6ffe521a1afdc09877acd7903545d118aab45ae60f7b68 as build

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

FROM busybox:1.33.0-uclibc@sha256:4f405c9ddb487625db3f1a1f11bb90b494a38fb2f8a2c12935919ddd6e2cebcc
COPY --from=build /cyberchef/build/prod /cyberchef
COPY entrypoint.sh /entrypoint.sh
RUN set -ex; \
    \
    chmod +x /entrypoint.sh;

VOLUME /var/www/cyberchef
ENTRYPOINT ["/entrypoint.sh"]
CMD ["true"]

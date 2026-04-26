FROM node:20.20.2-trixie@sha256:fd6b1ef9b7f1d9506868addc44e7f79e0fc3f1b071a85050e33e5b1a6fdcff83 AS build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION=v10.23.0

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.28.2@sha256:0b31859f91f223bd3f741a25946839012740b31dcb4b7f29a79f229ed4e0c5d6
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

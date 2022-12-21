FROM node:16.19.0-bullseye@sha256:9620fb4e44fca4d27d01b6acaddbf5d5fbc43bf4b48053b0a2feb2dbb5aa63d3 as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v9.55.0

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.22.1@sha256:3772020d3899f7ae3f746ab1303bb1f69d8ba6be9fb1ef3dd3eb5f0e1f8adfbb
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

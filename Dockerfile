FROM node:16.19.1-bullseye@sha256:06f6450076a81c32120db39e67c0ea531d6428be3236ca66cc4a2196ea51c9ce as build

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

FROM nginxinc/nginx-unprivileged:1.22.1@sha256:c43c05182446f425555690d2076ca0668dc17ace713456c76d0a8b10bd6acddc
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

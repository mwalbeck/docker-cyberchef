FROM node:16.20.0-bullseye@sha256:67deed31d35f87fd58d8d38f9cf5df405315a9d637ba8c2ed5efdeac2edb12c8 as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v10.4.0

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.24.0@sha256:8689713827b16ea5aab24630ec5e58f38edb18119863ab39d388a1b41708f3e1
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

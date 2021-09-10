FROM node:10.24.1-buster@sha256:05e259ab6478ae6032163ce34683bfccb495c8219f2f01a8d30889bb3ce33084 as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v9.32.3

ENV NODE_OPTIONS --max_old_space_size=2048

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.20.1-amd64@sha256:49a5602cc852a6f4134d7046754f0ab21a86a4950ffce938fdd74eee19fcc096
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

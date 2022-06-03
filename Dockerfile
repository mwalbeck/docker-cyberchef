FROM node:16.15.0-bullseye@sha256:02b94e296a770967e3258e9cec42d3e9c4411ee09bec0528fb86110dded59d34 as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v9.38.6

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.20.2-amd64@sha256:4a3effb7b42d2df1819354e1c7096795176373a630f2712decdfe0f17fe31636
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

FROM node:16.18.1-bullseye@sha256:18625c8220d05fc2f9e2ac69a0109e6defc4f2077b45f80dddb19381b63f352d as build

# renovate: datasource=github-tags depName=gchq/CyberChef versioning=semver
ENV CYBERCHEF_VERSION v9.49.0

USER node

RUN set -ex; \
    mkdir /tmp/cyberchef;

WORKDIR /tmp/cyberchef

RUN set -ex; \
    git clone --branch $CYBERCHEF_VERSION https://github.com/gchq/CyberChef.git .; \
    npm install; \
    npx grunt prod; \
    rm /tmp/cyberchef/build/prod/BundleAnalyzerReport.html /tmp/cyberchef/build/prod/CyberChef_$CYBERCHEF_VERSION.zip;

FROM nginxinc/nginx-unprivileged:1.22.1@sha256:a99ce7abbcb5d524c99f94563ace20ab51d991910f26d09ada982de55fbc7543
COPY --from=build /tmp/cyberchef/build/prod /usr/share/nginx/html
EXPOSE 8080

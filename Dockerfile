FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

LABEL org.opencontainers.image.source="https://github.com/codeadminde/alpine-toolbox"
LABEL org.opencontainers.image.description="Docker image based on alpine image, with additional binaries for building and configuring stuff."

# renovate: datasource=repology depName=alpine_3_23/bash versioning=loose
ENV APK_BASH_VERSION=5.3.3-r1
# renovate: datasource=repology depName=alpine_3_23/docker-cli versioning=loose
ENV APK_DOCKER_CLI_VERSION=29.1.3-r2
# renovate: datasource=repology depName=alpine_3_23/httpie versioning=loose
ENV APK_HTTPIE_VERSION=3.2.4-r1
# renovate: datasource=repology depName=alpine_3_23/curl versioning=loose
ENV APK_CURL_VERSION=8.17.0-r1
# renovate: datasource=repology depName=alpine_3_23/jq versioning=loose
ENV APK_JQ_VERSION=1.8.1-r0
# renovate: datasource=repology depName=alpine_3_23/coreutils versioning=loose
ENV APK_COREUTILS_VERSION=9.8-r1
# renovate: datasource=repology depName=alpine_3_23/gettext versioning=loose
ENV APK_GETTEXT_VERSION=0.24.1-r1

RUN apk --no-cache add --update \
      bash="$APK_BASH_VERSION" \
      docker-cli="$APK_DOCKER_CLI_VERSION" \
      httpie="$APK_HTTPIE_VERSION" \
      curl="$APK_CURL_VERSION" \
      jq="$APK_JQ_VERSION" \
      coreutils="$APK_COREUTILS_VERSION" \
      gettext="$APK_GETTEXT_VERSION"

# renovate: datasource=custom.k8s depName=kubectl
ENV KUBECTL_VERSION=v1.35.1

RUN curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256"

RUN echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check - && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    rm kubectl.sha256

RUN addgroup -g 1001 appusr && adduser -u 1001 -G appusr -D -H appusr

USER appusr
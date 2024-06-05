FROM alpine:3.20
LABEL maintainer="Salvoxia <salvoxia@blindfish.info>"
ARG TARGETPLATFORM
# Determine Minio Client Architecture sub-URL
RUN case "${TARGETPLATFORM}" in \
        "linux/amd64")    MC_ARCH=linux-amd64  ;; \
        "linux/arm64")    MC_ARCH=linx-arm64  ;; \
        "linux/arm64/v8") MC_ARCH=linx-arm64  ;; \
        "linux/arm/v7")   MC_ARCH=linux-arm  ;; \
        *) exit 1 ;; \
    esac; \
    wget https://dl.min.io/client/mc/release/${MC_ARCH}/mc; \
    chmod +x ./mc

    ADD . .

CMD ["sh", "setup.sh"]

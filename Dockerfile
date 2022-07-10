FROM node:14-slim

# Install Chromium dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libasound2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3

# Install Puppeteer
WORKDIR /opt/pptr
ARG PPTR_VERSION 15
RUN npm install puppeteer@$PPTR_VERSION

# Install our Node program
COPY pdf ./

# A few defaults - ensure you set ATL_USERNAME & ATL_PASSWORD
ENV PATH="/opt/pptr:$PATH" \
    PAPER_FORMAT=Letter \
    PAPER_MARGIN=50px \
    TZ="America/New_York" \
    ATL_USERNAME= \
    ATL_PASSWORD=

# Create a user for Chrome to run non-root
RUN groupadd -r chrome \
 && useradd -r -m -g chrome chrome
USER chrome

# set a working directory for PDF output
WORKDIR /output

ENTRYPOINT [ "pdf" ]

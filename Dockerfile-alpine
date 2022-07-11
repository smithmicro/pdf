FROM zenika/alpine-chrome:with-puppeteer

# Install our Node program
COPY pdf /usr/src/app/

# A few defaults - ensure you set ATL_USERNAME & ATL_PASSWORD
ENV PATH="/usr/src/app:$PATH" \
    PAPER_FORMAT=Letter \
    PAPER_MARGIN=50px \
    TZ="America/New_York" \
    ATL_USERNAME= \
    ATL_PASSWORD=

# set a working directory for image output
WORKDIR /output

ENTRYPOINT [ "pdf" ]

# smithmicro/pdf
Create PDFs from Jira and Confluence

## Overview
Our product documentation is split between Jira tickets and Conflunce Wiki pages.  We were looking for a single tool to export PDFs from these two Atlassian tools.

Not finding anything that met our requirements, we developed `smithmicro/pdf` to help us create both internal and customer documentation.  Here are our initial requirements that this tool inspired:
1. Create PDF files from Confluence and Jira - Data Center versions
2. Support username/password authentication with both tools
3. Command Line Interface (CLI) for easy automation
4. Mimimal Docker image that can be run anywhere
5. Adjustable paper sizes and margins

## How to use
Here is a simple use case creating a PDF from Google:
```
docker run --init -v $PWD:/output smithmicro/pdf https://www.google.com
```
You will see a message saying that the program did not detect either Jira or Confluence which will bypass authectication.  To create a PDF of JIRA page, use:
```
docker run --init -v $PWD:/output -e ATL_USERNAME=myusername -e ATL_PASSWORD=mypassword smithmicro/pdf https://jira.mydomain.com/browse/PROJ-1
```
Or Confluence:
```
docker run --init -v $PWD:/output -e ATL_USERNAME=myusername -e ATL_PASSWORD=mypassword smithmicro/pdf https://wiki.mydomain.com/display/SPACE/Page+Name
```

## Environment Variables
The following required and optional environment variables are supported:

| Variable | Required | Default | Notes |
|---|---|---|---|
|ATL_USERNAME|Yes|None|Atlassian Username|
|ATL_PASSWORD|Yes|None|Atlassian Password|
|PAPER_FORMAT|No|Letter|See supported paper formats: https://pptr.dev/api/puppeteer.paperformat|
|PAPER_MARGIN|No|50px|Margins used for Confluence printing.  Jira uses 0 margins as this looks great.|
|TZ|No|America/New_York|Time zone used by Chromium.|

## Time Zone
One drawback of using the priting system to generate PDFs from Jira is that it can complain about the client time zone.  If you see this message, you will need to adjust the `TZ` environment variable.
```
Your computer's time zone does not match your Jira time zone preference of (GMT-08:00) Los Angeles.  Update your Jira preference
```
Conflunce does not have a similar check during print rendering.

## Tested Versions
We have only tested the following:
* Confluence 7.13.7 - Data Center
* Jira 8.20.8 - Data Center

Note:  We are looking for help from the community to help us support a broader set of versions.  Pull requests welcome.

## Technology
This image is built on top of [Puppeteer](https://pptr.dev/) and [Chromium](https://www.chromium.org/Home/).  The goal of this image is to let Puppeteer do what it does best and install the supported version of Chromium as described [here](https://pptr.dev/faq/#q-why-doesnt-puppeteer-vxxx-work-with-chromium-vyyy).  This image is based on the offcial Docker image `node:14-slim` as Puppeteer follows the latest maintenance [LTS version of Node](https://www.npmjs.com/package/puppeteer#Usage).

## Docker init
Many Puppeteer Docker images install an init package such as [tini](https://github.com/krallin/tini) or [dumb-init](https://github.com/Yelp/dumb-init).  Since Docker has included `tini` since early versions, we recommend the use of the `--init` CLI switch to achive the same thing.

## Alpine version
The main `:latest` tag uses `node:14-slim` as a base image, however [Zenika/alpine-chrome](https://github.com/Zenika/alpine-chrome) has an excellent set of Docker images for Chromium on Alpine including one `with-puppeteer`.  The alpine variant using can be found in `Dockerfile-alpine`.

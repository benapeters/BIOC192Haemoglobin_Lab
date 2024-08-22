FROM openanalytics/r-ver:4.4.0
LABEL maintainer="benapeters"
ARG shinyapp BIOC192_HaemoglobinLab
#~wimg 20240614 

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        libproj22 \
        libproj-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

RUN R -q -e "install.packages(c('shiny', 'ggplot2', 'rhandsontable', 'ggalt'), dependencies=TRUE)"

RUN mkdir /opt/app
COPY app.R /opt/app/

COPY Rprofile.site /usr/local/lib/R/etc/

RUN useradd shiny

WORKDIR /opt/app
USER shiny

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/opt/app')"]

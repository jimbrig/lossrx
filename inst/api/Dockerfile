FROM rocker/r-ver

# FROM rstudio/plumber

# sysreqs - pak::pkg_system_requirements("plumber", "ubuntu", "20.04")
RUN apt-get install -y libcurl4-openssl-dev \
  apt-get install -y libssl-dev \
  apt-get install -y libsodium-dev \
  apt-get install -y libicu-dev \
  apt-get install -y make \
  apt-get install -y zlib1g-dev

# R packages
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('jimbrig/lossrx')"

# Copy API
COPY plumber.R /

# Expose Port 80 to Traffic
EXPOSE 80

# Entrypoint
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=80)"]

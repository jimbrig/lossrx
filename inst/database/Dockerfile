FROM postgres:latest
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD admin
ENV POSTGRES_DB postgres
COPY ./db.sql /docker-entrypoint-initdb.d/
# COPY ./seed-db.sql /docker-entrypoint-initdb.d/
# ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]

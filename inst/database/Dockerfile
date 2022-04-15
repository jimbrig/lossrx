FROM postgres:latest

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB postgres

COPY ./SQL/* /docker-entrypoint-initdb.d/

EXPOSE 5432

CMD ["postgres"]

# ENTRYPOINT ["docker-entrypoint.sh"]

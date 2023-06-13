FROM python:3
WORKDIR /usr/src/app
MAINTAINER Arantxa Fernández Morató 'ara.fer.mor@gmail.com'
RUN apt-get install git && pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient
RUN git clone https://github.com/afermor8/django_tutorial.git /usr/src/app && mkdir static
ADD ./script.sh /usr/src/app/
RUN chmod +x /usr/src/app/script.sh
ENV ALLOWED_HOSTS=*
ENV DJANGO_HOST=mariadb
ENV DJANGO_USER=django
ENV DJANGO_PASSWORD=django
ENV DJANGO_DB=django
ENV DJANGO_SUPERUSER_PASSWORD=admin
ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_EMAIL=admin@example.org
ENTRYPOINT ["/usr/src/app/script.sh"]

FROM python:3
WORKDIR /usr/src/app
MAINTAINER Arantxa Fernández Morató 'ara.fer.mor@gmail.com'
RUN pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient 
COPY . /usr/src/app 
RUN mkdir static
ADD script.sh /usr/src/app/
RUN chmod +x /usr/src/app/script.sh
ENTRYPOINT ["/usr/src/app/script.sh"]

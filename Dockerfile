FROM ubuntu:14.04
LABEL MAINTAINER "Abdelrahman Hosny <abdelrahman.hosny@hotmail.com>"

# install python
RUN apt-get update && \
apt-get install -y python python-pip libgsl0ldbl && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV PYTHONUNBUFFERED 1

# add web app
RUN mkdir /easyscnvsim
WORKDIR /easyscnvsim
ADD requirements.txt /easyscnvsim/
RUN pip install -r requirements.txt

# add external software libraries
ADD easyscnvsim_lib /easyscnvsim_lib

ADD easyscnvsim /easyscnvsim/easyscnvsim
ADD webapp /easyscnvsim/webapp
ADD manage.py /easyscnvsim/manage.py

RUN python manage.py migrate

EXPOSE 8000
ENTRYPOINT ["python", "/easyscnvsim/manage.py", "runserver", "0.0.0.0:8000"]
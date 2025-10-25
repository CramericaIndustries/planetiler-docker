FROM openjdk:26-jdk-trixie

ARG PLANETILER_VERSION

WORKDIR /tmp

RUN apt-get clean && apt-get update -y && apt-get install -y wget

# change the download link to update to a newer version of planetiler
# version list @see: https://github.com/onthegomap/planetiler/tags
# RUN wget https://github.com/onthegomap/planetiler/releases/latest/download/planetiler.jar
RUN wget https://github.com/onthegomap/planetiler/releases/download/v${PLANETILER_VERSION}/planetiler.jar

COPY ./planetiler.sh /tmp/
RUN chmod 777 /tmp/planetiler.sh

CMD ["/tmp/planetiler.sh"]
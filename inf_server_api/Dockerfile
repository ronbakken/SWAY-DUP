FROM google/dart

RUN mkdir ~/.ssh
ADD ssh/. /root/.ssh
RUN chmod 600 ~/.ssh/*_deploy

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline

RUN rm -rf ~/.ssh
RUN rm -rf /app/ssh

CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/main.dart"]

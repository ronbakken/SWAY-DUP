FROM google/dart

RUN mkdir ~/.ssh
ADD ssh/. /root/.ssh
RUN chmod 600 ~/.ssh/*_deploy

WORKDIR /app

ADD scripts_linux/dart/pubspec.yaml /app/pubspec.yaml
RUN pub get
RUN rm /app/pubspec.yaml
RUN rm /app/pubspec.lock

ADD inf_server_api/pubspec.* /app/
RUN pub get
ADD inf_server_api/. /app
RUN pub get --offline

RUN mkdir assets
ADD assets/. /app/assets

RUN rm -rf ~/.ssh
RUN rm -rf /app/ssh

EXPOSE 8900
EXPOSE 8901
CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/main.dart"]

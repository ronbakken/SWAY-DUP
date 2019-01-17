FROM google/dart

RUN mkdir ~/.ssh
ADD ssh/. /root/.ssh
RUN chmod 600 ~/.ssh/*_deploy

WORKDIR /app

ADD inf_server_explore/pubspec.* /app/
RUN pub get
ADD inf_server_explore/. /app
RUN pub get --offline

RUN mkdir assets
ADD assets/. /app/assets

RUN rm -rf ~/.ssh
RUN rm -rf /app/ssh

EXPOSE 8930
EXPOSE 8939
CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/main.dart"]

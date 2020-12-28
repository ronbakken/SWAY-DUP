FROM google/dart

WORKDIR /app

RUN mkdir /sway_common
ADD scripts_linux/dart/pubspec.yaml /app/pubspec.yaml
ADD sway_common/pubspec.yaml /sway_common/pubspec.yaml
RUN pub get
RUN rm /app/pubspec.yaml
RUN rm /app/pubspec.lock

ADD sway_common/. /sway_common
ADD sway_server_explore/pubspec.* /app/
RUN pub get
ADD sway_server_explore/. /app
RUN pub get --offline

RUN mkdir assets
ADD sway_config/blob/. /app/assets

EXPOSE 8930
EXPOSE 8939
CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/main.dart"]

FROM google/dart

WORKDIR /app

RUN mkdir /sway_common
RUN mkdir /sway_config
RUN mkdir /sway_config/blob
ADD sway_server/pubspec.yaml /app/pubspec.yaml
ADD sway_common/pubspec.yaml /sway_common/pubspec.yaml
RUN pub get
RUN rm /app/pubspec.yaml
RUN rm /app/pubspec.lock

ADD sway_common/. /sway_common
ADD sway_dart_sql/. /sway_dart_sql
ADD sway_server_push/pubspec.* /app/
RUN pub get
ADD sway_server_push/. /app
RUN pub get --offline

ADD sway_config/blob/. /sway_config/blob

EXPOSE 8910
EXPOSE 8911
EXPOSE 8919
CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/main.dart"]

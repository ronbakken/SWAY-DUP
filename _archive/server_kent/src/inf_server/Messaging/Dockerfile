FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/Messaging.Interfaces
COPY Messaging.Interfaces .

WORKDIR /src/Users.Interfaces
COPY Users.Interfaces .

WORKDIR /src/Messaging
COPY Messaging/Messaging.csproj .

RUN dotnet restore "Messaging.csproj"
COPY Messaging .
RUN dotnet build "Messaging.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Messaging.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Messaging.dll"]
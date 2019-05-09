FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/API.Interfaces
COPY API.Interfaces .

WORKDIR /src/InvitationCodes.Interfaces
COPY InvitationCodes.Interfaces .

WORKDIR /src/Mapping.Interfaces
COPY Mapping.Interfaces .

WORKDIR /src/Messaging.Interfaces
COPY Messaging.Interfaces .

WORKDIR /src/Offers.Interfaces
COPY Offers.Interfaces .

WORKDIR /src/Users.Interfaces
COPY Users.Interfaces .

WORKDIR /src/API
COPY API/API.csproj .

RUN dotnet restore "API.csproj"
COPY API .
RUN dotnet build "API.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "API.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "API.dll"]
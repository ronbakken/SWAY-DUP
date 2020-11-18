FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/Mapping.Interfaces
COPY Mapping.Interfaces .

WORKDIR /src/Offers.Interfaces
COPY Offers.Interfaces .

WORKDIR /src/Users.Interfaces
COPY Users.Interfaces .

WORKDIR /src/Mapping
COPY Mapping/Mapping.csproj .

RUN dotnet restore "Mapping.csproj"
COPY Mapping .
RUN dotnet build "Mapping.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Mapping.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Mapping.dll"]
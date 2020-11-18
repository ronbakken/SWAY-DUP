FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/Users.Interfaces
COPY Users.Interfaces .

WORKDIR /src/Users
COPY Users/Users.csproj .

RUN dotnet restore "Users.csproj"
COPY Users .
RUN dotnet build "Users.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Users.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Users.dll"]
FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/Offers.Interfaces
COPY Offers.Interfaces .

WORKDIR /src/Offers
COPY Offers/Offers.csproj .

RUN dotnet restore "Offers.csproj"
COPY Offers .
RUN dotnet build "Offers.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Offers.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Offers.dll"]
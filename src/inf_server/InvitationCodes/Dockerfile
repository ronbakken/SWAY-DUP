FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /src
COPY Directory.Build.targets .

WORKDIR /src/Utility
COPY Utility .

WORKDIR /src/InvitationCodes.Interfaces
COPY InvitationCodes.Interfaces .

WORKDIR /src/InvitationCodes
COPY InvitationCodes/InvitationCodes.csproj .

RUN dotnet restore "InvitationCodes.csproj"
COPY InvitationCodes .
RUN dotnet build "InvitationCodes.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "InvitationCodes.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "InvitationCodes.dll"]
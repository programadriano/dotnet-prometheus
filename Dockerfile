#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["dotnet-prometheus/dotnet-prometheus.csproj", "dotnet-prometheus/"]
RUN dotnet restore "dotnet-prometheus/dotnet-prometheus.csproj"
COPY . .
WORKDIR "/src/dotnet-prometheus"
RUN dotnet build "dotnet-prometheus.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-prometheus.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-prometheus.dll"]
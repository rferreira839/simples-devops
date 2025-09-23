# ===== build =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copie apenas o csproj primeiro para otimizar cache de restore
COPY src/MinhaApi/MinhaApi.csproj src/MinhaApi/
RUN dotnet restore src/MinhaApi/MinhaApi.csproj

# agora copie o restante e publique
COPY . .
RUN dotnet publish src/MinhaApi/MinhaApi.csproj -c Release -o /app/publish /p:UseAppHost=false

# ===== runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "MinhaApi.dll"]

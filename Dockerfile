# STAGE 1 — build (usa o SDK do .NET, que tem o compilador)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia apenas o csproj primeiro para aproveitar cache de dependências
COPY src/MinhaApi/MinhaApi.csproj src/MinhaApi/
RUN dotnet restore src/MinhaApi/MinhaApi.csproj

# Agora copia o restante do código
COPY src/MinhaApi/ src/MinhaApi/

# Publica em Release para uma pasta limpa /app/publish
RUN dotnet publish src/MinhaApi/MinhaApi.csproj -c Release -o /app/publish /p:UseAppHost=false

# STAGE 2 — runtime (imagem menor, só para rodar)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copia os artefatos publicados do stage build
COPY --from=build /app/publish .

# Expõe a app na 8080 dentro do container
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Comando de inicialização
ENTRYPOINT ["dotnet", "MinhaApi.dll"]

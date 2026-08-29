FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src
COPY DotNetApp/App/App.csproj DotNetApp/App/
RUN dotnet restore DotNetApp/App/App.csproj
COPY DotNetApp/App/ DotNetApp/App/
WORKDIR /src/DotNetApp/App
RUN dotnet publish App.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS runner
WORKDIR /app
COPY --from=build /app/publish .
USER app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true
ENTRYPOINT ["dotnet", "App.dll"]
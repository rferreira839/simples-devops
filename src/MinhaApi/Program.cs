var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));
app.MapGet("/", () => Results.Ok(new { message = "Minha API .NET 8 – versão NOVA!" }));
//app.MapGet("/", () => Results.Ok(new { message = "Minha API .NET 8 rodando!" }));

app.Run();

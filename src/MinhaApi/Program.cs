using System.Diagnostics;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/", () => Results.Ok(new { message = "Minha API .NET 8 rodando! TESTE ok DE FLUXO1" }));

// Endpoint para simular carga de CPU por 'ms' milissegundos (padrão: 300ms)
app.MapGet("/cpu-burn", (int? ms) =>
{
    int duration = ms.GetValueOrDefault(300);
    var sw = Stopwatch.StartNew();

    // Loop ocupado até passar 'duration' ms
    while (sw.ElapsedMilliseconds < duration)
    {
        // Faz algumas operações para não ser otimizado
        _ = Math.Sqrt(12345.6789) * Math.Sqrt(98765.4321);
    }

    return Results.Ok(new { burnedMs = duration, now = DateTime.UtcNow });
});

app.Run();

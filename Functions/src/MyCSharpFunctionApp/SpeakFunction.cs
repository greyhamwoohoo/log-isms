using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace MyCSharpFunctionalApp
{
    public static class SpeakFunction
    {
        [FunctionName("SpeakFunction")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "speak/{word}")] HttpRequest req,
            string word,
            ILogger log)
        {
            log.LogInformation($"C# HTTP trigger function processed a request - {word}.");

            string responseMessage = $"Hello, {word}";

            return new OkObjectResult(responseMessage);
        }
    }
}

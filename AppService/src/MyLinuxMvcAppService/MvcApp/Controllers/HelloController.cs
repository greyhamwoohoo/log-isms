using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace MvcApp.Controllers
{
    public class HelloController : Controller
    {
        private readonly TelemetryClient _telemetry;

        public HelloController(TelemetryClient telemetry)
        {
            this._telemetry = telemetry;
        }

        public string Index()
        {
            _telemetry.TrackEvent("Spoken", new Dictionary<string, string>()
            {
                { "Word", "Hello" }
            });

            return "Hello";
        }
    }
}

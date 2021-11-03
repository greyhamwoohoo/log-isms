using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace MvcApp.Controllers
{
    public class HowdiController : Controller
    {
        private readonly TelemetryClient _telemetry;

        public HowdiController(TelemetryClient telemetry)
        {
            this._telemetry = telemetry;
        }

        public string Index()
        {
            _telemetry.TrackEvent("Spoken", new Dictionary<string, string>()
            {
                { "Word", "Howdi" }
            });

            return "Howdi";
        }
    }
}

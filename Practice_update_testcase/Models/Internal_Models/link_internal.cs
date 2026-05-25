using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Internal_Models
{
    public class link_internal
    {
        [JsonPropertyName("rel")]
        public string? rel { get; set; }

        [JsonPropertyName("href")]
        public string? href { get; set; }
    }
}

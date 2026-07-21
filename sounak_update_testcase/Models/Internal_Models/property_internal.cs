using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Internal_Models
{
    public class property_internal
    {
        [JsonPropertyName("field_id")]
        public long fieldid { get; set; }

        [JsonPropertyName("field_name")]
        public string? fieldname { get; set; }

        [JsonPropertyName("field_value")]
        public string? fieldvalue { get; set; }

        [JsonPropertyName("field_value_name")]
        public string? fieldvaluename { get; set; }
    }
}

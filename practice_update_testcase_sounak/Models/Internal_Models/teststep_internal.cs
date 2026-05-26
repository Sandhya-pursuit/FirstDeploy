using OpenTelemetry.Trace;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Internal_Models
{
    public class teststep_internal
    {
        [JsonPropertyName("customFieldInfo")]
        public List<customfiledinfo_internal> customfieldinfo { get; set; } = new();

        [JsonPropertyName("links")]
        public List<link_internal> links { get; set; } = new();

        [JsonPropertyName("id")]
        public long id { get; set; }

        [JsonPropertyName("description")]
        public string? description { get; set; }

        [JsonPropertyName("expected")]
        public string? expected { get; set; }

        [JsonPropertyName("order")]
        public int order { get; set; }

        [JsonPropertyName("attachments")]
        public List<object> attachments { get; set; } = new();

        [JsonPropertyName("group")]
        public int? group { get; set; }

        [JsonPropertyName("plain_value_text")]
        public string? plainvaluetext { get; set; }

        [JsonPropertyName("called_test_case")]
        public testcase_internal? calledtestcase { get; set; }
    }
}

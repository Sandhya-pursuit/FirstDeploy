using OpenTelemetry.Trace;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Internal_Models
{
    public class testcase_internal
    {
        [JsonPropertyName("links")]
        public List<link_internal> links { get; set; } = new();

        [JsonPropertyName("id")]
        public long id { get; set; }

        [JsonPropertyName("name")]
        public string? name { get; set; }

        [JsonPropertyName("order")]
        public int order { get; set; }

        [JsonPropertyName("pid")]
        public string? pid { get; set; }

        [JsonPropertyName("created_date")]
        public DateTimeOffset createddate { get; set; }

        [JsonPropertyName("last_modified_date")]
        public DateTimeOffset lastmodifieddate { get; set; }

        [JsonPropertyName("properties")]
        public List<property_internal> properties { get; set; } = new();

        [JsonPropertyName("web_url")]
        public string? weburl { get; set; }

        [JsonPropertyName("parent_id")]
        public long parentid { get; set; }

        [JsonPropertyName("test_case_version_id")]
        public long testcaseversionid { get; set; }

        [JsonPropertyName("version")]
        public string? version { get; set; }

        [JsonPropertyName("description")]
        public string? description { get; set; }

        [JsonPropertyName("precondition")]
        public string? precondition { get; set; }

        [JsonPropertyName("ai_generated")]
        public bool aigenerated { get; set; }

        [JsonPropertyName("ai_generated_source")]
        public string? aigeneratedsource { get; set; }

        [JsonPropertyName("creator_id")]
        public long creatorid { get; set; }

        [JsonPropertyName("agent_ids")]
        public List<long> agentids { get; set; } = new();

        [JsonPropertyName("test_steps")]
        public List<teststep_internal> teststeps { get; set; } = new();
    }
}

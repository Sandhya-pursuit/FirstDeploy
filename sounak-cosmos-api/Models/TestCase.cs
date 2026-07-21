using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace sounak_cosmos_api.Models
{
    public class TestCase
    {
        [JsonPropertyName("id")]
        public string? id { get; set; }

        [JsonPropertyName("links")]
        public List<Link> links { get; set; } = new();

        [JsonPropertyName("qtest_id")]
        public long qtest_id { get; set; }

        [JsonPropertyName("name")]
        public string? name { get; set; }

        [JsonPropertyName("order")]
        public int order { get; set; }

        [JsonPropertyName("qtest_pid")]
        public string? qtest_pid { get; set; }

        [JsonPropertyName("createddate")]
        public DateTimeOffset createddate { get; set; }

        [JsonPropertyName("lastmodifieddate")]
        public DateTimeOffset lastmodifieddate { get; set; }

        [JsonPropertyName("properties")]
        public List<Property> properties { get; set; } = new();

        [JsonPropertyName("weburl")]
        public string? weburl { get; set; }

        [JsonPropertyName("parentid")]
        public long parentid { get; set; }

        [JsonPropertyName("testcaseversionid")]
        public long testcaseversionid { get; set; }

        [JsonPropertyName("version")]
        public string? version { get; set; }

        [JsonPropertyName("description")]
        public string? description { get; set; }

        [JsonPropertyName("precondition")]
        public string? precondition { get; set; }

        [JsonPropertyName("aigenerated")]
        public bool aigenerated { get; set; }

        [JsonPropertyName("aigeneratedsource")]
        public string? aigeneratedsource { get; set; }

        [JsonPropertyName("creatorid")]
        public long creatorid { get; set; }

        [JsonPropertyName("agentids")]
        public List<long> agentids { get; set; } = new();

        [JsonPropertyName("teststeps")]
        public List<TestStep> teststeps { get; set; } = new();
    }
}

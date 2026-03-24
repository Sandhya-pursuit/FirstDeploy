using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace event_listner.Models
{
    public class TestCase
    {
        //This id specificly required for the cosmod db
        public string id { get; set; } = Guid.NewGuid().ToString();

        //testcase pid
        [JsonPropertyName("tc-pid")]
        public string? pid { get; set; } 

        //testcase id
        [JsonPropertyName("tc_id")]
        public string? tc_id { get; set; }

        //testcase name
        [JsonPropertyName("tc_name")]
        public string? tc_name { get; set; } 

        //testcase description
        [JsonPropertyName("tc_description")]
        public string? tc_description { get; set; } 

        //testcase precondition
        [JsonPropertyName("tc_precondition")]
        public string? tc_precondition { get; set; } 

        //testcase created date
        [JsonPropertyName("tc_created_date")]
        public string? tc_created_date { get; set; } 

        //testcase modified date
        [JsonPropertyName("tc_last_modified_date")]
        public string? tc_last_modified_date { get; set; }
    }
}

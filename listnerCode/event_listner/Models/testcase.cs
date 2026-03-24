using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace event_listner.Models
{
    public class testcase
    {
        //This id specificly required for the cosmod db
        public string id { get; set; } = Guid.NewGuid().ToString();

        //testcase pid
        [JsonPropertyName("pid")]
        public string? testcasepid { get; set; } 

        //testcase id
        [JsonPropertyName("id")]
        public string? testcaseid { get; set; }

        //testcase name
        [JsonPropertyName("name")]
        public string? testcaseName { get; set; } 

        //testcase description
        [JsonPropertyName("description")]
        public string? testcaseDescription { get; set; } 

        //testcase precondition
        [JsonPropertyName("precondition")]
        public string? testcasePrecondition { get; set; } 

        //testcase created date
        [JsonPropertyName("created_date")]
        public string? testcaseCreatedDate { get; set; } 

        //testcase modified date
        [JsonPropertyName("last_modified_date")]
        public string? testcaseModifieddate { get; set; }
    }
}

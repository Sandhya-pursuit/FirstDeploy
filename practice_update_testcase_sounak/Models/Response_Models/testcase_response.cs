using OpenTelemetry.Trace;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Response_Models
{
    public class testcase_response
    {
        public List<link_response> links { get; set; } = new();
        public long qtest_id { get; set; }
        public string? name { get; set; }
        public int order { get; set; }
        public string? qtest_pid { get; set; }
        public DateTimeOffset createddate { get; set; }
        public DateTimeOffset lastmodifieddate { get; set; }
        public List<property_response> properties { get; set; } = new();
        public string? weburl { get; set; }
        public long parentid { get; set; }
        public long testcaseversionid { get; set; }
        public string? version { get; set; }
        public string? description { get; set; }
        public string? precondition { get; set; }
        public bool aigenerated { get; set; }
        public string? aigeneratedsource { get; set; }
        public long creatorid { get; set; }
        public List<long> agentids { get; set; } = new();
        public List<teststep_response> teststeps { get; set; } = new();
    }
}

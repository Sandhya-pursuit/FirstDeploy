using OpenTelemetry.Trace;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Response_Models
{
    public class teststep_response
    {
        public List<customfiledinfo_response> customfieldinfo { get; set; } = new();
        public List<link_response> links { get; set; } = new();
        public long qtest_id { get; set; }
        public string? description { get; set; }
        public string? expected { get; set; }
        public int order { get; set; }
        public List<object> attachments { get; set; } = new();
        public int? group { get; set; }
        public string? plainvaluetext { get; set; }
        public testcase_response? calledtestcase { get; set; }
    }
}

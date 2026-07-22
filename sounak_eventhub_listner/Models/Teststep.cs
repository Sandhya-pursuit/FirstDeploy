using OpenTelemetry.Trace;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace sounak_eventhub_listner.Models
{
    public class Teststep
    {
        public List<Customfiledinfo> customfieldinfo { get; set; } = new();
        public List<Link> links { get; set; } = new();
        public long qtest_id { get; set; }
        public string? description { get; set; }
        public string? expected { get; set; }
        public int order { get; set; }
        public List<object> attachments { get; set; } = new();
        public int? group { get; set; }
        public string? plainvaluetext { get; set; }
        public Testcase? calledtestcase { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace sounak_eventhub_listner.Models
{
    public class Customfiledinfo
    {
        public long qtest_id { get; set; }
        public string? value { get; set; }
        public long objectid { get; set; }
        public string? type { get; set; }
        public string? name { get; set; }
        public string? striphtmlvalue { get; set; }
        public bool propertyeditorcomponent { get; set; }
    }
}

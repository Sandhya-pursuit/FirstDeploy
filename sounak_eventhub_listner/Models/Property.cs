using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace sounak_eventhub_listner.Models
{
    public class Property
    {
        public long fieldid { get; set; }
        public string? fieldname { get; set; }
        public string? fieldvalue { get; set; }
        public string? fieldvaluename { get; set; }
    }
}

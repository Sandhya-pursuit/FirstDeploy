using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Response_Models
{
    public class property_response
    {
        public long fieldid { get; set; }
        public string? fieldname { get; set; }
        public string? fieldvalue { get; set; }
        public string? fieldvaluename { get; set; }
    }
}

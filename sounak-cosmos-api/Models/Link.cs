using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace sounak_cosmos_api.Models
{
    public class Link
    {
        public string? rel { get; set; }
        public string? href { get; set; }
    }
}

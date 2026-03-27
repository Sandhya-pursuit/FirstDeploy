using System;
using System.Collections.Generic;
using System.Text;

namespace get_testcase.Models
{
    public class CustomFieldInfo
    {
        public int id { get; set; }
        public string? value { get; set; }
        public int objectId { get; set; }
        public string? type { get; set; }
        public string? name { get; set; }
        public string? stripHTMLValue { get; set; }
        public bool propertyEditorComponent { get; set; }
    }
}

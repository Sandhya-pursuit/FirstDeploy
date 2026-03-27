using System;
using System.Collections.Generic;
using System.Text;

namespace get_testcase.Models
{
    public class TestStep
    {
        public List<CustomFieldInfo>? customFieldInfo { get; set; }
        public List<Link>? links { get; set; }
        public int id { get; set; }
        public string? description { get; set; }
        public string? expected { get; set; }
        public int order { get; set; }
        public List<Attachment>? attachments { get; set; }
        public int group { get; set; }
        public string? plain_value_text { get; set; }
        public CalledTestCase? called_test_case { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace get_testcase.Models
{
    public class Attachment
    {
        public List<Link>? links { get; set; }
        public string? name { get; set; }
        public string? content_type { get; set; }
        public int id { get; set; }
        public string? web_url { get; set; }
        public string? created_date { get; set; }
        public Author? author { get; set; }
        public int artifact_id { get; set; }
    }
}

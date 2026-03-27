using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Text;

namespace get_testcase.Models
{
    public class TestCase
    {
        public List<Link>? links { get; set; }
        public int id { get; set; }
        public string? name { get; set; }
        public int order { get; set; }
        public string? pid { get; set; }
        public string? created_date { get; set; }
        public string? last_modified_date { get; set; }
        public List<Property>? properties { get; set; }
        public string? web_url { get; set; }
        public List<Attachment>? attachments { get; set; }
        public int parent_id { get; set; }
        public string? parent_name { get; set; }
        public int test_case_version_id { get; set; }
        public string? version { get; set; }
        public string? description { get; set; }
        public string? precondition { get; set; }
        public bool ai_generated { get; set; }
        public int creator_id { get; set; }
        public List<int>? agent_ids { get; set; }
        public List<TestStep>? test_steps { get; set; }
    }
}

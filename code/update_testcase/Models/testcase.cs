using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace update_testcase.Models
{
    public class TestCase
    {
        public string? tc_id { get; set; }
        public string? tc_name { get; set; }
        public string? tc_pid { get; set; }
        public string? tc_description { get; set; }
        public string? tc_precondition { get; set; }
        public string? tc_created_date { get; set; }
        public string? tc_last_modified_date { get; set; }
    }
}

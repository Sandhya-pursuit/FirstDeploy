using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace update_testcase.Models
{
    public class testcase
    {
        public int? Id { get; set; }
        public string? Name { get; set; }
        public string? Pid { get; set; }
        public string? CreatedDate { get; set; }
        public string? LastModifiedDate { get; set; }
        public string? Description { get; set; }
        public string? Precondition { get; set; }
    }
}

using Practice_update_testcase.Models.Internal_Models;
using Practice_update_testcase.Models.Response_Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace Practice_update_testcase.Mapper
{
    internal class link_mapper
    {
        public static link_response Map(link_internal source)
        {
            if (source == null) return null;

            return new link_response
            {
                rel = source.rel,
                href = source.href
            };
        }
    }
}

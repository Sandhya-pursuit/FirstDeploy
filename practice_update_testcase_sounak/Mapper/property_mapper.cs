using Practice_update_testcase.Models.Internal_Models;
using Practice_update_testcase.Models.Response_Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace Practice_update_testcase.Mapper
{
    internal class property_mapper
    {
        public static property_response Map(property_internal source)
        {
            if (source == null) return null;

            return new property_response
            {
                fieldid = source.fieldid,
                fieldname = source.fieldname,
                fieldvalue = source.fieldvalue,
                fieldvaluename = source.fieldvaluename
            };
        }
    }
}

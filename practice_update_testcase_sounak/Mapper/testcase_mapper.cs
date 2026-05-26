using Practice_update_testcase.Models.Internal_Models;
using Practice_update_testcase.Models.Response_Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace Practice_update_testcase.Mapper
{
    internal class testcase_mapper
    {
        public static testcase_response Map(testcase_internal source)
        {
            if (source == null) return null;

            return new testcase_response
            {
                qtest_id = source.id,
                qtest_pid = source.pid,
                name = source.name,
                description = source.description,
                order = source.order,
                version = source.version,

                properties = source.properties?
                    .Select(property_mapper.Map)
                    .ToList() ?? new(),

                links = source.links?
                    .Select(link_mapper.Map)
                    .ToList() ?? new(),

                teststeps = source.teststeps?
                    .Select(teststep_mapper.Map)
                    .ToList() ?? new()
            };
        }
    }
}

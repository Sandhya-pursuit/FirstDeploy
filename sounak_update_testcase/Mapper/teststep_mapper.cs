using Practice_update_testcase.Models.Internal_Models;
using Practice_update_testcase.Models.Response_Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace Practice_update_testcase.Mapper
{
    internal class teststep_mapper
    {
        public static teststep_response Map(teststep_internal source)
        {
            if (source == null) return null;

            return new teststep_response
            {
                qtest_id = source.id,
                description = source.description,
                expected = source.expected,
                order = source.order,
                group = source.group,
                attachments = source.attachments,
                plainvaluetext = source.plainvaluetext,

                customfieldinfo = source.customfieldinfo?
                    .Select(customfieldinfo_mapper.Map)
                    .ToList() ?? new(),

                links = source.links?
                    .Select(link_mapper.Map)
                    .ToList() ?? new(),

                calledtestcase = source.calledtestcase != null
                    ? testcase_mapper.Map(source.calledtestcase)
                    : null
            };
        }
    }
}

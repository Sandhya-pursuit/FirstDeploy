using Practice_update_testcase.Models.Internal_Models;
using Practice_update_testcase.Models.Response_Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace Practice_update_testcase.Mapper
{
    internal class customfieldinfo_mapper
    {
        public static customfiledinfo_response Map(customfiledinfo_internal source)
        {
            if (source == null) return null;

            return new customfiledinfo_response
            {
                qtest_id = source.id,
                value = source.value,
                objectid = source.objectid,
                type = source.type,
                name = source.name,
                striphtmlvalue = source.striphtmlvalue,
                propertyeditorcomponent = source.propertyeditorcomponent
            };
        }
    }
}

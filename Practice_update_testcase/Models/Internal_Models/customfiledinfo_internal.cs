using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Practice_update_testcase.Models.Internal_Models
{
    public class customfiledinfo_internal
    {
        [JsonPropertyName("id")]
        public long id { get; set; }

        [JsonPropertyName("value")]
        public string? value { get; set; }

        [JsonPropertyName("objectId")]
        public long objectid { get; set; }

        [JsonPropertyName("type")]
        public string? type { get; set; }

        [JsonPropertyName("name")]
        public string? name { get; set; }

        [JsonPropertyName("stripHTMLValue")]
        public string? striphtmlvalue { get; set; }

        [JsonPropertyName("propertyEditorComponent")]
        public bool propertyeditorcomponent { get; set; }
    }
}

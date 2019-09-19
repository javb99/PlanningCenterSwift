enum FolderJSON {
    static let full = _full
    static let minimumFields = _minimumFields
}

fileprivate let _minimumFields = """
{
    "type": "Folder",
    "id": "709999",
    "attributes": {
        "created_at": "2017-05-31T17:21:51Z",
    },
    "relationships": {
      "ancestors": {
        "data": []
      },
      "parent": null,
      "campus": {
        "data": {
          "type": "Campus",
          "id": "12328"
        }
      }
    },
    "links": {
      "folders": "https://api.planningcenteronline.com/services/v2/folders/709999/folders",
      "service_types": "https://api.planningcenteronline.com/services/v2/folders/709999/service_types",
      "self": "https://api.planningcenteronline.com/services/v2/folders/709999"
    }
}
"""

fileprivate let _full = """
{
    "type": "Folder",
    "id": "709999",
    "attributes": {
      "container": "VANCOUVER - Ministry Gatherings",
      "created_at": "2017-05-31T17:21:51Z",
      "name": "Vancouver - STUDENTS Ministry",
      "updated_at": "2018-09-05T23:52:37Z"
    },
    "relationships": {
      "ancestors": {
        "data": [
          {
            "type": "Folder",
            "id": "700011"
          },
          {
            "type": "Folder",
            "id": "601977"
          }
        ]
      },
      "parent": {
        "data": {
          "type": "Folder",
          "id": "700011"
        }
      },
      "campus": {
        "data": {
          "type": "Campus",
          "id": "12328"
        }
      }
    },
    "links": {
      "folders": "https://api.planningcenteronline.com/services/v2/folders/709999/folders",
      "service_types": "https://api.planningcenteronline.com/services/v2/folders/709999/service_types",
      "self": "https://api.planningcenteronline.com/services/v2/folders/709999"
    }
}
"""

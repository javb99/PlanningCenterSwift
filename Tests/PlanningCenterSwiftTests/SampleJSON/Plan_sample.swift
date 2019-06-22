
import PlanningCenterSwift

let planJsonSample = JsonSample<Plan>(live: """
{
    "type": "Plan",
    "id": "42189162",
    "attributes": {
        "created_at": "2019-05-13T19:44:38Z",
        "dates": "June 26, 2019",
        "files_expire_at": "2019-07-11T21:00:00Z",
        "items_count": 0,
        "last_time_at": "2019-06-26T19:00:00Z",
        "multi_day": false,
        "needed_positions_count": 12,
        "other_time_count": 2,
        "permissions": "Administrator",
        "plan_notes_count": 0,
        "plan_people_count": 45,
        "public": false,
        "rehearsal_time_count": 2,
        "series_title": "Goals (MS)/ Free People (HS)",
        "service_time_count": 1,
        "short_dates": "Jun 26",
        "sort_date": "2019-06-26T19:00:00Z",
        "title": "The goal is to live from approval, not for approval (MS)/ Free people live for Him, not them (HS)",
        "total_length": 0,
        "updated_at": "2019-06-21T00:22:22Z"
    },
    "relationships": {
        "service_type": {
            "data": {
                "type": "ServiceType",
                "id": "697416"
            }
        },
        "next_plan": {
            "data": {
                "type": "Plan",
                "id": "42189163"
            }
        },
        "previous_plan": {
            "data": {
                "type": "Plan",
                "id": "42189161"
            }
        },
        "attachment_types": {
            "data": [
            {
            "type": "AttachmentType",
            "id": "2488"
            },
            {
            "type": "AttachmentType",
            "id": "62945"
            },
            {
            "type": "AttachmentType",
            "id": "62939"
            }
            ]
        },
        "series": {
            "data": null
        },
        "created_by": {
            "data": {
                "type": "Person",
                "id": "25452054"
            }
        },
        "updated_by": {
            "data": {
                "type": "Person",
                "id": "25399631"
            }
        }
    },
    "links": {
        "self": "https://api.planningcenteronline.com/services/v2/service_types/697416/plans/42189162"
    }
}
"""
, spec: """
{
    "type": "Plan",
    "id": "1",
    "attributes": {
        "created_at": "2000-01-01T12:00:00Z",
        "title": "string",
        "updated_at": "2000-01-01T12:00:00Z",
        "public": true,
        "series_title": "string",
        "plan_notes_count": 1,
        "other_time_count": 1,
        "rehearsal_time_count": 1,
        "service_time_count": 1,
        "plan_people_count": 1,
        "needed_positions_count": 1,
        "items_count": 1,
        "total_length": 1,
        "multi_day": true,
        "files_expire_at": "2000-01-01T12:00:00Z",
        "sort_date": "2000-01-01T12:00:00Z",
        "last_time_at": "2000-01-01T12:00:00Z",
        "permissions": "string",
        "dates": "string",
        "short_dates": "string"
    },
    "relationships": {
        "service_type": {
            "data": {
                "type": "ServiceType",
                "id": "1"
            }
        },
        "next_plan": {
            "data": {
                "type": "Plan",
                "id": "1"
            }
        },
        "previous_plan": {
            "data": {
                "type": "Plan",
                "id": "1"
            }
        },
        "attachment_types": {
            "data": [
                {
                    "type": "AttachmentType",
                    "id": "1"
                }
            ]
        },
        "series": {
            "data": {
                "type": "Series",
                "id": "1"
            }
        },
        "created_by": {
            "data": {
                "type": "Person",
                "id": "1"
            }
        },
        "updated_by": {
            "data": {
                "type": "Person",
                "id": "1"
            }
        }
    }
}
"""
)

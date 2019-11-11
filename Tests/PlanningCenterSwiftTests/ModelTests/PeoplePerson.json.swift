//
//  Created by Joseph Van Boxtel on 11/11/19.
//

import Foundation

enum PeoplePersonJSON {
    static let sample = peoplePersonSample
}

fileprivate let peoplePersonSample = """
{
    "data": {
        "type": "Person",
        "id": "25452054",
        "attributes": {
            "accounting_administrator": false,
            "anniversary": null,
            "avatar": "https://avatars.planningcenteronline.com/uploads/person/25452054-1492054683/avatar.3.png",
            "birthdate": "1999-09-08",
            "child": false,
            "created_at": "2017-04-13T03:38:03Z",
            "demographic_avatar_url": "https://avatars.planningcenteronline.com/uploads/person/25452054-1492054683/avatar.3.png",
            "first_name": "Joseph",
            "gender": "M",
            "given_name": null,
            "grade": null,
            "graduation_year": null,
            "inactivated_at": null,
            "last_name": "Van Boxtel",
            "medical_notes": null,
            "membership": "Attendee",
            "middle_name": null,
            "name": "Joseph Van Boxtel",
            "nickname": "Joe",
            "passed_background_check": true,
            "people_permissions": "Editor",
            "remote_id": null,
            "school_type": null,
            "site_administrator": false,
            "status": "active",
            "updated_at": "2019-09-13T17:41:55Z"
        },
        "relationships": {
            "primary_campus": {
                "data": {
                    "type": "PrimaryCampus",
                    "id": "12328"
                }
            }
        },
        "links": {
            "": "https://api.planningcenteronline.com/people/v2/people/25452054/",
            "addresses": "https://api.planningcenteronline.com/people/v2/people/25452054/addresses",
            "apps": "https://api.planningcenteronline.com/people/v2/people/25452054/apps",
            "connected_people": "https://api.planningcenteronline.com/people/v2/people/25452054/connected_people",
            "emails": "https://api.planningcenteronline.com/people/v2/people/25452054/emails",
            "field_data": "https://api.planningcenteronline.com/people/v2/people/25452054/field_data",
            "household_memberships": "https://api.planningcenteronline.com/people/v2/people/25452054/household_memberships",
            "households": "https://api.planningcenteronline.com/people/v2/people/25452054/households",
            "inactive_reason": null,
            "marital_status": "https://api.planningcenteronline.com/people/v2/marital_statuses/30589",
            "message_groups": "https://api.planningcenteronline.com/people/v2/people/25452054/message_groups",
            "messages": "https://api.planningcenteronline.com/people/v2/people/25452054/messages",
            "name_prefix": null,
            "name_suffix": null,
            "notes": "https://api.planningcenteronline.com/people/v2/people/25452054/notes",
            "person_apps": "https://api.planningcenteronline.com/people/v2/people/25452054/person_apps",
            "phone_numbers": "https://api.planningcenteronline.com/people/v2/people/25452054/phone_numbers",
            "platform_notifications": "https://api.planningcenteronline.com/people/v2/people/25452054/platform_notifications",
            "primary_campus": "https://api.planningcenteronline.com/people/v2/campuses/12328",
            "school": null,
            "social_profiles": "https://api.planningcenteronline.com/people/v2/people/25452054/social_profiles",
            "workflow_cards": "https://api.planningcenteronline.com/people/v2/people/25452054/workflow_cards",
            "self": "https://api.planningcenteronline.com/people/v2/people/25452054"
        }
    },
    "included": [],
    "meta": {
        "can_include": [
            "addresses",
            "emails",
            "field_data",
            "households",
            "inactive_reason",
            "marital_status",
            "name_prefix",
            "name_suffix",
            "person_apps",
            "phone_numbers",
            "platform_notifications",
            "primary_campus",
            "school",
            "social_profiles"
        ],
        "parent": {
            "id": "26073",
            "type": "Organization"
        }
    }
}
"""

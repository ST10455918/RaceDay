| Method | Route | Description | Role | Request Body | Response |
|--------|-------|-------------|------|--------------|----------|
| POST | /api/auth/register | Register new user | None | {"name":"John","email":"john@raceday.com","password":"P@ssw0rd","role":"Participant"} | 201 Created with token / 400 email exists |
| POST | /api/auth/login | Login and get JWT | None | {"email":"john@raceday.com","password":"P@ssw0rd"} | 200 OK token / 401 Unauthorized |
| GET | /api/users/me | Get own profile | Any | None | 200 OK user object |
| PUT | /api/users/me | Update own profile | Any | {"name":"New Name"} | 200 OK updated |
| GET | /api/venues | List all venues | Any | None | 200 OK list |
| POST | /api/venues | Create venue | Organiser | {"name":"Sea Point","address":"Beach Rd","latitude":-33.9,"longitude":18.3,"routeMapUrl":"https://..."} | 201 Created / 403 Forbidden |
| GET | /api/events | List events | Any | Query ?date & venueId | 200 OK list |
| GET | /api/events/{id} | Get single event | Any | None | 200 OK with categories / 404 |
| POST | /api/events | Create event | Organiser | {"name":"Cape Town 10K","description":"Annual","eventDate":"2026-06-15","venueId":1} | 201 Created |
| PUT | /api/events/{id} | Update own event | Organiser owner | {"name":"Updated"} | 200 OK / 403 not owner |
| DELETE | /api/events/{id} | Delete event if no enrolments | Organiser owner | None | 204 No Content / 409 has enrolments |
| GET | /api/events/{eventId}/categories | List categories for event | Any | None | 200 OK |
| POST | /api/events/{eventId}/categories | Add category to event | Organiser owner | {"name":"10km","distance":10,"entryFee":150,"maxCapacity":500} | 201 Created |
| PUT | /api/categories/{id} | Update category | Organiser owner | {"distance":21.1,"entryFee":200} | 200 OK / 409 capacity exceeded |
| DELETE | /api/categories/{id} | Delete category | Organiser owner | None | 204 / 409 has enrolments |
| GET | /api/enrolments | Get enrolments (own if participant, all own events if organiser) | Any | None | 200 OK |
| POST | /api/enrolments | Enrol in category | Participant | {"eventId":1,"categoryId":2} | 201 Created / 409 Already enrolled / 409 Full |
| DELETE | /api/enrolments/{id} | Cancel enrolment | Owner/Organiser | None | 200 Cancelled |
| GET | /api/events/{eventId}/enrolments | List participants for event | Organiser owner | None | 200 OK |
| GET | /api/results | List results | Any | ?eventId=1 | 200 OK |
| GET | /api/results/{id} | Get single result | Any | None | 200 OK / 404 |
| POST | /api/results | Create result | Organiser owner | {"enrolmentId":5,"finishTime":"01:02:15","position":1} | 201 Created / 409 exists |
| PUT | /api/results/{id} | Update result | Organiser owner | {"finishTime":"01:
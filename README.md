## Part 2 - RaceDay API - ST10455918

Branch: part-2
Commits: 21 (20 + 1 fix)
CI/CD: GitHub Actions Build-and-Test - PASSING (green)

Implemented:
- 6 Tables: User, Venue, Event, Category, Enrolment, Result (Code-First)
- Auth: Register (Organiser/Participant), Login with Session, BCrypt hashing
- Role-based: Organiser can CRUD Events, Participant can view + enrol
- Session check: HttpContext.Session.GetInt32("UserId")
- Swagger: /swagger tested
- Unit Tests: 8 tests (Auth success/fail, role rejection, enrolment)
- .NET 8.0, EF Core InMemory for demo, BCrypt.Net-Next

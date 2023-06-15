## Authorization

A RBAC is implemented, limiting the acess to the API to only authorized users.
The following roles are available:

- `Admin`
- `Moderator`
- `User`

The `Admin` role is the highest role, an `Admin` user is created by default when the API is deployed.
Having the following login:

- Email: admin@gmail.com
- Password: Admin123.

These credentials can then be changed in the web interface or through API requests.

The `Admin` user can then create new users, and assign them its role.

The following table shows the access to the resources for each role:

| Resource         | Action | Admin | Moderator | User |
| ---------------- | ------ | ----- | ----- | ---- |
| User             | Create | ✓     | ✓     | X    |
| User             | Read   | ✓     | ✓     | ✓    |
| User             | Update | ✓     | ✓     | ✓    |
| User             | Delete | ✓     | X     | X     |
| Device           | Create | ✓     | ✓     | X    |
| Device           | Read   | ✓     | ✓     | ✓    |
| Device           | Update | ✓     | ✓     | X    |
| Device           | Delete | ✓     | X     | X    |
| Device Group     | Create | ✓     | ✓     | X    |
| Device Group     | Read   | ✓     | ✓     | ✓    |
| Device Group     | Update | ✓     | ✓     | X    |
| Device Group     | Delete | ✓     | X     | X    |
| Processed Stream | Read   | ✓     | ✓     | ✓    |
| Role             | Update | ✓     | X     | X    |

## Authentication

The API uses Cookie based authentication, which means that the user maintains a session with the API, and the API uses the session to identify the user.
The session is created when the user logs in either by registering or using the login endpoint, and is destroyed when the user logs out.
A user can only have one session at a time, which means that if the user logs in again, the previous session is destroyed.

A Cookie based authentication is used because it can prevent [XSS](<https://developer.mozilla.org/en-US/docs/Web/Security/Types_of_attacks#cross-site_scripting_(xss)>) attacks this is done by setting the `HttpOnly` flag to the cookie, the cookie can only be accessed by the API, and not by malicious scripts.
It also prevents [CSRF](<https://developer.mozilla.org/en-US/docs/Web/Security/Types_of_attacks#cross-site_request_forgery_(csrf)>) attacks, this is done by setting the `SameSite` flag to the cookie, the cookie can only be sent by the API, and not by malicious scripts.

##### Login

The login is done by making a `POST` request to the [login endpoint](/api/user/general#post-userslogin).
After the login is successful, the API will return a cookie with the session, and the user can then make requests to the API.

##### Logout

The logout is done by making a `POST` request to the [logout endpoint](/api/user/general#post-userslogout).
This will destroy the session, and the user will have to login again to make requests to the API.

##### Register

In Sensiflow, a user can be registered by an `Admin` or a `Moderator` user.
Send a `POST` request to the [register endpoint](/api/user/general#post-users).

*[RBAC]: Role Based Access Control

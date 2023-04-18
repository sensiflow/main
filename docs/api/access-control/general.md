
## Authorization

A role based access control is implemented, limiting the acess to the API to only authorized users.
The following roles are available:

- Owner
- Admin
- User

The Owner role is the highest role, an Owner user is by default created when the API is deployed.
Having the following login:

- Email: admin@gmail.com
- Password: Admin123.

The Owner user can then create new users, and assign them its role.

The following table shows the access to the resources for each role:

| Resource | Action | Owner | Admin | User |
|----------|--------|-------|-------|------|
| User | Create | ✓ | ✓ | X |
| User | Read | ✓ | ✓ | ✓ |
| User | Update | ✓ | ✓ | ✓ |
| Device | Create | ✓ | ✓ | X |
| Device | Read | ✓ | ✓ | ✓ |
| Device | Update | ✓ | ✓ | X |
| Device | Delete | ✓ | X | X |
| Device Group | Create | ✓ | ✓ | X |
| Device Group | Read | ✓ | ✓ | ✓ |
| Device Group | Update | ✓ | ✓ | X |
| Device Group | Delete | ✓ | X | X |
| Processed Stream | Read | ✓ | ✓ | ✓ |
| Role | Update | ✓ | X | X |





## Authentication

The API uses Cookie based authentication, which means that the user maintains a session with the API, and the API uses the session to identify the user.
The session is created when the user logs in either by registering or using the login endpoint, and is destroyed when the user logs out.
A user can only have one session at a time, which means that if the user logs in again, the previous session is destroyed.

A Cookie based authentication is used because it can prevent [XSS](https://developer.mozilla.org/en-US/docs/Web/Security/Types_of_attacks#cross-site_scripting_(xss)) attacks this is done by setting the `HttpOnly` flag to the cookie, the cookie can only be accessed by the API, and not by malicious scripts.
It also prevents [CSRF](https://developer.mozilla.org/en-US/docs/Web/Security/Types_of_attacks#cross-site_request_forgery_(csrf)) attacks, this is done by setting the `SameSite` flag to the cookie, the cookie can only be sent by the API, and not by malicious scripts.

The login is done by making a `POST` request to the login endpoint, with the [respective body](/api/user/general#post-userslogin).
After the login is successful, the API will return a cookie with the session, and the user can then make requests to the API.

The logout is done by making a `POST` request to the logout endpoint, with the [respective body](/api/user/general#post-userslogout).
This will destroy the session, and the user will have to login again to make requests to the API.

To register a new user, the user must be logged in, and have enough permissions to create a new user.
The user can then make a `POST` request to the register endpoint, with the [respective body](/api/user/general#post-users).

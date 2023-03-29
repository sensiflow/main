

## POST `/users`

Registers a new user.
On success, a cookie will be sent with the user's token.
### Request Body


| Parameter | Type | Description | required |  min length |  max length |
| --- | --- | --- | --- | --- | --- |
| email | string | user's email address | yes | 3 |100 |
| firstName | string | user's first name | yes | 3 | 20 |
| lastName | string | user's last name | yes | 3 |20 |
| password | string | Password requires at least 1 special character, 1 uppercase and lower case character | yes | 3 | 20 |

### Response

* `201 Created` on success

```json
POST /users/
Content-Type: application/json

{
  "id": 1
}

```

* `400 Bad Request` if the request body is invalid


## POST `/users/login`

Logs in an existing user.
Upon success, a cookie will be sent with the user's token.


### Request Body


| Parameter | Type | Description | required |  min length |  max length |
| --- | --- | --- | --- | --- | --- |
| email | string | user's email address | yes | 3 | 100 |
| password | string | Password requires at least 1 special character, 1 uppercase and lower case character| yes | 3 | 20 |

### Response

* `200 OK` on success
  
```json
POST /users/login
Content-Type: application/json
{
  "id": 1
}

```
* `400 Bad Request` if the request body is invalid


## POST `/users/logout`

Logs out the current user.
The user's token will be invalidated.

### Request Body

* none


### Response
* `200 OK` on success

## GET `/users/{userID}`

Gets the user with the specified ID.

### Response
* `200 OK` on success
* `404 Not Found` if the user does not exist

```json

GET /users/1
Content-Type: application/json

{
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe"
}

```
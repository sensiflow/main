

## POST `/users`

Registers a new user.
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

## GET `/users`

Gets all users.

Supports [**Pagination**](/api/reference#pagination)

### Response
* `200 OK` on success

```json

GET /users
Content-Type: application/json

{
  "totalPages": 2,
  "totalElements": 10,
  "isLast": true,
  "isFirt": true,
  "items": [
    {
      "id" : 1,
      "email": "test@email.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "Admin"
    },
    {
      "id" : 2,
      "email": "test1@gmail.com",
      "firstName": "Jane",
      "lastName": "Doe",
      "role": "User"
    }
  ]
}
```

## PUT `/users/{userID}`

Updates the user with the specified ID.
If the the user that is updating the `userID` is not the same as the one being updated, the user must be an `Admin` or a `Moderator`.
The role hierarchy is respected, this means that an `Admin` can update any user, a `Moderator` can update any user except an `Admin`, and a `User` can only update itself. 

### Request Body

| Parameter | Type | Description | required |  min length |  max length |
| --- | --- | --- | --- | --- | --- |
| firstName | string | user's first name | no | 3 | 20 |
| lastName | string | user's last name | no | 3 | 20 |
| password | string | Password requires at least 1 special character, 1 uppercase and lower case character | no | 3 | 20 |
| -- | -- | -- | -- | -- | -- |

### Response

* `204 No content` on success
* `404 Not Found` if the user does not exist	
* `400 Bad Request` if the request body is invalid
* `403 Forbidden` if the user does not have permission to update the user information

```json

PUT /users/1
Content-Type: application/json

{
  "firstName": "Jane",
  "lastName": "Doe",
  "password": "Password123."
}

```


## DELETE `/users/{userID}`
Deletes the user with the specified ID.

### Response

* `204 No content` on success
* `404 Not Found` if the user does not exist
* `403 Forbidden` if the user does not have permission to delete the user

```json

DELETE /users/1
Content-Type: application/json

```

## PUT `/users/{userID}/role`

Updates the user's role with the specified ID.
Check the [Access Control](/api/access-control/general) section for more information about the roles.

### Request Body

| Parameter | Type | Description | required |  min length |  max length |
| --- | --- | --- | --- | --- | --- |
| role | string | user's role | yes | 3 | 20 |

### Response

* `204 No content` on success
* `404 Not Found` if the user does not exist
* `400 Bad Request` if the request body is invalid
* `403 Forbidden` if the user does not have permission to update the user's role



## GET `/groups/{id}`

Returns a device group with a given ID.

### Response

- `200 OK` - success
- `404 Not Found` if device group with the given ID doesn't exist

```json

GET /groups/1
Content-Type: application/json

{
  "id": 1,
  "name": "Group 1",
  "description": "This is the first group",
}

```

## POST `/groups`

Creates a new device group.
Allows adding devices to the group, if the device's IDs are provided on the query.
If a given device ID doesn't exist, it will cause a rollback and the group won't be created.

### Query Parameters

| Parameter   | Type   | Description| required |
|-------------|--------|------------| -------- |
| devices     | array  | device's ids| no      |


### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | yes | 20 |
| description | string | device's description  | no | 100 |

### Response

- `201 Created` on success
- `400 Bad Request` if the request body is invalid
- `404 Not Found` if a device ID received on the query doesn't exist 

```json
POST /groups?devices=1,2
Content-Type: application/json

{
  "name": "Group 1",
  "description": "This is the first group",
}

```


## PUT `/groups/{id}`

Updates an existing device group with a given ID.

### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | no | 20 |
| description | string | device's description  | no | 100 |

Response

- `204 No Content` on success

- `400 Bad Request` if the request body is invalid

```json

PUT /groups/1
Content-Type: application/problem+json

{
    "type": "https://datatracker.ietf.org/doc/html/rfc7231#section-6.5.1",
    "title": "The provided data is invalid",
    "status": 400,
    "detail": "name must not be blank",
    "instance": "/api/v1"
}
```

- `404 Not Found` if device group with the given ID doesn't exist

```json

PUT /groups/1
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1"
}
```

## DELETE `/groups/{id}`

Deletes a device group with a given ID.

Response

- `204 No Content` on success

- `404 Not Found` if device group with the given ID doesn't exist

```json

DELETE /groups/1
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1"
}
```

## PUT `/groups/{id}/devices`
Updates the list of devices of a group.

### Request Body

| Parameter   | Type   | Description| required 
|-------------|--------|------------| -------- 
| deviceIDs        | array | device's ids | yes | 

!!! info "Addition and deletion of devices in a group"
    This is the endpoint you should use to add or delete devices in a group. The devices that will remain in the group are the ones specified in the deviceIDs array present in the request body. 
    
    If you want to clear all the devices from the group, you **must** provide an empty array in the request body for the effect.
    


Response

- `204 No Content` on success
- `400 Bad Request` if the request body is invalid

```json

PUT /groups/1/devices
Content-Type: application/problem+json

{
    "type": "about:blank",
    "title": "Bad Request",
    "status": 400,
    "detail": "Failed to read request",
    "instance": "/api/v1/groups/1/devices"
}

- `404 Not Found` if device group with the given ID doesn't exist

```json

PUT /groups/1/devices
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1/devices"
}
```

## GET `/groups/{id}/devices`

Returns a list of devices.

Supports [**Pagination**](/api/reference#pagination)

### Response

- `200 OK` - success

```json

GET /groups/1/devices?page=1&size=2
Content-Type: application/json

{
  "totalPages": 2,
  "totalElements": 10,
  "items": [
    {
      "id": 1,
      "name": "Device 1",
      "description": "This is the first device",
      "streamURL": "rtsp://my-stream:5412/1",
    },
    {
      "id": 2,
      "name": "Device 2",
      "description": "This is the second device",
      "streamURL": "rtsp://my-stream:5412/2",
    }
  ]
}
```

-  `404 Not Found` if device group with the given ID doesn't exist

```json

GET /groups/1/devices?page=1&size=2
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1/devices"
}
```
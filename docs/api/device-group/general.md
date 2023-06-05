## GET `/groups/{id}`

Returns a device group with a given ID. Supports [**Expansion**](/api/reference#expanding-responses). When it is expanded, the group's devices will be paginated with the default [**Pagination**](/api/reference#pagination). 

### Response

- `200 OK` - success

```json

GET /groups/1?expand=false
Content-Type: application/json

{
  "id": 1,
  "name": "Group 1",
  "description": "This is the first group",
}

```

```json

GET /groups/1?expanded=true
Content-Type: application/json

{
  "id": 1,
  "name": "Group 1",
  "description": "This is the first group",
  "devices": {
    "totalElements": 1,
    "totalPages": 1,
    "isLast": true,
    "isFirst": true,
    "items": [
      {
        "id": 1,
        "name": "Device 1",
        "description": "This is device 1",
        "streamURL": "rtsp://my-stream:5412/1",
        "processingState": "ACTIVE",
        "userID": 0,
        "deviceGroupsID": [1]
      }
    ]
  }
}

```

- `404 Not Found` if device group with the given ID doesn't exist

```json

GET /groups/1
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1",
    "properties": null
}

```

## GET `/groups`

Returns all device groups. Supports [**Expansion**](/api/reference#expanding-responses) and [**Pagination**](/api/reference#pagination). Since the requested pagination is applied to the returned groups, if it is expanded, the group's devices will be paginated with the default [**Pagination**](/api/reference#pagination) and not with the requested one.

### Response

- `200 OK` - success

```json

GET /groups?page=1&size=2&expanded=false
Content-Type: application/json

{
    "totalElements": 1,
    "totalPages": 1,
    "isLast": true,
    "isFirst": true,
    "items": [
        {
            "id": 1,
            "name": "Group 1",
            "description": "Group 1 description"
        }
    ]
}

```

```json

GET /groups?page=1&size=2&expanded=true
Content-Type: application/json

{
    "totalElements": 1,
    "totalPages": 1,
    "isLast": true,
    "isFirst": true,
    "items": [
        {
            "id": 1,
            "name": "Group 1",
            "description": "Group 1 description",
            "devices": {
                "totalElements": 1,
                "totalPages": 1,
                "isLast": true,
                "isFirst": true,
                "items": [
                  {
                    "id": 1,
                    "name": "Device 1",
                    "description": "This is device 1",
                    "streamURL": "rtsp://my-stream:5412/1",
                    "processingState": "ACTIVE",
                    "userID": 0,
                    "deviceGroupsID": [1]
                  }
                ]
            }
        }
    ]
}
```


## POST `/groups`

Creates a new device group.
Allows to add devices to the group.

!!! warning "Adding devices to a group on creation"
    If you want to add devices to a group on creation, you must provide the device's IDs on the query. The devices will be added to the group after the group is created. If a given device ID doesn't exist, it will cause a rollback and the group won't be created.

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

```json
POST /groups?devices=1,2
Content-Type: application/json

{
    "id": 93
}

```

- `400 Bad Request` if the request body is invalid

```json
POST /groups?devices=1,2
Content-Type: application/json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#invalid-json-structure",
    "title": "The provided JSON body has an invalid structure",
    "status": 400,
    "detail": "JSON parse error",
    "instance": "/api/v1",
    "properties": null
}

```

- `404 Not Found` if a device ID received on the query doesn't exist 

```json
POST /groups?devices=1
Content-Type: application/json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/groups",
    "properties": null
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
    "instance": "/api/v1",
    "properties": null
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
    "instance": "/api/v1/groups/1",
    "properties": null
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
    "instance": "/api/v1/groups/1",
    "properties": null
}
```

## POST `/groups/{id}/devices`
Adds devices to the list of devices of a group.

### Request Body

| Parameter   | Type   | Description| required 
|-------------|--------|------------| -------- 
| deviceIDs        | array | device's ids | yes | 

!!! info "Addition of devices to a group"
    This is the endpoint you should use to add devices in a group. The devices that are added in the group must be ones that were not added yet. On adding a device that is already in the group, it will rollback and not add any of the requested devices. 

Response

- `201 Created` on success

```json

POST /groups/1/devices
Content-Type: application/problem+json

{
    "message": "Devices added to group successfully"
}
```

- `400 Bad Request` if the request body is invalid

```json

POST /groups/1/devices
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#invalid-json-structure",
    "title": "The provided JSON body has an invalid structure",
    "status": 400,
    "detail": "JSON parse error",
    "instance": "/api/v1",
    "properties": null
}
```

- `404 Not Found` if device group with the given ID doesn't exist

```json

POST /groups/1/devices
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1/devices",
    "properties": null
}
```

## DELETE `/groups/{id}/devices`
Deletes devices from the list of devices of a group.

### Query Parameters

| Parameter   | Type   | Description| required |
|-------------|--------|------------| -------- |
| deviceIDs    | array  | device's ids| yes      |

!!! info "Deletion of devices of a group"
    This is the endpoint you should use to delete devices of a group. On deleting a device that does not exist, it will rollback and not delete any of the requested devices. 

Response

- `204 No Content` on success
- `400 Bad Request` if the request body is invalid

```json

DELETE /groups/1/devices?invalid=1
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#required-uri-parameter-missing",
    "title": "A required parameter is missing",
    "status": 400,
    "detail": "Required request parameter 'deviceIDs' for method parameter type List is not present",
    "instance": "/api/v1",
    "properties": null
}
```

- `404 Not Found` if device group with the given ID doesn't exist

```json

DELETE /groups/1/devices?deviceIDs=1,2
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#device-group-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device group with id 1 not found",
    "instance": "/api/v1/groups/1/devices",
    "properties": null
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
        "description": "This is device 1",
        "streamURL": "rtsp://my-stream:5412/1",
        "processingState": "ACTIVE",
        "userID": 0,
        "deviceGroupsID": [1]
      },
      {
        "id": 1,
        "name": "Device 2",
        "description": "This is device 2",
        "streamURL": "rtsp://my-stream:5412/2",
        "processingState": "ACTIVE",
        "userID": 0,
        "deviceGroupsID": [1]
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
    "instance": "/api/v1/groups/1/devices",
    "properties": null
}
```
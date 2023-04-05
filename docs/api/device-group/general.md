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
- `404 Not Found` if device group with the given ID doesn't exist

## DELETE `/groups/{id}`

Deletes a device group with a given ID.

Response

- `204 No Content` on success
- `404 Not Found` if device group with the given ID doesn't exist

## PUT `/groups/{id}/devices`
Updates the list of devices of a group.

### Request Body

| Parameter   | Type   | Description| required 
|-------------|--------|------------| -------- 
| devicesIDs        | array | device's ids | yes | 

!!! info "Addition and deletion of devices in a group"
    This is the endpoint you should use to add or delete devices in a group. The devices that will remain in the group are the ones specified in the devicesIDs array present in the request body. 
    
    If you want to clear all the devices from the group, you **must** provide an empty array in the request body for the effect.
    


Response

- `204 No Content` on success
- `400 Bad Request` if the request body is invalid
- `404 Not Found` if device group with the given ID doesn't exist

## GET `/groups/{id}/devices`

Returns a list of devices.

Supports [**Pagination**](/api/reference#pagination)

### Response

- `200 OK` - success
-  `404 Not Found` if device group with the given ID doesn't exist

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
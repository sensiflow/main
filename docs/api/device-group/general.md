## PUT `groups/{id}`

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

## DELETE `groups/{id}`

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
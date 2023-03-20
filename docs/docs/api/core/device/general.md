## GET `/devices`

Returns a list of devices.

Supports [**Pagination**](/api/reference#pagination)

### Response

- `200 OK` - success

```json

GET /devices?page=1&size=2
Content-Type: application/json

{
  "totalPages": 2,
  "totalElements": 10,
  "items": [
    {
      "id": 1,
      "name": "Device 1",
      "description": "This is device 1",
      "stream": "rtsp://my-stream:5412/1",
      "status": "ONLINE"
    },
    {
      "id": 2,
      "name": "Device 2",
      "description": "This is device 2",
      "stream": "rtsp://my-stream:5412/2",
      "status": "OFFLINE"
    }
  ]
}
```

## Get `/devices/{id}`

Returns a device with a given ID.

### Response

- `200 OK` - success
- `404 Not Found` if device with the given ID doesn't exist

```json

GET /devices/1
Content-Type: application/json

{
  "id": 1,
  "name": "Device 1",
  "description": "This is device 1",
  "stream": "rtsp://my-stream:5412/1",
  "status": "PAUSED"
},
```

## POST `/devices`

Creates a new device.


### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | yes | 20 |
| description | string | device's description  | no | 100 |
| streamUrl    | string | _RTSP_ Url where the device's feed is being transmitted  | yes | 200 |

### Response

- `201 Created on success`
- `400 Bad Request if the request body is invalid`

```json

{
  "id": 3,
  "name": "Device 3",
  "description": "This is the third device",
  "stream": "rtsp://my-stream:5412/3",
  "status": "OFFLINE",
}
```

## PUT `/devices/{id}`

Updates an existing device with a given ID.


### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | no | 20 |
| description | string | device's description  | no | 100 |
| streamUrl    | string | _RTSP_ Url where the device's feed is being transmitted  | no | 200 |

Response

- 204 No Content on success
- 400 Bad Request if the request body is invalid
- 404 Not Found if device with the given ID doesn't exist

## DELETE `/devices/{id}`

Deletes a device with a given ID.

Response

- 204 No Content on success
- 404 Not Found if device with the given ID doesn't exist
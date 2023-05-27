# Device API

In the context of Sensiflow's api, a "device" likely refers to a physical or virtual entity that captures and transmits a feed to be processed by our system. Devices could be physical cameras, such as surveillance cameras, IP cameras, or other types of cameras, that are connected to the system and send image or video data. Devices could also be virtual cameras, such as simulated camera feeds or virtual streams generated for testing or development purposes.

The devices are responsible for capturing camera feeds and transmitting them to the system for processing, typically through network protocols such as RTSP (Real-Time Streaming Protocol) or other appropriate methods.

The system manages multiple devices, handling their camera feeds simultaneously in real-time, and processing them using the image processor and other components of the system. The system may also handle device registration and processing management for the devices such as starting, pausing, or stopping the processing of a device's feed.

## GET `/devices`

Returns a list of devices.

Supports [**Pagination**](/api/reference#pagination) and [**Expansion**](/api/reference#expanding-responses)

### Response

- `200 OK` - success

```json title="Response body example"

GET /devices?page=1&size=2
Content-Type: application/json

{
  "totalPages": 1,
  "totalElements": 2,
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
      "deviceGroupsID": []
    },
    {
      "id": 2,
      "name": "Device 2",
      "description": "This is device 2",
      "streamURL": "rtsp://my-stream:5412/2",
      "processingState": "INACTIVE",
      "userID": 0,
      "deviceGroupsID": []
    }
  ]
}
```

## Get `/devices/{id}`

Returns a device with a given ID.

Supports [**Expansion**](/api/reference#expanding-responses)

### Response

- `200 OK` - success

```json

GET /devices/1
Content-Type: application/json

{
  "id": 1,
  "name": "Device 1",
  "description": "This is device 1",
  "streamURL": "rtsp://my-stream:5412/1",
  "processingState": "PAUSED",
  "userID": 1,
  "deviceGroupsID": []
},
```

- `404 Not Found` if device with the given ID doesn't exist

```json

GET /devices/1
Content-Type: application/problem+json

{
    "type": "https://sensiflow.github.io/main/api/errors/general/#device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/devices/1",
    "properties": null
}

```

## POST `/devices`

Creates a new device.

### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | yes | 20 |
| description | string | device's description  | no | 100 |
| streamURL    | string | _RTSP_ Url where the device's feed is being transmitted  | yes | 200 |


### Response

- `201 Created on success`

```json

POST /devices
Content-Type: application/json

{
  "id": 3
}
```

- `400 Bad Request if the request body is invalid`

```json

POST /devices
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

## PUT `/devices/{id}`

Updates an existing device details with a given ID.

### Request Body

| Parameter   | Type   | Description| required | max length |
|-------------|--------|------------| -------- | ---------- |
| name        | string | device's name | no | 20 |
| description | string | device's description  | no | 100 |
| streamURL    | string | _RTSP_ Url where the device's feed is being transmitted  | no | 200 |

!!! warning

    If a device is currently being processed, updating a device's streamUrl will cause the processing of the device's feed to be stopped.

Response

- 204 No Content on success
- 400 Bad Request if the request body is invalid

```json

PUT /devices/1
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

- 404 Not Found if device with the given ID doesn't exist

```json

PUT /devices/1
Content-Type: application/problem+json

{
  "type": "https://sensiflow.github.io/main/api/errors/general/#device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/devices/1",
    "properties": null
}
```

## DELETE `/devices/{id}`

Deletes a device with a given ID.

Response

- 204 No Content on success
- 404 Not Found if device with the given ID doesn't exist

```json

DELETE /devices/1
Content-Type: application/problem+json

{
  "type": "https://sensiflow.github.io/main/api/errors/general/#device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/devices/1",
    "properties": null
}
```

## GET `/devices/{id}/stats`

Returns the statistics of a device with a given ID.

Supports [**Pagination**](/api/reference#pagination)

### Response

- `200 OK` - success

```json

GET /devices/1/stats?page=1&size=2
Content-Type: application/json

{
  "totalPages": 2,
  "totalElements": 10,
  "isLast": true,
  "isFirt": true,
  "items": [
    {
      "deviceID": 1,
      "startTime": 1564086180000
      "endTime": 1564086300000
      "peopleCount": 25
    },
    {
      "deviceID": 1,
      "startTime": 1564086180000
      "endTime": 1564086300000
      "peopleCount": 30
    }
  ]
}
```

- `404 Not Found` if device with the given ID doesn't exist


```json

GET /devices/1/stats?page=1&size=2
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/devices/1/stats",
    "properties": null
}

```
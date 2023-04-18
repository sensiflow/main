In the context of your application, a "device" likely refers to a physical or virtual entity that captures and transmits camera feeds to be processed by the system. Devices could be physical cameras, such as surveillance cameras, IP cameras, or other types of cameras, that are connected to the system and send image or video data. Devices could also be virtual cameras, such as simulated camera feeds or virtual streams generated for testing or development purposes.

Devices may have associated metadata or properties, such as a unique identifier, camera type, location, or other relevant information that helps identify and manage them within the system. The devices are responsible for capturing camera feeds and transmitting them to the system for processing, typically through network protocols such as RTSP (Real-Time Streaming Protocol) or other appropriate methods.

In your application, the system likely manages multiple devices, handling their camera feeds simultaneously in real-time, and processing them using the image processor and other components of the system. The system may also handle device registration, configuration, monitoring, and other management tasks related to the devices, depending on the specific requirements and design of your application.

## GET `/devices`

Returns a list of devices.

Supports [**Pagination**](/api/reference#pagination) and [**Expansion**](/api/reference#expanding-responses)

### Response

- `200 OK` - success

```json title="Response body example"

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
      "status": "ONLINE",
      "user": 0
    },
    {
      "id": 2,
      "name": "Device 2",
      "description": "This is device 2",
      "stream": "rtsp://my-stream:5412/2",
      "status": "OFFLINE",
      "user": 0
    }
  ]
}
```

## Get `/devices/{id}`

Returns a device with a given ID.

Supports [**Expansion**](/api/reference#expanding-responses)

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
  "id": 3
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
  "items": [
    {
      "deviceID": 1,
      "startTime": "2019-07-25 21:23:00.000"
      "endTime": "2019-07-25 21:25:00.000"
      "peopleCount": 25
    },
    {
      "deviceID": 1,
      "startTime": "2019-07-25 21:25:00.000"
      "endTime": "2019-07-25 21:27:00.000"
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
    "instance": "/api/v1/devices/1/stats"
}

```
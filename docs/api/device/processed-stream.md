## GET `/devices/{id}/processed-stream`
Returns the processed stream of a device. If expanded it returns the device too.

Supports [**Expansion**](/api/reference#expanding-responses)

### Response

- `200 OK` - success

```json

GET /devices/1/processed-stream?expanded=false
Content-Type: application/json

{
    "deviceID": 1,
    "streamUrl": "rtsp://my-stream:5412/1"
}

GET /devices/1/processed-stream?expanded=true
Content-Type: application/json

{
    "streamURL": "rtsp://my-stream:5412/1",
    "device": {
        "id": 1,
        "name": "Device 1",
        "description": "This is the first device",
        "streamUrl": "rtsp://my-stream:5412/1",
    }
}

```

- `404 Not Found` if device group with the given ID doesn't exist

```json

GET /devices/1/processed-stream?expanded=false
Content-Type: application/problem+json

{
    "type": "https://sensiflow.com/errors/device-not-found",
    "title": "The requested resource was not found",
    "status": 404,
    "detail": "Device with id 1 not found",
    "instance": "/api/v1/devices/1/processed-stream"
}

```
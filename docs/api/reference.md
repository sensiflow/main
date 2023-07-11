# API Reference

The SensiFlow API is based on REST. Accepts JSON-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs.

## Status Codes

SensiFlow uses conventional HTTP response codes to indicate the success or failure of an API request. In general: Codes in the 2xx range indicate success. Codes in the 4xx range indicate an error that failed given the information provided (e.g., a required parameter was omitted or didn't met the constraints required, trying to access a resource that you're not supposed to, etc.). Codes in the 5xx range indicate an error with SensiFlow's servers (these are rare).

| Code | Description                                                              |
| ---- | ------------------------------------------------------------------------ |
| 200  | OK. Request succeeded.                                                   |
| 201  | Created. Request succeeded and a new resource was created.               |
| 202  | Accepted. Request accepted for processing. Can't be completed instantly. |
| 204  | No Content. Request succeeded but there is no content to return.         |
| 400  | Bad Request. The request is invalid.                                     |
| 401  | Unauthorized. Authentication failed.                                     |
| 403  | Forbidden. You do not have permission to access the requested resource.  |
| 404  | Not Found. The requested resource does not exist.                        |
| 409  | Conflict. The request could not be completed due to a conflict.          |
| 500  | Internal Server Error. Something went wrong on SensiFlow's end.          |

## Pagination

Requests that return multiple items will be paginated to **20** items by default. You can specify further pages with the `page` parameter. You can also set a custom page size up to **50** with the `size` parameter.

| Parameter | Type   | Description                      | Default | max    |
| --------- | ------ | -------------------------------- | ------- | ------ |
| page      | number | The page number to retrieve.     | 1       | ------ |
| size      | number | The number of items to retrieve. | 20      | 50     |

### Page

The response for a paginated request always follows the same `page` structure:

```json

Example GET /devices?page=1&size=10

{
  "totalPages": 2,
  "totalElements": 10,
  "isLast": true,
  "isFirst": true,
  "items": [
    {
      "id": 1,
      "name": "Cafeteria Device",
      "description": "This device is located in second floor of the cafeteria",
      "stream": "rtsp://my-stream:5412/1",
      "processedStreamURL": "rtsp://my-stream:5412/1/detected",
      "status": "ONLINE",
    },
    {
      "id": 2,
      "name": "Entrance Device",
      "description": "This device is located at the entrance of the building",
      "stream": "rtsp://my-stream:5412/2",
      "processedStreamURL": "rtsp://my-stream:5412/2/detected",
      "status": "OFFLINE",
    }
  ]
}
```

## Expanding Responses

Many objects allow you to request additional information as an expanded response by using the `expand` request parameter.

| Parameter | Type    | Description                                            | Required | Default |
| --------- | ------- | ------------------------------------------------------ | -------- | ------- |
| expanded  | boolean | Expand the response to include additional information. | No       | false   |

This allows you to request additional information about the object in the response, without having to make additional requests.

???+ example "Expand example"

    In the given example, our request is for a device group with an ID of 1. However, since we haven't provided the expand parameter, the response will solely consist of the group's metadata. To obtain additional information about the group, such as the devices associated with it, we can include expand=true in our request.

    ```json linenums="1 3" hl_lines="9 32"

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
                        "processedStreamURL": "rtsp://my-stream:5412/1/detected",
                        "userID": 0,
                        "deviceGroupsID": [1]
                      }
                    ]
                }
            }
        ]
    }
    ```

## Camera Stream Support

Currently, SensiFlow supports only RTSP streams. We are working on adding support for RTMP and HLS streams.

_[RTSP]: Real-Time Streaming Protocol
_[HLS]: Http Live Streaming \*[RTMP]: Real-Time Messaging Protocol

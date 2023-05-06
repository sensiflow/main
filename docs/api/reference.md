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

Example GET /devices?page=1&size=2

{
  "totalPages": 2,
  "totalElements": 10,
  "isLast": false,
  "isFirst": true,
  "items": [
    {
      "id": 1,
      "name": "Cafeteria Device",
      "description": "This device is located in second floor of the cafeteria",
      "stream": "rtsp://my-stream:5412/1",
      "status": "ONLINE",
      "user": 1
    },
    {
      "id": 2,
      "name": "Entrance Device",
      "description": "This device is located at the entrance of the building",
      "stream": "rtsp://my-stream:5412/2",
      "status": "OFFLINE",
      "user": 1
    }
  ]
}
```

## Expanding Responses

Many objects allow you to request additional information as an expanded response by using the `expand` request parameter.

| Parameter | Type    | Description                                            | Required | Default |
| --------- | ------- | ------------------------------------------------------ | -------- | ------- |
| expand    | boolean | Expand the response to include additional information. | No       | false   |

This allows you to request additional information about the object in the response, without having to make additional requests.

???+ example "Expand example"

    In the following example, we are requesting the device with id 1. We are not specifying the `expand` parameter, so the response will only include the entity id for the user. If we specify `expand=true`, the response will include the full user entity.

    ```json linenums="1 3" hl_lines="20 9"

    GET /devices/1

    {
        "id": 1,
        "name": "Cafeteria Device",
        "description": "This device is located in second floor of the cafeteria",
        "stream": "rtsp://my-stream:5412/1",
        "status": "ONLINE",
        "user": 1
    }

    GET /devices/1?expand=true

    {
        "id": 1,
        "name": "Cafeteria Device",
        "description": "This device is located in second floor of the cafeteria",
        "stream": "rtsp://my-stream:5412/1",
        "status": "ONLINE",
        "user": {
        "id": 1,
        "firstName": "John",
        "lastName": "Doe",
        }
    }

    ```

## Camera Stream Support

Currently, SensiFlow supports only RTSP streams. We are working on adding support for RTMP and HLS streams.

*[RTSP]: Real-Time Streaming Protocol
*[HLS]: Http Live Streaming
*[RTMP]: Real-Time Messaging Protocol

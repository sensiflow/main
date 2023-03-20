# API Reference

The SensiFlow API is based on REST. Accepts form-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs.

## Status Codes
SensiFlow uses conventional HTTP response codes to indicate the success or failure of an API request. In general: Codes in the 2xx range indicate success. Codes in the 4xx range indicate an error that failed given the information provided (e.g., a required parameter was omitted or didn't met the constraints required, trying to access a resource that you're not supposed to, etc.). Codes in the 5xx range indicate an error with SensiFlow's servers (these are rare).

| Code | Description |
|------|-------------|
| 200 | OK. Request succeeded. |
| 201 | Created. Request succeeded and a new resource was created. |
| 204 | No Content. Request succeeded but there is no content to return. |
| 400 | Bad Request. The request is invalid. |
| 401 | Unauthorized. Authentication failed. |
| 403 | Forbidden. You do not have permission to access the requested resource. |
| 404 | Not Found. The requested resource does not exist. |
| 500 | Internal Server Error. Something went wrong on SensiFlow's end. |

## Pagination

Requests that return multiple items will be paginated to **20** items by default. You can specify further pages with the `page` parameter. You can also set a custom page size up to **50** with the `size` parameter.

| Parameter | Type | Description | Default | max |
|-----------|------|-------------| ------- | --- |
| page | number | The page number to retrieve. | 1 | ------ |
| size | number | The number of items to retrieve. | 10 | 50 |

### Page

The response for a paginated request always follows the same `page` structure:

```json
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
    },
    {
      "id": 2,
      "name": "Device 2",
      "description": "This is device 2",
      "stream": "rtsp://my-stream:5412/2",
      "status": "OFFLINE",
    }
  ]
}
```


## Camera Stream Support

Currently, SensiFlow supports only _RTSP_ streams. We are working on adding support for _RTMP_ and _HLS_ streams.
If you're working with cameras and video feeds, you may not want your camera to always process its feed. With that in mind, our API provides mechanisms to start, stop or even pause a camera from processing a stream.

To manage the processing of a device, we introduce the concept of the device's processing state. The processing state of a device determines whether its stream is being processed or not. The possible values for the processing state are:

| State    | Description                                                            |
| -------- | ---------------------------------------------------------------------- |
| Active   | Device's feed is being processed continuously.                         |
| Inactive | Device's feed is not being processed.                                  |
| Paused   | Device's feed is not being processed.                                  |
| Pending  | A request to change the processing state of the device is in progress. |

## Pausing vs. Stopping

When you pause a device's processing state, the `Image Processor Worker` that is processing the device's stream is preserved. If you resume the processing state within a short period of time, the worker will still be available and processing can start again quickly.

However, if you pause a device's processing state for a long period of time, the instance of the Image Processor will eventually be stopped. This means that if you resume processing after a long pause, there may be some delay while the Image Processor is restarted and the stream is re-initialized.

This is because a Image Processor Worker is a resource-intensive process that consumes a significant amount of memory and processing power. By stopping unused instances, we can free up resources to be used by other processes and ensure that the system runs smoothly.

### When to Pause vs. Stop

So, if you know that you're going to resume processing a device's stream within a short period of time, it's best to pause the processing state rather than stopping it completely. This will ensure that processing can be resumed quickly and without delay.

## PUT `/devices/{id}/processing-state`

Updates the processing state of an existing device with a given ID.

### Request Body

The request body should contain a JSON object with a single property `state` indicating the new processing state.

### Effective transitions

| From\To  | Active | Inactive | Paused |
| -------- | ------ | -------- | ------ |
| Active   | No     | Yes      | Yes    |
| Inactive | Yes    | No       | No     |
| Paused   | Yes    | Yes      | No     |

!!! info "Pending state"

    You can't transition to the `Pending` state. The `Pending` state is only used to indicate that a request to change the processing state of a device is in course.

#### Example

```json
{
  "state": "Paused"
}
```

### Response

- `202 Accepted` on success, meaning that the request has been accepted for processing
- `400 Bad Request` if the request body is invalid
- `404 Not Found` if device with the given ID doesn't exist
- `409 Conflict` if the device is already being updated

## Synchronizing with the processing state update finish

When you change the processing state of a device, the response will be returned immediately with a `202 Accepted` status code. This means that the request has been accepted for processing, but the processing state of the device may not have been updated yet.

One approach to ensure that the processing state has been updated is to poll the device's details until the processing state has been updated. Since the device state will be `PENDING` while the processing state is being updated, you can poll the device's details until the processing state is no longer `PENDING`.

However, this approach is inefficient and can lead to unnecessary load on the server. Instead, we recommend that you use the server-sent events mechanism to subscribe to the device's processing state changes.

### Device Processing State SSE

As soon as you send a request to change the processing state of a device, you can subscribe to the device's processing state changes using the SSE mechanism. This event will return "PENDING" as the processing state until the processing state has been updated. Once the processing state has been updated, the event will return the new processing state and close the connection.

This is mainly useful to update the UI of your application to reflect the correct processing state of the device in real-time.

Can be useful to avoid updating the state of the device again if the processing state is already being updated.

#### Example

```json
GET /devices/1/server-events/processing-state
Accept: text/event-stream

event: processing-state
data: PENDING

event: processing-state
data: PENDING

event: processing-state
data: PENDING

event: processing-state
data: ACTIVE

```

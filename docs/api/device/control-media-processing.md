If you're working with cameras and video feeds, you may not want your camera to always process its feed. Luckily, our API provides mechanisms to pause or even stop a camera from processing a stream.

To manage the processing of a device, we introduce the concept of the device's processing state. The processing state of a device determines whether its stream is being processed or not. The possible values for the processing state are:

| State    | Description                                                               |
| -------- | ------------------------------------------------------------------------- |
| Active   | Device's feed is being processed continuously.                             |
| Inactive | Device's feed is not being processed.     |
| Paused   | Device's feed is not being processed.     |

## Pausing vs. Stopping

When you pause a device's processing state, the instance of the Image Processor that is processing the device's stream is preserved. If you resume the processing state within a short period of time, the instance will still be available and processing can start again quickly.

However, if you pause a device's processing state for a long period of time, the instance of the Image Processor will eventually be stopped. This means that if you resume processing after a long pause, there may be some delay while the Image Processor is restarted and the stream is re-initialized.

This is because the Image Processor is a resource-intensive process that consumes a significant amount of memory and processing power. By stopping unused instances, we can free up resources to be used by other processes and ensure that the system runs smoothly.

### When to Pause vs. Stop

So, if you know that you're going to resume processing a device's stream within a short period of time, it's best to pause the processing state rather than stopping it completely. This will ensure that processing can be resumed quickly and without delay.

## PUT `/devices/{id}/processing-state`

Updates the processing state of an existing device with a given ID.


### Request Body

The request body should contain a JSON object with a single property `state` indicating the new processing state.

### Effective transitions

| From\To | Active | Inactive | Paused |
| ------- | ------ | -------- | ------ |
| Active  | No     | Yes      | Yes    |
| Inactive| Yes    | No       | No    |
| Paused  | Yes    | Yes      | No     |


#### Example

```json
{
  "state": "Paused"
}
```

### Response

- 204 No Content on success
- 400 Bad Request if the request body is invalid
- 404 Not Found if device with the given ID doesn't exist
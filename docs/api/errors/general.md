# Errors

The errors returned by the API are in Problem Details for HTTP APIs format. This format is defined in [RFC 7807](https://tools.ietf.org/html/rfc7807). The following is an example of an error returned by the API:

```json
{
  "type": "https://example.com/probs/out-of-credit",
  "title": "You do not have enough credit.",
  "detail": "Your current balance is 30, but that costs 50.",
  "instance": "/account/12345/msgs/abc",
  "balance": 30,
  "accounts": ["/account/12345",
               "/account/67890"]
}
```

The following is a list of all the errors that can be returned by the API.

## Client errors


#### Conflict

The resource already exists.

##### Email Already Exists

The given email already exists.
This may be caused by trying to create a User with an already registered email.

### Not Found

The requested resource does not exist.
This can happen when you try to access a resource that does not exist.
The following errors are related to this one:

##### User Not Found

The requested user does not exist.
This may be caused by an invalid user id.

##### Device Not Found

The requested device does not exist.
This may be caused by an invalid device id.

##### Device Group Not Found

The requested device group does not exist.
This may be caused by an invalid device group id.

##### Processed Stream Not Found

The requested processed stream does not exist.
This may be caused by an invalid processed stream id.

##### Email Not Found

The requested email does not exist.
This may be caused by search for a non existing email.

### Authentication and Authorization errors

##### Unauthorized

The request was not authorized.
This can happen when you try to access a resource that you are not authorized to access.
This may be cause by not having enough permissions to access the resource.

##### Unauthenticated

The request was not authenticated.
This may happen when you try to access a resource that requires authentication and you are not authenticated.
To authenticate, you must make a valid login or register request.

##### Invalid Credentials

The credentials provided are invalid.
This may happen when you try to login with invalid credentials.

### Validation errors

The received data is invalid.
The following errors are related to this one:

##### Invalid Token

The received token is invalid.
This may be caused by an expired token or a no longer valid token.

##### Invalid Parameter

The parameter is invalid.
This can happen when a sent parameter has the wrong format,type, or even if it is missing.

##### Invalid Json Structure

The received JSON body is invalid, this means that the JSON is not well formed or there is a missing field check the necessary parameters on the endpoint documentation.
Check the [JSON structure](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON#json_structure) to see what is the correct format.

##### Handler Not Found

This happens when a request is made to an endpoint that does not exist.

##### Method Not Allowed

This happens when a request is made to an endpoint with an invalid method.

##### Required Uri Parameter Missing

This happens when a request is made to an endpoint with a missing required parameter.
Please check the endpoint documentation to see what parameters are required.

##### Invalid Processing State

The given processing state is invalid.
This may be caused by trying to update a processed stream with an invalid processing state.

##### Invalid Processing State Transition

This happens when updating a device with an invalid processing state transition.
This may occur when the state was the same as the previous one or when it was paused and a request is made to be inactive.

## Server errors

#### Internal Server Error

An internal server error occurred.
This can happen when the server is not able to process the request.
 
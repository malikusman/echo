# Echo

## Introduction

The Echo application is a mock server designed to serve simple endpoints created dynamically via an API.

## Architecture and Design

The application adheres to the SOLID principles to ensure that it is scalable, maintainable, and robust. It employs a service-oriented architecture to separate concerns, making the codebase easier to manage and test.

### Service Objects
`CreateService` and `UpdateService` are used for handling the business logic of creating and updating endpoints, respectively. These services inherit from a `Base` service, which contains shared logic such as parameter validation. This approach keeps the code DRY.

### Middleware
A custom middleware, `EndpointHandler`, intercepts HTTP requests to dynamically determine if the request matches any defined mock endpoints. If a match is found, it returns the specified mock response; otherwise, it proceeds with normal Rails controller routing. This middleware is crucial for the primary functionality of serving user-defined endpoints.

## Testing Strategy

Comprehensive test coverage across models, services, controllers, and middleware ensures that the application behaves as expected:

- **Model Tests**: Validate the integrity and constraints of the `Endpoint` model, ensuring that all required fields are present and correctly formatted.

- **Service Tests**: Ensure that `CreateService` and `UpdateService` handle both successful and erroneous inputs correctly, encapsulating the business logic away from the controller.

- **Request Tests**: Test the API endpoints to ensure they respond correctly under various scenarios, including both valid and invalid requests.

- **Middleware Tests**: Using `rack-test`, these tests simulate requests to the server to verify that the middleware correctly handles both registered and non-registered paths, and that it correctly forwards requests to the app when necessary.

**Running RSpec and RuboCop**
```
usman@192 echo % rspec
...............................................................

Finished in 0.75874 seconds (files took 4.12 seconds to load)
63 examples, 0 failures

usman@192 echo % rubocop
Inspecting 26 files
..........................
```



## Error Handling

Errors are managed throughout the application, providing clear, actionable error messages. The application handles common errors such as 404 Not Found and 400 Bad Request, ensuring that clients receive proper feedback for correction.

## Response

The application primarily communicates with clients through JSON responses that adhere to general JSON response structures

**Sample success response**

```
{
  "id": "unique identifier",
  "verb": "GET",
  "path": "/hello",
  "response": {
    "code": 200,
    "headers": {
      "Content-Type": "application/json"
    },
    "body": "Response content here"
  },
  "created_at": "2023-05-05T12:34:56Z",
  "updated_at": "2023-05-05T12:34:56Z"
}
```

**Sample error response**

```
{
  "errors": [
    {
      "code": "not_found",
      "detail": "Requested page `/hello` does not exist"
    }
  ]
}
```

## Setup and Execution

The application requires Ruby and Rails, with dependencies managed via Bundler. To set up and run the application locally:

1. Clone the repository.
2. Run `bundle install` to install dependencies.
3. Start the server with `rails s`.

Tests can be executed by running `rspec` within the project directory.

## Additional Tools and Practices

- **Localization**: Error messages and other strings are localized (only en for now)


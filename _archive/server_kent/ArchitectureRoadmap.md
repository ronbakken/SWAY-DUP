# Architecture Roadmap

High level task list:

- [X] Containerization of services (using Docker)
- [X] Try out hosting in Service Fabric Mesh
- [X] Transition to Kubernetes
- [ ] Implement a messaging microservice and client library
- [ ] Implement REPL microservice
- [ ] One by one, implement each required microservice based on the existing code, splitting into multiple repositories along the way

## Introduction

This document discusses plans for improvements to the server architecture. The current architecture, discussed below, was borne out of a pragmatic need to produce an MVP in a timely manner. As such, technical debt was knowingly accumulated in order to decrease the time to MVP. The future architecture will build upon the MVP, re-working some aspects and enhancing others, so that the application is more maintainable, more scalable, more resilient to errors, and potentially cheaper to operate.

## Current Architecture Overview

The current architecture of the server could be described as service-oriented. It leverages Service Fabric as the backbone for hosting, managing, and deploying those services. Each service tends to:

* Have a coarse-grained API
* Use Cosmos DB to store data, making the service itself stateless
* Expose its available operations via gRPC endpoints
* Communicate with other services via a service bus, using serialized protocol buffers as the message payload

At least, the above is true of "internal" services that are not exposed directly to clients outside of the cluster. The **API** service is a special service in that it is available outside the cluster so that the end client app can interact with it. It forwards calls onto the appropriate internal service, such as the **Users** or **Offers** service. In some cases, it will even maintain state on behalf of the connecting client.

## Limitations and Problems with Current Architecture

This section outlines some of the problems being experienced or predicted with the current architecture.

### Broad Responsibilities

Services tend to have broader responsibilities than desirable. This is in part driven by Service Fabric's deployment model, since each service can have a [large impact](https://github.com/Microsoft/service-fabric/issues/304) on the deployment size. However, it's also driven by a lack of time to set up requisite skeletons and tooling around creating and managing multiple, smaller services. i.e. microservices.

### Coupling

Internal services currently expose their operations via gRPC. This creates a tight coupling between services. It means that changes to an internal service tend to have a bubbling effect all the way up to the **API** service.

### Synchronous Calls within Internal Services

Following on from the above, when internal services call each other, they do so via gRPC and therefore wait for a response. Synchronous flows like this are greatly discouraged in microservice architectures, since failures can be greatly exacerbated by misbehaving clients. It means timeouts, retry policies, jitter, circuit breakers, etcetera all have to be far more stringently implemented and tested.

### Testability

Internal services are tested only via the **API** service by way of integration tests. There is no easy ability to stand up an internal service in isolation and see how it responds to different inputs.

### Scattered or Missing Domain Logic

The haste to get to MVP has meant that much domain logic is either missing or scattered about the code base in an unkempt fashion.

### Cluster Management

Service Fabric requires us to deploy and manage our own cluster. This means there is a greater responsibility on us to keep it configured correctly.

## Future Improvements

This section discusses various improvements that can/will be made to the architecture to address the above, and more. The underlying theme here is a move from a service-oriented architecture to a microservices one.

### Containerization

The first step towards improvement will be to containerize the application. That is, host each service in its own Docker container.

### Service Fabric Mesh/Kubernetes

Once containerized, the application can be hosted in Service Fabric Mesh or Kubernetes, which will alleviate us of the need to manage the cluster ourselves. Instead, we just describe application requirements (including auto-scaling configuration) and it is managed automatically.

My preference was originally Service Fabric Mesh, since it is more tightly integrated with the Microsoft ecosystem. However, after spending a little time with it, I have found it to be too early. It is still in preview and has some debilitating bugs. Therefore, I have moved towards Kubernetes instead. This will likely be the better option long-term, since it is a more independent set of tooling - not tied to Microsoft or any other vendor - written in the open.

### Asynchronous Messaging with Transparent Routing

To decouple services and improve scalability, asynchronous message passing should be implemented. This will mean that, instead of invoking gRPC endpoints, services will publish messages to each other and not wait around for a response (apart from the **API** service, at least for unary calls). Not only will this massively improve the scalability of the internal services, but will also decouple them further. In addition, it will force timeouts to be implemented as a natural consequence of communicating asynchronously via messages.

Importantly, the routing of messages must be transparent to the services. They should have no say in what messages they receive - that should be dictated externally. This will make it far more practical to roll out changes and give us a lot more flexibility in general. For example, inserting a caching layer would have no effect on the existing services - it would just involve deploying a new caching service and re-routing messages appropriately.

### Splitting up Code

The current implementation of the INF server resides in a single git repository. This is impractical for a microservices architecture, since each service is supposed to be independently built and deployed. Thus, we will need to split up the code into separate repositories. I envisage something along the lines of (it would be nice if GitHub had a better repository grouping mechanism than organizations):

* `infmarketplace/inf_server_tools` : tools for developers working on the INF server. For example, templates to generate a skeletal microservice.
* `infmarketplace/inf_server_message_bus` : the message bus used to communicate between microservices. Every microservice would depend on this (via a client library that versions independently of the microservice).
* `infmarketplace/utility` : utility code that pretty much every microservice requires (e.g. logging). Distributed via a NuGet package so that microservices can choose to upgrade at their leisure.
* `infmarketplace/inf_server_service_$NAME` : a microservice.
* `infmarketplace/inf_server_mock` : a mock of the API microservice.

### Testability

As a consequence of ensuring microservices only communicate via messages, they will become highly testable. Unit tests will be a matter of mocking dependencies, passing in a message, and verifying the emitted messages. Integration tests will also pass in and verify emitted messages, but will do so without mocking dependencies. Integration tests can also verify that the correct state changes are enacted in the dependencies (e.g. Cosmos DB is updated).

The existing "integration tests" are really system tests and should be renamed as such.

### REPL

An early service to be added to the system will be a REPL. This will provide an interface that developers can connect to externally. It must allow them to perform core operations against the system - such as publishing and subscribing to messages - all in a scriptable environment.

### DDD

To get domain logic under control, I intend to implement a domain layer in appropriate services. This will centralize domain logic, providing a neat and well-tested area for it to reside. This domain logic will be a gatekeeper - if data does not satisfy it, that data won't be saved.

### Refined Deployment

With containers and an orchestrator in use (Kubernetes), deployment should become far easier than it currently is. This is because it is precisely the orchestrator's job to do so, as well as manage scaling and the like.

# Notes (to formalize later)

## Development Workflow

Stuff to mention/think about:

* Docker/Kubernetes not intended to be used day to day (way too slow and unwieldy). Rely predominantly on unit and integration tests instead.

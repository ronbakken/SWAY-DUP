# INF Server

## Development Setup

### Basic Tooling

1. Install Visual Studio 2017 from [here](https://visualstudio.microsoft.com/downloads/). Any edition suffices. Make sure you install the **Azure development** workload. If you already had VS installed, you can run the Visual Studio Installer to modify the installed workloads.

2. Download and run the [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx).

3. Search for "Service Fabric SDK". Choose an appropriate version - `3.3.617` at time of writing - of "Microsoft Azure Service Fabric SDK" and select **Add**. Click **Install**.
<br /><br />
**NOTE:** do _not_ choose the options that include tools, since they are superseded

4. Start Visual Studio, open the solution, and run it.
<br /><br />
**NOTE:** you must run Visual Studio as Administrator in order to debug Service Fabric applications locally.

### Environment Setup

The Bitrise script allows environment variables to be overridden. This is critical to keeping developer environments segregated.

Create a file called `inf_server.env` at `C:\Users\$NAME\inf_server.env`. Put the following content inside `inf_server.env`:

```
ENVIRONMENT=<<YOUR_NAME>>
REGION=<<YOUR REGION>>
```

Replace `<<YOUR_NAME>>` with your first name. This will be incorporated into the resource group name and all resources within, ensuring your resources are kept separate to those of other developers and environments.

Replace `<<YOUR REGION>>` with your desired [Azure region](https://azure.microsoft.com/en-au/global-infrastructure/regions/). Usually you will want to choose the region closest to you so that you get a slight performance improvement during the development cycle.

**NOTE:** keep your environment name short. It is used in naming resources and some resources have very restrictive length requirements for their names. If your environment name is too long, the deployment will fail with an error along the lines of:

```
AccountNameInvalid: XXX: XXX is not a valid storage account name. Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
```

### Automated Build Tooling

1. Install Docker.

2. Install the [Azure CLI Docker tooling](https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest).

## Building and Deploying via Visual Studio

TODO

## Building and Deploying via the CI Script

1. Start Docker, which is most easily achieved by running the Cake target called `Start-Docker`. From a Powershell terminal, this can be accomplished with:
    ```
    ./build.ps1 -target Start-Docker
    ```
2. From the Bash terminal, execute Bitrise with:

    ```
    bitrise run localdev
    ```

## Confounding Problems (and Solutions)

This is a list of problems that can occur when developing with Service Fabric for which the answer is not always immediately obvious.

### Accidental Recursion

This one is an easy mistake to make, but difficult to spot due to the lack of feedback from Service Fabric during startup.

Consider these symptoms:

* Application builds and deploys
* Service Fabric management console reports the application as unhealthy due to a service (probably one you've just added or modified)
* Service Fabric keeps trying to create new instances of that service to rescue it
* The management console does not give much information about the problem other than "Partition is below target replica or instance count"
* Breakpoints in the service constructor hit, but not the `RunAsync` method

These symptoms are actually very general and are indicative only of Service Fabric being unable to start your service. There are likely many reasons this might be, but a particularly insidious one is this:

```C#
protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
    this.CreateServiceInstanceListeners();
```

This code introduces accidental recursion, so when Service Fabric invokes this method, it times out waiting for it to respond. The code is supposed to be (this is for a stateless service - a stateful one is very similar but different):

```C#
protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
    this.CreateServiceRemotingInstanceListeners();
```

Notice the small difference between the method names. The problem is compounded by the fact that `CreateServiceRemotingInstanceListeners` is an extension method that won't be available if you've forgotten to add a dependency on `Microsoft.ServiceFabric.Services.Remoting` or have neglected to import the `Microsoft.ServiceFabric.Services.Remoting.Runtime` namespace. Thus, it's very easy to accidentally have Intellisense resolve the wrong method!

###

## Posterity Notes

This section is for record purposes. You shouldn't need this day-to-day.

### Steps for Generating the CI Service Principal

The CI Service Principal was generated using the Azure CLI signed in as the owner account. The commands used were:

```
# First, create an appropriate certificate
az ad sp create-for-rbac --name CI --create-cert --cert CI --years 10 --keyvault INF-Marketplace

# Next, create a service principal with which the CI will be able to authenticate
az ad sp create-for-rbac --name CI-Service-Principal --cert CI --keyvault INF-Marketplace
```

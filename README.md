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
```

Replace `<<YOUR_NAME>>` with your first name. This will be incorporated into the resource group name and all resources within, ensuring your resources are kept separate to those of other developers and environments.

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

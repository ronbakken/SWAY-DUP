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

### Automated Build Tooling

1. Install Docker.

2. Install the [Azure CLI Docker tooling](https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest).

3.
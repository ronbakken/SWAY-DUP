#addin nuget:?package=Cake.Git&version=0.19.0
#addin nuget:?package=Newtonsoft.Json&version=11.0.2

using System;
using System.Linq;
using System.Net;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

var gitBranch = GitBranchCurrent(".");

var environment = EnvironmentVariable("ENVIRONMENT");

// Variables.
var isEphemeral = environment == "ephemeral";
var resourceGroupName = $"inf-{(isEphemeral ? "eph-" + GenerateRandomString(2, includeSpecial: false, includeUpper: false) : environment)}";
var configuration = "Release";
var acrName = "infcontainerregistry";
var acrLoginServer = $"{acrName}.azurecr.io";

// Parameters.
var bitriseBuildNumber = int.Parse(EnvironmentVariable("BITRISE_BUILD_NUMBER") ?? "-1");
var executingOnBitrise = bitriseBuildNumber != -1;
var deployLocally = bool.Parse(EnvironmentVariable("DEPLOY_LOCALLY") ?? "false");
var localDeployDir = Directory(EnvironmentVariable("LOCAL_DEPLOY_DIR") ?? ".");
var region = EnvironmentVariable("REGION");
var subscriptionId = EnvironmentVariable("AZURE_SUBSCRIPTION_ID");
var clientId = EnvironmentVariable("AZURE_CLIENT_ID");
var tenantId = EnvironmentVariable("AZURE_TENANT_ID");
var deploymentsStorageAccountConnectionString = EnvironmentVariable("AZURE_STORAGE_ACCOUNT_CONNECTION_STRING");
var seqServerUrl = EnvironmentVariable("SEQ_SERVER_URL");
var seqApiKey = EnvironmentVariable("SEQ_API_KEY");
var acrServicePrincipalId = EnvironmentVariable("ACR_SERVICE_PRINCIPAL_ID");
var acrServicePrincipalObjectId = EnvironmentVariable("ACR_SERVICE_PRINCIPAL_OBJECT_ID");
var acrServicePrincipalSecret = EnvironmentVariable("ACR_SERVICE_PRINCIPAL_SECRET");
var clusterDnsPrefix = EnvironmentVariable("CLUSTER_DNS_PREFIX") ?? resourceGroupName;
var clusterNodeVMSize = EnvironmentVariable("CLUSTER_NODE_VM_SIZE") ?? "Standard_D2_v2";
var clusterNodeOSDiskSizeGB = int.Parse(EnvironmentVariable("CLUSTER_NODE_OS_DISK_SIZE_GB") ?? "0");
var clusterNodeCount = int.Parse(EnvironmentVariable("CLUSTER_NODE_COUNT") ?? "1");
var clusterNodeMaxPods = int.Parse(EnvironmentVariable("CLUSTER_NODE_MAX_PODS") ?? "100");

// Paths.
var srcDir = Directory("src/inf_server");
var genDir = Directory("gen");
var pkgDir = Directory("pkg") + Directory(configuration);
var zippedPackageFile = Directory("pkg") + File("package.sfpkg");
var keyFile = File("Azure.key");
var sslCertificatesFile = File("SSLCertificates.zip");
var infrastructureTemplateFile = srcDir + File("arm_infrastructure.json");
var solutionFile = srcDir + File("server.sln");

if (!FileExists(keyFile))
{
    throw new Exception($"The key file, '{keyFile}', used to authenticate with Azure could not be found.");
}

Setup(
    context =>
    {
        Information($"Starting deployment against git branch '{gitBranch.CanonicalName}'.");
        Information($"Region '{region}', environment '{environment}'{(isEphemeral ? "(an ephemeral environment)" : "")}, resource group name '{resourceGroupName}', subscription ID '{subscriptionId}', client ID '{clientId}', tenant ID '{tenantId}'.");
    });

Setup<DeploymentData>(
    context => new DeploymentData());

Teardown(
    context =>
    {
        if (isEphemeral)
        {
            Warning($"Cleaning up resource group '{resourceGroupName}' for ephemeral build.");

            var exitCode = StartProcess(
                "az",
                new ProcessSettings
                {
                    Arguments = $"group delete --name {resourceGroupName} --yes",
                });

            if (exitCode != 0)
            {
                Error($"Unexpected exit code from az group delete: {exitCode}");
                return;
            }
        }
    });

Task("Clean")
    .Does(() => CleanDirectories(new DirectoryPath[] { pkgDir, genDir }));

Task("Pre-Build")
    .Does(
        () =>
        {
            CreateDirectory(genDir);
            CleanDirectories(genDir);

            if (FileExists(sslCertificatesFile))
            {
                var targetDirectory = Directory(System.IO.Path.GetTempPath()) + Directory("ssl_certs");
                Information($"Unzipping SSL certificates to '{targetDirectory}'.");
                Unzip(sslCertificatesFile, targetDirectory);

                var serverCrtFile = targetDirectory + File($"server_{environment}.crt");
                var serverKeyFile = targetDirectory + File($"server_{environment}.key");

                var gRPCDirectory = srcDir + Directory("Utility/gRPC");

                if (FileExists(serverCrtFile))
                {
                    var targetFile = gRPCDirectory + File("server.crt");
                    Information($"Moving '{serverCrtFile}' to '{targetFile}'.");
                    MoveFile(serverCrtFile, targetFile);

                    // TODO: might actually need to use ca.cert from integration tests, should we ever use SSL there
                    var integrationTestsDir = srcDir + Directory("IntegrationTests");
                    Information($"Copying '{targetFile}' to '{integrationTestsDir}'.");
                    CopyFile(targetFile, integrationTestsDir + File("server.crt"));
                }

                if (FileExists(serverKeyFile))
                {
                    var targetFile = gRPCDirectory + File("server.key");
                    Information($"Moving '{serverKeyFile}' to '{targetFile}'.");
                    MoveFile(serverKeyFile, targetFile);
                }
            }

            Information("Logging into Azure with service principal.");

            var exitCode = StartProcess(
                "az",
                new ProcessSettings
                {
                    Arguments = $@"login -u ""http://CI-Service-Principal"" --tenant {tenantId} --service-principal -p {keyFile}",
                });

            if (exitCode != 0)
            {
                Error($"Unexpected exit code from az login: {exitCode}");
                return;
            }
        });

Task("Deploy")
    .IsDependentOn("Clean")
    .IsDependentOn("Pre-Build")
    .Does(
        async (context) =>
        {
            // 1. Deploy the ARM infrastructure template.
            EnsureResourceGroup(context, resourceGroupName, region);

            var deploymentOutput = await DeployARMTemplate(
                context,
                resourceGroupName,
                infrastructureTemplateFile,
                new Dictionary<string, object>
                {
                    { "resourcePrefix", resourceGroupName },
                    { "acrServicePrincipalId", acrServicePrincipalId },
                    { "acrServicePrincipalObjectId", acrServicePrincipalObjectId },
                    { "acrServicePrincipalSecret", acrServicePrincipalSecret },
                    { "clusterDnsPrefix", clusterDnsPrefix },
                    { "clusterNodeVMSize", clusterNodeVMSize },
                    { "clusterNodeOSDiskSizeGB", clusterNodeOSDiskSizeGB },
                    { "clusterNodeCount", clusterNodeCount },
                    { "clusterNodeMaxPods", clusterNodeMaxPods },
                },
                genDir);

            var deploymentData = context.Data.Get<DeploymentData>();
            deploymentData.DeploymentOutputs = (JObject)deploymentOutput["properties"]["outputs"];

            // 2. Build and deploy each service.
            Information("Logging into container registry.");
            var exitCode = context.StartProcess(
                "az",
                new ProcessSettings
                {
                    Arguments = $"acr login --name {acrName}",
                });

            if (exitCode != 0)
            {
                Error($"Unexpected exit code when logging into container registry: {exitCode}");
                return;
            }

            Information("Connecting to Kubernetes cluster.");
            var clusterName = $"{resourceGroupName}-cluster";
            exitCode = context.StartProcess(
                "az",
                new ProcessSettings
                {
                    Arguments = $"aks get-credentials --resource-group {resourceGroupName} --name {clusterName}",
                });

            if (exitCode != 0)
            {
                Error($"Unexpected exit code when connecting to Kubernetes cluster: {exitCode}");
                return;
            }

            var commits = GitLog(Directory("."), 1);
            var commit = commits.First();
            var sha = commit.Sha;

            Information($"SHA is {sha}.");

            var services = new[]
            {
                (directory: "API", name: "api", port: 9026),
                (directory: "InvitationCodes", name: "invitation-codes", port: 9027),
                (directory: "Mapping", name: "mapping", port: 9028),
                (directory: "Messaging", name: "messaging", port: 9029),
                (directory: "Offers", name: "offers", port: 9030),
                (directory: "Users", name: "users", port: 9031),
            };

            foreach (var service in services)
            {
                var ip = await BuildAndDeployService(
                    context,
                    acrLoginServer,
                    service.name,
                    srcDir,
                    srcDir + Directory(service.directory) + context.File("Dockerfile"),
                    genDir + File($"kubernetes_{service.name}.yaml"),
                    sha,
                    service.port,
                    environment,
                    resourceGroupName,
                    seqServerUrl,
                    seqApiKey,
                    deploymentData.DatabaseConnectionString,
                    deploymentData.ServiceBusConnectionString,
                    deploymentData.UserStorageAccountConnectionString);

                if (service.name == "api")
                {
                    deploymentData.ApiUrl = $"{ip}:9026";
                }
            }

            // 3. Give the service account the dashboard-admin role so that the Kubernetes dashboard can be accessed. See https://docs.microsoft.com/en-us/azure/aks/kubernetes-dashboard#for-rbac-enabled-clusters
            Information("Granting access to Kubernetes dashboard to service account.");
            exitCode = context.StartProcess(
                "kubectl",
                new ProcessSettings
                {
                    Arguments = "create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard",
                });

            if (exitCode < 0)
            {
                Error($"Unexpected exit code when executing kubectl create clusterrolebinding: {exitCode}");
                return;
            }

            Information($"Done");
        });

Task("Build-Integration-Tests")
    .IsDependentOn("Pre-Build")
    .Does(
        () =>
        {
            var integrationTestsDir = srcDir + Directory("IntegrationTests");
            var settings = new DotNetCoreBuildSettings
            {
                Configuration = "Release",
            };

            DotNetCoreBuild(integrationTestsDir, settings);
        });

Task("Run-Integration-Tests")
    .IsDependentOn("Build-Integration-Tests")
    .IsDependentOn("Deploy")
    // This is critical - we do NOT want to run integration tests anywhere other than ephemeral environments!
    .WithCriteria(isEphemeral)
    .Does(
        context =>
        {
            // Just to be extra cautious.
            if (!isEphemeral)
            {
                Error("CRITICAL!! Should not be running for non-ephemeral environments.");
                return;
            }

            var deploymentData = context.Data.Get<DeploymentData>();

            if (deploymentData == null)
            {
                Error("No deployment data found.");
            }

            Information("Running integration tests.");
            Information($"API URL is '{deploymentData.ApiUrl}', database connection string is '{deploymentData.DatabaseConnectionString}'.");

            var integrationTestAssembly = srcDir + Directory("IntegrationTests/bin/Release/netcoreapp2.1/") + File("IntegrationTests.dll");
            var arguments = new ProcessArgumentBuilder();
            arguments
                .Append(deploymentData.ApiUrl)
                .Append(deploymentData.DatabaseConnectionString);

            DotNetCoreExecute(
                integrationTestAssembly,
                arguments);
        })
    .Finally(() => DeployLocally(File("integration-tests.log")));

Task("Root")
    .IsDependentOn("Run-Integration-Tests");

Task("Start-Docker")
    .Does(
        () =>
        {
            var conventionalEnvironmentFile = Directory(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)) + File("inf_server.env");
            var environmentFileVariable = EnvironmentVariable("ENVIRONMENT_FILE");
            var environmentFile = environmentFileVariable == null ? conventionalEnvironmentFile : File(environmentFileVariable);

            if (!FileExists(environmentFile))
            {
                Error($"No environment file was found at '{environmentFile}'.\r\n\r\nBy convention, this file should exist at '{environmentFile}'. However, you can also override the location via the ENVIRONMENT_FILE environment variable. See the README for details on what the environment file should contain.");
                return;
            }

            Information($"Using environment file '{environmentFile}'.");

            var currentDirectory = MakeAbsolute(Directory("."));
            var currentDirectoryFormatted = currentDirectory.ToString().Replace("\\", "/") + "/";

            StartProcess(
                "docker",
                new ProcessSettings
                {
                    Arguments = $@"run --privileged --env-file ""{environmentFile}"" --volume ""{currentDirectoryFormatted}:/bitrise/src"" --volume ""/var/run/docker.sock:/var/run/docker.sock"" --rm -it bitriseio/docker-android:latest bash"
                });
        });

private static void EnsureResourceGroup(ICakeContext context, string name, string region)
{
    context.Information($"Ensuring resource group '{name}' exists.");
    context.StartProcess(
        "az",
        new ProcessSettings
        {
            Arguments = $"group exists --name {name}",
            RedirectStandardOutput = true,
        },
        out var redirectedStandardOutput);

    var exists = redirectedStandardOutput.First() == "true";

    if (exists)
    {
        context.Information($"Resource group '{name}' already exists.");
    }
    else
    {
        context.Information($"Resource group '{name}' does not yet exist, so creating it.");
        var exitCode = context.StartProcess(
            "az",
            new ProcessSettings
            {
                Arguments = $@"group create --name {name} --location ""{region}""",
            });

        if (exitCode != 0)
        {
            context.Error($"Unexpected exit code from az group create: {exitCode}");
            return;
        }

        context.Information($"Resource group '{name}' created in region '{region}'.");
    }
}

private static async Task<JObject> DeployARMTemplate(
    ICakeContext context,
    string resourceGroupName,
    ConvertableFilePath templateFile,
    IDictionary<string, object> templateParameters,
    ConvertableDirectoryPath genDir)
{
    var deploymentName = $"{resourceGroupName}-{System.IO.Path.GetFileNameWithoutExtension(templateFile)}";
    context.Information($"Deploying ARM template '{templateFile}' using deployment name '{deploymentName}'.");

    var templateContents = System.IO.File.ReadAllText(templateFile);
    var templateParametersJson = ToParameterJson(templateParameters);
    context.Information($"Template parameters JSON: {templateParametersJson}");
    var parametersFile = genDir + context.File("template_parameters.json");
    System.IO.File.WriteAllText(parametersFile, templateParametersJson);

    context.Information($"Validating template '{templateFile}'.");
    var exitCode = context.StartProcess(
        "az",
        new ProcessSettings
        {
            Arguments = $"group deployment validate --resource-group {resourceGroupName} --template-file {templateFile} --parameters @{parametersFile}",
        });

    if (exitCode != 0)
    {
        context.Error($"Unexpected exit code when validating deployment: {exitCode}");
        return null;
    }

    context.Information($"Deploying template '{templateFile}'.");
    exitCode = context.StartProcess(
        "az",
        new ProcessSettings
        {
            Arguments = $"group deployment create --resource-group {resourceGroupName} --template-file {templateFile} --parameters @{parametersFile}",
            RedirectStandardOutput = true,
        },
        out var redirectedStandardOutput);

    if (exitCode != 0)
    {
        context.Error($"Unexpected exit code when validating deployment: {exitCode}");
        return null;
    }

    var json = redirectedStandardOutput
        .Aggregate(
            new StringBuilder(),
            (acc, next) => acc.Append(next),
            x => x.ToString());
    context.Information($"JSON output was: {json}");
    return JObject.Parse(json);
}

private static async Task<string> BuildAndDeployService(
    ICakeContext context,
    string acrLoginServer,
    string serviceName,
    DirectoryPath srcDir,
    ConvertableFilePath dockerfilePath,
    ConvertableFilePath kubernetesFilePath,
    string sha,
    int port,
    string environment,
    string resourceGroup,
    string seqServerUrl,
    string seqApiKey,
    string cosmosConnectionString,
    string serviceBusConnectionString,
    string storageConnectionString)
{
    context.Information($"Building and deploying service '{serviceName}'.");

    // 1. Docker build the service
    context.Information($"Building Docker image from file '{dockerfilePath}'.");
    var tag = $"{acrLoginServer}/{serviceName}:{DateTime.UtcNow.ToString("yyyyMMddHHmmss")}_{sha}";
    var arguments = $"build --file {context.MakeAbsolute(dockerfilePath)} --tag {tag} .";
    var exitCode = context.StartProcess(
        "docker",
        new ProcessSettings
        {
            Arguments = arguments,
            WorkingDirectory = srcDir,
        });

    if (exitCode != 0)
    {
        context.Error($"Unexpected exit code from docker build: {exitCode}");
        return null;
    }

    // 2. Push Docker image to ACR
    context.Information($"Pushing Docker image using tag '{tag}'.");
    exitCode = context.StartProcess(
        "docker",
        new ProcessSettings
        {
            Arguments = $"push {tag}",
        });

    if (exitCode != 0)
    {
        context.Error($"Unexpected exit code from docker push: {exitCode}");
        return null;
    }

    // 3. Generate kubernetes.yaml (put it in gen dir)
    context.Information($"Generating Kubernetes configuration to file '{kubernetesFilePath}'.");
    var kubernetesConfig = GetKubernetesConfig(
        serviceName,
        tag,
        port,
        environment,
        resourceGroup,
        seqServerUrl,
        seqApiKey,
        cosmosConnectionString,
        serviceBusConnectionString,
        storageConnectionString);
    System.IO.File.WriteAllText(kubernetesFilePath, kubernetesConfig);

    // 4. Deploy the service to Kubernetes
    context.Information("Deploying to Kubernetes.");
    exitCode = context.StartProcess(
        "kubectl",
        new ProcessSettings
        {
            Arguments = $"apply -f {kubernetesFilePath}",
        });

    if (exitCode != 0)
    {
        context.Error($"Unexpected exit code from kubectl apply: {exitCode}");
        return null;
    }

    // 5. Wait for service to become available
    context.Information($"Waiting for service '{serviceName}' to become available.");

    while (true)
    {
        exitCode = context.StartProcess(
            "kubectl",
            new ProcessSettings
            {
                Arguments = $"get service {serviceName} --output=json",
                RedirectStandardOutput = true,
            },
            out var redirectedStandardOutput);

        if (exitCode != 0)
        {
            context.Error($"Unexpected exit code from kubectl apply: {exitCode}");
            return null;
        }

        var json = redirectedStandardOutput
            .Aggregate(
                new StringBuilder(),
                (acc, next) => acc.Append(next),
                x => x.ToString());
        var jobject = JObject.Parse(json);
        var ip = (string)jobject["status"]?["loadBalancer"]?["ingress"]?[0]?["ip"];

        if (ip != null)
        {
            context.Information($"Service '{serviceName}' is ready and available at {ip}.");
            return ip;
        }

        context.Information($"Service '{serviceName}' is not yet ready. Waiting.");
        await System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(10));
    }
}

private static string GetKubernetesConfig(
        string serviceName,
        string imageTag,
        int port,
        string environment,
        string resourceGroup,
        string seqServerUrl,
        string seqApiKey,
        string cosmosConnectionString,
        string serviceBusConnectionString,
        string storageConnectionString) =>
    $@"apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: {serviceName}
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: {serviceName}
    spec:
      containers:
      - name: {serviceName}
        image: {imageTag}
        ports:
        - containerPort: {port}
        env:
        - name: ENVIRONMENT
          value: {environment}
        - name: RESOURCE_GROUP
          value: {resourceGroup}
        - name: SERVICE_NAME
          value: {serviceName}
        - name: GRPC_PORT
          value: ""{port}""
        - name: SEQ_SERVER_URL
          value: {seqServerUrl}
        - name: SEQ_API_KEY
          value: {seqApiKey}
        - name: COSMOS_CONNECTION_STRING
          value: {cosmosConnectionString}
        - name: SERVICE_BUS_CONNECTION_STRING
          value: {serviceBusConnectionString}
        - name: STORAGE_CONNECTION_STRING
          value: {storageConnectionString}
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
          limits:
            cpu: 500m
            memory: 1Gi
---
apiVersion: v1
kind: Service
metadata:
  name: {serviceName}
spec:
  type: LoadBalancer
  ports:
  - port: {port}
  selector:
    app: {serviceName}";

// Convert a dictionary to the appropriate parameter JSON for input to an ARM template deployment.
private static string ToParameterJson(IDictionary<string, object> parameters)
{
    JObject result = new JObject();

    foreach (var parameter in parameters)
    {
        var parameterToken = new JObject();

        if (parameter.Value == null)
        {
            parameterToken.Add("value", JValue.CreateNull());
        }
        else
        {
            parameterToken.Add("value", JToken.FromObject(parameter.Value));
        }

        result.Add(parameter.Key, parameterToken);
    }

    return result.ToString(Newtonsoft.Json.Formatting.None);
}

private static string GenerateRandomString(
    int length,
    bool? includeUpper = true,
    bool? includeLower = true,
    bool? includeNumeric = true,
    bool? includeSpecial = true,
    int? seed = null)
{
    var enforcedCount = 0;

    if (includeUpper == true)
    {
        ++enforcedCount;
    }

    if (includeLower == true)
    {
        ++enforcedCount;
    }

    if (includeNumeric == true)
    {
        ++enforcedCount;
    }

    if (includeSpecial == true)
    {
        ++enforcedCount;
    }

    if (enforcedCount > length)
    {
        throw new ArgumentException($"Number of enforced characters ({enforcedCount}) exceeds requested length ({length}).");
    }

    var builder = new StringBuilder();
    var random = seed == null ? new Random() : new Random(seed.Value);
    var hasUpper = false;
    var hasLower = false;
    var hasNumeric = false;
    var hasSpecial = false;

    for (int i = 0; i < length - enforcedCount; i++)
    {
        var ch = AppendRandomChar();

        hasUpper = hasUpper || char.IsUpper(ch);
        hasLower = hasLower || char.IsLower(ch);
        hasNumeric = hasNumeric || char.IsNumber(ch);
        hasSpecial = hasSpecial || char.IsSymbol(ch) || char.IsPunctuation(ch);
    }

    if (includeUpper == true && !hasUpper)
    {
        var ch = Convert.ToChar(65 + random.Next(26));
        builder.Insert(random.Next(builder.Length), ch);
    }

    if (includeLower == true && !hasLower)
    {
        var ch = Convert.ToChar(97 + random.Next(26));
        builder.Insert(random.Next(builder.Length), ch);
    }

    if (includeNumeric == true && !hasNumeric)
    {
        var ch = Convert.ToChar(48 + random.Next(10));
        builder.Insert(random.Next(builder.Length), ch);
    }

    if (includeSpecial == true && !hasSpecial)
    {
        var ch = Convert.ToChar(33 + random.Next(15));
        builder.Insert(random.Next(builder.Length), ch);
    }

    while (builder.Length < length)
    {
        AppendRandomChar();
    }

    return builder.ToString();

    char AppendRandomChar()
    {
        char @char;

        do
        {
            @char = Convert.ToChar(33 + random.Next(94));
        }
        while ((char.IsUpper(@char) && includeUpper == false) ||
            (char.IsLower(@char) && includeLower == false) ||
            (char.IsNumber(@char) && includeNumeric == false) ||
            ((char.IsSymbol(@char) || char.IsPunctuation(@char)) && includeSpecial == false));

        builder.Append(@char);
        return @char;
    }
}

private void DeployLocally(ConvertableFilePath sourceFile, ConvertableFilePath targetFile = null)
{
    if (deployLocally && executingOnBitrise)
    {
        targetFile = (targetFile ?? sourceFile);
        var targetFileName = targetFile.Path.GetFilename();
        var targetPath = localDeployDir + targetFileName;
        Information("Copying file '{0}' to '{1}'.", sourceFile, targetPath);
        CopyFile(sourceFile, targetPath);
    }
}

private sealed class DeploymentData
{
    public JObject DeploymentOutputs
    {
        get;
        set;
    }

    public string ClusterFQDN => GetStringValueForOutput("clusterFQDN");

    public string ApiUrl
    {
        get;
        set;
    }

    public string DatabaseConnectionString => GetStringValueForOutput("databaseAccountConnectionString");

    public string ServiceBusConnectionString => GetStringValueForOutput("serviceBusConnectionString");

    public string UserStorageAccountConnectionString => GetStringValueForOutput("userStorageAccountConnectionString");

    private string GetStringValueForOutput(string outputName)
    {
        if (DeploymentOutputs == null)
        {
            throw new InvalidOperationException($"The {nameof(DeploymentOutputs)} property is not yet set, so cannot retrieve value for output named '{outputName}'.");
        }

        var value = DeploymentOutputs[outputName];

        if (value == null)
        {
            throw new InvalidOperationException($"No value named '{outputName}' was found in the deployment outputs.");
        }

        return (string)value["value"];
    }
}

public sealed class DeploymentFailedException : Exception
{
    public DeploymentFailedException()
        : base("Deployment failed.")
    {
    }
}

RunTarget(Argument("target", "Root"));

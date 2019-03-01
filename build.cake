#addin nuget:?package=Cake.Git&version=0.19.0
#addin nuget:?package=Newtonsoft.Json&version=11.0.2

// TODO: should be able to load dependencies without having to manually specify them, but it isn't currently working.
// See https://cakebuild.net/docs/fundamentals/preprocessor-directives.
// As a result, there are far more packages listed here than should be required.
#addin nuget:?package=Microsoft.Azure.KeyVault&version=3.0.2
#addin nuget:?package=Microsoft.Azure.Management.AppService.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Batch.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.BatchAI.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Cdn.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Compute.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.ContainerInstance.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.ContainerRegistry.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.ContainerService.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.CosmosDB.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Dns.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.EventHub.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Graph.RBAC.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.KeyVault.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Locks.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Msi.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Monitor.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Network.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Redis.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.ResourceManager.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Search.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.ServiceBus.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Storage.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.Sql.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.Azure.Management.TrafficManager.Fluent&version=1.18.0
#addin nuget:?package=Microsoft.IdentityModel.Clients.ActiveDirectory&version=4.4.2
#addin nuget:?package=Microsoft.IdentityModel.Logging&version=5.3.0
#addin nuget:?package=Microsoft.IdentityModel.Tokens&version=5.3.0
#addin nuget:?package=Microsoft.Rest.ClientRuntime&version=2.3.18
#addin nuget:?package=Microsoft.Rest.ClientRuntime.Azure&version=3.3.18
#addin nuget:?package=Microsoft.Rest.ClientRuntime.Azure.Authentication&version=2.3.6
#addin nuget:?package=Microsoft.ServiceFabric.Client.Http&version=2.0.0-preview1
#addin nuget:?package=WindowsAzure.Storage&version=9.3.3

using System;
using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using Microsoft.Azure.KeyVault;
using Microsoft.Azure.KeyVault.Models;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.KeyVault.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;
using Microsoft.ServiceFabric.Client;
using Microsoft.ServiceFabric.Client.Exceptions;
using Microsoft.ServiceFabric.Common;
using Microsoft.ServiceFabric.Common.Security;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

var gitBranch = GitBranchCurrent(".");

// Parameters.
var bitriseBuildNumber = int.Parse(EnvironmentVariable("BITRISE_BUILD_NUMBER") ?? "-1");
var executingOnBitrise = bitriseBuildNumber != -1;
var deployLocally = bool.Parse(EnvironmentVariable("DEPLOY_LOCALLY") ?? "false");
var localDeployDir = Directory(EnvironmentVariable("LOCAL_DEPLOY_DIR") ?? ".");
var region = EnvironmentVariable("REGION");
var environment = EnvironmentVariable("ENVIRONMENT");
var subscriptionId = EnvironmentVariable("AZURE_SUBSCRIPTION_ID");
var clientId = EnvironmentVariable("AZURE_CLIENT_ID");
var tenantId = EnvironmentVariable("AZURE_TENANT_ID");
var deploymentsStorageAccountConnectionString = EnvironmentVariable("AZURE_STORAGE_ACCOUNT_CONNECTION_STRING");
var vmInstanceCount = int.Parse(EnvironmentVariable("VM_INSTANCE_COUNT") ?? "1");
var seqServerUrl = EnvironmentVariable("SEQ_SERVER_URL");
var seqApiKey = EnvironmentVariable("SEQ_API_KEY");
var configuration = "Release";

// Paths.
var srcDir = Directory("src/inf_server");
var pkgDir = Directory("pkg") + Directory(configuration);
var zippedPackageFile = Directory("pkg") + File("package.sfpkg");
var pfxFile = File("Azure.pfx");
var infrastructureTemplateFile = srcDir + File("arm_infrastructure.json");
var applicationTemplateFile = srcDir + File("arm_service_fabric_app.json");
var solutionFile = srcDir + File("server.sln");

// Variables.
var isEphemeral = environment == "ephemeral";
var resourceNamePrefix = $"inf-{environment}";
var resourceGroupName = $"{resourceNamePrefix}{(isEphemeral ? "-" + GenerateRandomString(8, includeSpecial: false, includeUpper: false) : "")}";
var keyVaultName = $"{resourceNamePrefix}-KeyVault";
var certificateName = $"{resourceNamePrefix}-Certificate";

if (!FileExists(pfxFile))
{
    throw new Exception($"The PFX file, '{pfxFile}', used to authenticate with Azure could not be found.");
}

// The certificate used for CI/automation (not to be confused with the certificate generated below and used to secure nodes in the cluster).
var automationCertificate = new X509Certificate2(pfxFile);

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
            var credentials = CreateAzureCredentials(context, clientId, tenantId, automationCertificate);
            var azure = CreateAuthenticatedAzureClient(context, credentials);

            // Cake teardown does not support asynchronous code, so we use synchronous deletion here.
            azure
                .ResourceGroups
                .DeleteByName(resourceGroupName);
        }
    });

Task("Clean")
    .Does(() => CleanDirectories(pkgDir));

Task("Deploy")
    .IsDependentOn("Clean")
    .Does(
        async (context) =>
        {
            var credentials = CreateAzureCredentials(context, clientId, tenantId, automationCertificate);
            var azure = CreateAuthenticatedAzureClient(context, credentials);

            // 1. Deploy the ARM infrastructure template.
            var resourceManagementClient = CreateResourceManagementClient(credentials, subscriptionId);
            var resourceGroup = await EnsureResourceGroup(context, azure, resourceGroupName, region);
            var keyVault = await EnsureKeyVault(context, azure, keyVaultName, resourceGroupName, region);
            var selfSignedCertificatePassword = GenerateRandomString(16);
            var selfSignedCertificate = CreateSelfSignedServerCertificate(context, certificateName, selfSignedCertificatePassword);
            var certificateBundle = await EnsureCertificate(
                context,
                azure,
                keyVault,
                selfSignedCertificate,
                certificateName,
                selfSignedCertificatePassword);

            var passwordSeed = BitConverter.ToInt32(certificateBundle.X509Thumbprint, 0);
            var rdpPassword = GenerateRandomString(16, seed: passwordSeed);
            context.Information($"RDP password is '{rdpPassword}'.");
            var escapedRdpPassword = rdpPassword
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"");

            var certificateThumbprint = GenerateThumbprintFor(certificateBundle.X509Thumbprint);
            var infrastructureDeployment = await DeployARMTemplate(
                context,
                resourceManagementClient,
                certificateBundle,
                resourceGroupName,
                resourceNamePrefix,
                infrastructureTemplateFile,
                new Dictionary<string, object>
                {
                    { "resourcePrefix", resourceNamePrefix },
                    { "certificateThumbprint", certificateThumbprint },
                    { "automationCertificateThumbprint", automationCertificate.Thumbprint },
                    { "certificateUrlValue", certificateBundle.SecretIdentifier.Identifier },
                    { "sourceVaultResourceId", keyVault.Id },
                    { "rdpPassword", escapedRdpPassword },
                    { "vmInstanceCount", vmInstanceCount },
                });

            var outputs = ((JObject)infrastructureDeployment.Properties.Outputs);

            context.Data.Get<DeploymentData>().DeploymentOutputs = outputs;

            // 2. Build and upload the Service Fabric application.
            Information("Restoring packages.");
            DotNetCoreRestore(solutionFile);

            void PublishService(string serviceName)
            {
                Information($"Publishing {serviceName} service.");
                var serviceDir = srcDir + Directory(serviceName);
                var servicePkgDir = pkgDir + Directory($"{serviceName}Pkg");
                DotNetCorePublish(
                    serviceDir,
                    new DotNetCorePublishSettings
                    {
                        Configuration = configuration,
                        NoRestore = true,
                        OutputDirectory = servicePkgDir + Directory("Code"),
                        SelfContained = false,
                    });
                CopyFiles(GetFiles((serviceDir + Directory("PackageRoot")).ToString() + "/**/*"), servicePkgDir, preserveFolderStructure: true);
            }

            Information("Publishing services.");
            PublishService("API");
            PublishService("InvitationCodes");
            PublishService("Mapping");
            PublishService("Offers");
            PublishService("Users");

            var sourceApplicationManifest = srcDir + Directory("server/ApplicationPackageRoot") + File("ApplicationManifest.xml");
            var destinationApplicationManifest =  pkgDir + File("ApplicationManifest.xml");
            var applicationParameters = srcDir + Directory("server/ApplicationParameters") + File($"{environment}.xml");
            var updatedApplicationManifestDocument = SubstituteApplicationParameters(
                sourceApplicationManifest,
                applicationParameters,
                new Dictionary<string, string>
                {
                    { "SEQ_SERVER_URL", seqServerUrl },
                    { "SEQ_API_KEY", seqApiKey },
                    { "USER_STORAGE_ACCOUNT_CONNECTION_STRING", (string)outputs["userStorageAccountConnectionString"]["value"] },
                    { "DATABASE_ACCOUNT_CONNECTION_STRING", (string)outputs["databaseAccountConnectionString"]["value"] },
                    { "SERVICE_BUS_CONNECTION_STRING", (string)outputs["serviceBusConnectionString"]["value"] },
                });

            Information("Application manifest: {0}", updatedApplicationManifestDocument.ToString());
            updatedApplicationManifestDocument.Save(destinationApplicationManifest);

            Information("Zipping deployment package.");
            Zip(pkgDir, zippedPackageFile);

            Information("Uploading deployment package to Azure storage.");

            if (!CloudStorageAccount.TryParse(deploymentsStorageAccountConnectionString, out var deploymentsStorageAccount))
            {
                throw new Exception($"Azure storage account connection string '{deploymentsStorageAccountConnectionString}' is not valid.");
            }

            var cloudBlobClient = deploymentsStorageAccount.CreateCloudBlobClient();

            var storageContainerName = $"{resourceNamePrefix}-{DateTime.UtcNow.ToString("yyyyMMddHHmmss")}-{GenerateRandomString(4, includeSpecial: false, includeUpper: false)}";
            Information($"Creating storage container with name '{storageContainerName}'.");
            var cloudBlobContainer = cloudBlobClient.GetContainerReference(storageContainerName);
            await cloudBlobContainer.CreateAsync(BlobContainerPublicAccessType.Blob, new BlobRequestOptions(), new OperationContext());
            Uri packageUri;

            try
            {
                Information("Uploading package as blob...");
                var cloudBlockBlob = cloudBlobContainer.GetBlockBlobReference(System.IO.Path.GetFileName(zippedPackageFile));
                await cloudBlockBlob.UploadFromFileAsync(zippedPackageFile);
                packageUri = cloudBlockBlob.Uri;
                Information($"Uploaded, available at URI '{packageUri}'.");

                // 3. Deploy the application ARM template.
                var applicationManifestFile = srcDir + Directory("server/ApplicationPackageRoot") + File("ApplicationManifest.xml");
                var applicationVersion = XmlPeek(
                    applicationManifestFile,
                    "/fabric:ApplicationManifest/@ApplicationTypeVersion",
                    new XmlPeekSettings
                    {
                        Namespaces = new Dictionary<string, string>
                        {
                            { "fabric", "http://schemas.microsoft.com/2011/01/fabric" },
                        },
                    });
                Information($"Determined application version to be '{applicationVersion}'");

                var applicationDeployment = await DeployARMTemplate(
                    context,
                    resourceManagementClient,
                    certificateBundle,
                    resourceGroupName,
                    resourceNamePrefix,
                    applicationTemplateFile,
                    new Dictionary<string, object>
                    {
                        { "resourcePrefix", resourceNamePrefix },
                        { "appVersion", applicationVersion },
                        { "appPackageUri", packageUri },
                    });
            }
            finally
            {
                Information($"Deleting storage container with name '{storageContainerName}'.");
                await cloudBlobContainer.DeleteAsync();
            }

            Information($"Done");
        });

// Task("UnitTest")
//     .Does(
//         () =>
//         {
//             // TODO: look into best way to run unit tests
//             var settings = new DotNetCoreTestSettings
//             {
//                 Configuration = configuration,
//             };
//             DotNetCoreTest(srcDir + Directory("Utility") + File("Utility.csproj"), settings);
//         });

Task("Build-Integration-Tests")
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
            Information($"Server URL is '{deploymentData.ServerUrl}', database connection string is '{deploymentData.DatabaseConnectionString}'.");

            var integrationTestAssembly = srcDir + Directory("IntegrationTests/bin/Release/netcoreapp2.1/") + File("IntegrationTests.dll");
            var arguments = new ProcessArgumentBuilder();
            arguments
                .Append(deploymentData.ServerUrl)
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

private static AzureCredentials CreateAzureCredentials(
    ICakeContext context,
    string clientId,
    string tenantId,
    X509Certificate2 automationCertificate)
{
    context.Information($"Creating Azure credentials for client ID '{clientId}', tenant ID '{tenantId}'.");

    var credentials = SdkContext
        .AzureCredentialsFactory
        .FromServicePrincipal(
            clientId,
            automationCertificate,
            tenantId,
            AzureEnvironment.AzureGlobalCloud);

    context.Information("Credentials created.");
    return credentials;
}

private static IAzure CreateAuthenticatedAzureClient(ICakeContext context, AzureCredentials credentials)
{
    context.Information($"Creating authenticated Azure client.");

    var authenticated = Azure
        .Configure()
        .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
        .Authenticate(credentials);
    var azure = authenticated
        .WithDefaultSubscription();

    // TODO: cannot get this to work (forbidden) because CI SP mustn't have sufficient access, even though I tried with Owner access at Subscription level :/
    // Apparently this requires the SP have Directory permissions, which is insanely convoluted to set up: https://lnx.azurewebsites.net/directory-roles-for-azure-ad-service-principal/
    // Also, this might be an alternative approach that bypasses the above altogether: https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview
//    var developerGroup = await authenticated
//        .ActiveDirectoryGroups
//        .GetByNameAsync("Developer");

    return azure;
}

private static ResourceManagementClient CreateResourceManagementClient(AzureCredentials credentials, string subscriptionId)
{
    var restClient = RestClient
        .Configure()
        .WithEnvironment(AzureEnvironment.AzureGlobalCloud)
        .WithCredentials(credentials)
        .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
        .Build();

    var resourceManagementClient = new ResourceManagementClient(restClient)
    {
        SubscriptionId = subscriptionId,
    };

    return resourceManagementClient;
}

private static async Task<IResourceGroup> EnsureResourceGroup(ICakeContext context, IAzure azure, string name, string region)
{
    context.Information($"Ensuring resource group '{name}' exists.");
    var exists = await azure
        .ResourceGroups
        .ContainAsync(name);
    IResourceGroup result;

    if (exists)
    {
        context.Information($"Resource group '{name}' already exists, so retrieving it.");
        result = await azure
            .ResourceGroups
            .GetByNameAsync(name);
    }
    else
    {
        context.Information($"Resource group '{name}' does not yet exist, so creating it.");
        result = await azure
            .ResourceGroups
            .Define(name)
            .WithRegion(region)
            .CreateAsync();
        context.Information($"Resource group '{name}' created in region '{region}'.");
    }

    return result;
}

private static async Task<IVault> EnsureKeyVault(ICakeContext context, IAzure azure, string name, string resourceGroupName, string region)
{
    context.Information($"Ensuring key vault '{name}' exists.");
    var existing = await azure
        .Vaults
        .GetByResourceGroupAsync(resourceGroupName, name);
    IVault result;

    if (existing == null)
    {
        context.Information($"Key vault '{name}' does not yet exist, so creating it.");
        result = await azure
            .Vaults
            .Define(name)
            .WithRegion(region)
            .WithExistingResourceGroup(resourceGroupName)
            .DefineAccessPolicy()
            // TODO: Would make more sense at the group level if I could do so.
            //.ForGroup(developerGroup)
            .ForServicePrincipal("CI-Service-Principal")
            // TODO: Could be locked down further.
            .AllowCertificateAllPermissions()
            .Attach()
            .WithDeploymentEnabled()
            .WithTemplateDeploymentEnabled()
            .CreateAsync();
        context.Information($"Key vault '{name}' created in region '{region}'.");
    }
    else
    {
        context.Information($"Key vault '{name}' already exists.");
        result = existing;
    }

    return result;
}

private static X509Certificate2 CreateSelfSignedServerCertificate(ICakeContext context, string name, string password)
{
    var builder = new SubjectAlternativeNameBuilder();
    builder.AddIpAddress(IPAddress.Loopback);
    builder.AddIpAddress(IPAddress.IPv6Loopback);
    builder.AddDnsName("localhost");
    builder.AddDnsName(Environment.MachineName);

    var distinguishedName = new X500DistinguishedName($"CN={name}");

    using (var rsa = RSA.Create(2048))
    {
        var request = new CertificateRequest(distinguishedName, rsa, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        request.CertificateExtensions.Add(new X509KeyUsageExtension(X509KeyUsageFlags.DataEncipherment | X509KeyUsageFlags.KeyEncipherment | X509KeyUsageFlags.DigitalSignature, false));
        request.CertificateExtensions.Add(new X509EnhancedKeyUsageExtension(new OidCollection { new Oid("1.3.6.1.5.5.7.3.1") }, false));
        request.CertificateExtensions.Add(builder.Build());

        var certificate = request.CreateSelfSigned(new DateTimeOffset(DateTime.UtcNow.AddDays(-1)), new DateTimeOffset(DateTime.UtcNow.AddDays(3650)));
        // Not supported on Unix. See https://github.com/dotnet/corefx/issues/29061.
        //certificate.FriendlyName = name;

        var result = new X509Certificate2(certificate.Export(X509ContentType.Pfx, password), password, X509KeyStorageFlags.MachineKeySet | X509KeyStorageFlags.Exportable);
        return result;
    }
}

private static async Task<CertificateBundle> EnsureCertificate(
    ICakeContext context,
    IAzure azure,
    IVault vault,
    X509Certificate2 certificate,
    string certificateName,
    string certificatePassword)
{
    context.Information($"Ensuring certificate with name '{certificateName}' exists.");

    CertificateBundle result;
    CertificateBundle existingCertificate = null;

    try
    {
        existingCertificate = await vault
            .Client
            .GetCertificateAsync(vault.VaultUri, certificateName);
    }
    catch (KeyVaultErrorException ex) when (ex.Response.StatusCode == HttpStatusCode.NotFound)
    {
        // Certificate was not found.
    }

    if (existingCertificate == null)
    {
        context.Information($"Certificate with name '{certificateName}', thumbprint '{certificate.Thumbprint}', password '{certificatePassword}' does not yet exist in vault with name '{vault.Name}' - importing it.");
        var certificates = new X509Certificate2Collection(certificate);
        result = await vault
            .Client
            .ImportCertificateAsync(vault.VaultUri, certificateName, certificates, null);
        context.Information($"Certificate with name '{certificateName}' was imported into vault with name '{vault.Name}'.");
    }
    else
    {
        result = existingCertificate;
        context.Information($"Certificate with name '{certificateName}', thumbprint '{GenerateThumbprintFor(result.X509Thumbprint)}' already exists in vault with name '{vault.Name}'.");
    }

    return result;
}

private static async Task<DeploymentExtendedInner> DeployARMTemplate(
    ICakeContext context,
    ResourceManagementClient resourceManagementClient,
    CertificateBundle certificateBundle,
    string resourceGroupName,
    string resourceNamePrefix,
    ConvertableFilePath templateFile,
    IDictionary<string, object> templateParameters)
{
    var deploymentName = $"{resourceNamePrefix}-{System.IO.Path.GetFileNameWithoutExtension(templateFile)}";
    context.Information($"Deploying ARM template '{templateFile}' using deployment name '{deploymentName}'.");

    var templateContents = System.IO.File.ReadAllText(templateFile);

    // The RDP password should never be used in a Service Fabric cluster, but we need to assign one all the same.
    // We also need to ensure it is the same password if the cluster is being re-deployed, since the admin password cannot be updated.
    // We do that by seeding the RNG from the thumbprint of the certificate being used in the environment.
    var passwordSeed = BitConverter.ToInt32(certificateBundle.X509Thumbprint, 0);
    var rdpPassword = GenerateRandomString(16, seed: passwordSeed);
    context.Information($"RDP password is '{rdpPassword}'.");
    var escapedRdpPassword = rdpPassword
        .Replace("\\", "\\\\")
        .Replace("\"", "\\\"");

    var certificateThumbprint = GenerateThumbprintFor(certificateBundle.X509Thumbprint);
    var templateParametersJson = ToParameterJson(templateParameters);
    context.Information($"Template parameters JSON: {templateParametersJson}");

    // TODO: have to use JObjects below otherwise it fails.
    var properties = new DeploymentPropertiesInner
    {
        Template = JObject.Load(new JsonTextReader(new StringReader(templateContents))),
        // TODO: should this be complete so that deprecated resources are cleaned up?
        Mode = DeploymentMode.Incremental,
        Parameters = JObject.Load(new JsonTextReader(new StringReader(templateParametersJson))),
    };

    var validationResults = await resourceManagementClient
        .Deployments
        .ValidateAsync(resourceGroupName, deploymentName, properties);

    if (validationResults.Error != null)
    {
        var message = DumpError(validationResults.Error);
        throw new Exception(message);
    }

    context.Information("Template successfully validated.");

    var deploymentInner = await resourceManagementClient
        .Deployments
        .BeginCreateOrUpdateAsync(resourceGroupName, deploymentName, properties);
    context.Information("Deployment instigated.");

    while (true)
    {
        var exists = await resourceManagementClient
            .Deployments
            .CheckExistenceAsync(resourceGroupName, deploymentName);

        if (exists)
        {
            context.Debug("Deployment exists.");
            break;
        }

        context.Debug("Deployment does not yet exist - waiting.");
        await System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(2));
    }

    while (true)
    {
        var deployment = await resourceManagementClient
            .Deployments
            .GetAsync(resourceGroupName, deploymentName);
        var state = deployment.Properties.ProvisioningState;

        if (state == "Succeeded")
        {
            context.Information("Deployment succeeded.");
            return deployment;
        }
        else if (state == "Failed")
        {
            throw new DeploymentFailedException();
        }

        context.Debug($"Deployment is in state '{state}' - waiting.");
        await System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(10));
    }
}

// Convert a dictionary to the appropriate parameter JSON for input to an ARM template deployment.
private static string ToParameterJson(IDictionary<string, object> parameters)
{
    JObject result = new JObject();

    foreach (var parameter in parameters)
    {
        var parameterToken = new JObject();
        parameterToken.Add("value", JToken.FromObject(parameter.Value));
        result.Add(parameter.Key, parameterToken);
    }

    return result.ToString();
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

private static string GenerateThumbprintFor(byte[] bytes)
{
    var builder = new StringBuilder();

    foreach (var b in bytes)
    {
        builder.Append(b.ToString("X2"));
    }

    return builder.ToString();
}

private static string DumpError(ResourceManagementErrorWithDetails error)
{
    void DumpDetailsRecursive(ResourceManagementErrorWithDetails currentError, int indentLevel, StringBuilder sb)
    {
        var indent = new string(' ', indentLevel * 2);

        sb
            .Append(indent)
            .Append(currentError.Code)
            .Append(": ")
            .Append(currentError.Target)
            .Append(": ")
            .Append(currentError.Message)
            .AppendLine();

        if (currentError.Details != null && currentError.Details.Count > 0)
        {
            sb
                .Append(indent)
                .Append("Details:")
                .AppendLine();

            foreach (var childError in currentError.Details)
            {
                DumpDetailsRecursive(childError, indentLevel + 1, sb);
            }
        }
    }

    var dumpedError = new StringBuilder();
    DumpDetailsRecursive(error, 0, dumpedError);
    return dumpedError.ToString();
}

private static XDocument SubstituteApplicationParameters(
    ConvertableFilePath applicationManifestFile,
    ConvertableFilePath applicationParametersFile,
    Dictionary<string, string> substitutions)
{
    var applicationManifest = XDocument.Load(applicationManifestFile);
    var applicationParameters = XDocument.Load(applicationParametersFile);
    var nameTable = new NameTable();
    var namespaceManager = new XmlNamespaceManager(nameTable);
    namespaceManager.AddNamespace("sf", "http://schemas.microsoft.com/2011/01/fabric");

    var source = applicationParameters.XPathSelectElement("/sf:Application/sf:Parameters", namespaceManager);
    var sourceParameters = source.XPathSelectElements("sf:Parameter", namespaceManager);
    var destination = applicationManifest.XPathSelectElement("/sf:ApplicationManifest/sf:Parameters", namespaceManager);

    foreach (var sourceParameter in sourceParameters)
    {
        var valueAttribute = sourceParameter.Attribute("Value");
        var value = valueAttribute.Value;

        foreach (var substitution in substitutions)
        {
            value = value.Replace("$" + substitution.Key, substitution.Value);
        }

        valueAttribute.Remove();
        sourceParameter.SetAttributeValue("DefaultValue", value);
    }

    destination.ReplaceWith(source);
    return applicationManifest;
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

    public JToken ClusterProperties
    {
        get
        {
            var clusterProperties = DeploymentOutputs["clusterProperties"];

            if (clusterProperties == null)
            {
                throw new InvalidOperationException("No clusterProperties property found in deployment outputs.");
            }

            return clusterProperties["value"];
        }
    }

    public Uri ClusterManagementEndpoint
    {
        get
        {
            var managementEndpoint = ClusterProperties["managementEndpoint"];

            if (managementEndpoint == null)
            {
                throw new InvalidOperationException("No managementEndpoint property found in cluster properties.");
            }

            return new Uri(managementEndpoint.Value<string>());
        }
    }

    public string ServerUrl => ClusterManagementEndpoint.Host + ":9026";

    public string DatabaseConnectionString
    {
        get
        {
            var userStorageAccountConnectionString = DeploymentOutputs["databaseAccountConnectionString"];

            if (userStorageAccountConnectionString == null)
            {
                throw new InvalidOperationException("No databaseAccountConnectionString property found in deployment outputs.");
            }

            return (string)userStorageAccountConnectionString["value"];
        }
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

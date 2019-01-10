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

using System;
using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Azure.KeyVault;
using Microsoft.Azure.KeyVault.Models;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.KeyVault.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

var gitBranch = GitBranchCurrent(".");

// Parameters.
var region = EnvironmentVariable("REGION");
var environment = EnvironmentVariable("ENVIRONMENT");
var subscriptionId = EnvironmentVariable("AZURE_SUBSCRIPTION_ID");
var clientId = EnvironmentVariable("AZURE_CLIENT_ID");
var tenantId = EnvironmentVariable("AZURE_TENANT_ID");
var vmInstanceCount = EnvironmentVariable("VM_INSTANCE_COUNT") ?? "1";

// Variables.
var resourceNamePrefix = $"inf-{environment}";
var resourceGroupName = resourceNamePrefix;
var keyVaultName = $"{resourceNamePrefix}-KeyVault";
var certificateName = $"{resourceNamePrefix}-Certificate";

// Paths.
var srcDir = Directory("src");
var templateFile = srcDir + File("arm_template.json");
var pfxFile = File("Azure.pfx");

Task("Deploy")
    .Does(
        async (context) =>
        {
            Information($"Starting deployment against git branch '{gitBranch.CanonicalName}'.");
            Information($"Region '{region}', environment '{environment}', subscription ID '{subscriptionId}', client ID '{clientId}', tenant ID '{tenantId}'.");

            if (!FileExists(pfxFile))
            {
                throw new Exception($"The PFX file, '{pfxFile}', used to authenticate with Azure could not be found.");
            }

            // Deploy the ARM template describing the infrastructure requirements of our Service Fabric application.
            var credentials = CreateAzureCredentials(context, clientId, tenantId, pfxFile);
            var azure = CreateAuthenticatedAzureClient(context, credentials);
            var resourceGroup = await EnsureResourceGroup(context, azure, resourceGroupName, region);
            var keyVault = await EnsureKeyVault(context, azure, keyVaultName, resourceGroupName, region);
            var selfSignedCertificatePassword = GenerateRandomPassword(8);
            var selfSignedCertificate = CreateSelfSignedServerCertificate(context, certificateName, selfSignedCertificatePassword);
            var certificateBundle = await EnsureCertificate(
                context,
                azure,
                keyVault,
                selfSignedCertificate,
                certificateName,
                selfSignedCertificatePassword);
            await DeployResourceGroup(
                context,
                azure,
                credentials,
                templateFile,
                subscriptionId,
                resourceGroupName,
                resourceNamePrefix,
                certificateBundle,
                vmInstanceCount,
                keyVault);

            // Build and deploy the Service Fabric application itself.
        });

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
    ConvertableFilePath pfxFile)
{
    context.Information($"Creating Azure credentials for client ID '{clientId}', tenant ID '{tenantId}'.");

    // The certificate used for CI/automation (not to be confused with the certificate used to secure nodes in the cluster).
    var automationCertificate = new X509Certificate2(pfxFile);
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
        context.Information($"Certificate with name '{certificateName}', thumbprint '{certificate.Thumbprint}' does not yet exist in vault with name '{vault.Name}' - importing it.");
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

private static async Task<DeploymentExtendedInner> DeployResourceGroup(
    ICakeContext context,
    IAzure azure,
    AzureCredentials credentials,
    ConvertableFilePath templateFile,
    string subscriptionId,
    string resourceGroupName,
    string resourceNamePrefix,
    CertificateBundle certificateBundle,
    string vmInstanceCount,
    IVault vault)
{
    context.Information($"Deploying resource template with deployment name '{resourceNamePrefix}'.");

    var restClient = RestClient
        .Configure()
        .WithEnvironment(AzureEnvironment.AzureGlobalCloud)
        .WithCredentials(credentials)
        .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
        .Build();

    using (var resourceManagementClient = new ResourceManagementClient(restClient))
    {
        resourceManagementClient.SubscriptionId = subscriptionId;

        var templateContents = System.IO.File.ReadAllText(templateFile);

        // The RDP password should never be used in a Service Fabric cluster, but we need to assign one all the same.
        // We also need to ensure it is the same password if the cluster is being re-deployed, since the admin password cannot be updated.
        // We do that by seeding the RNG from the thumbprint of the certificate being used in the environment.
        var passwordSeed = BitConverter.ToInt32(certificateBundle.X509Thumbprint, 0);
        var rdpPassword = GenerateRandomPassword(8, passwordSeed);
        var escapedRdpPassword = rdpPassword
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"");

        var certificateThumbprint = GenerateThumbprintFor(certificateBundle.X509Thumbprint);

        var templateParameters = $@"{{
""resourcePrefix"": {{""value"": ""{resourceNamePrefix}""}},
""certificateThumbprint"": {{""value"": ""{certificateThumbprint}""}},
""certificateUrlValue"": {{""value"": ""{certificateBundle.SecretIdentifier}""}},
""sourceVaultResourceId"": {{""value"": ""{vault.Id}""}},
""rdpPassword"": {{""value"": ""{escapedRdpPassword}""}},
""vmInstanceCount"": {{""value"": {vmInstanceCount}}},
}}";

        context.Debug($"Template parameters: {templateParameters}");

        // TODO: have to use JObjects below otherwise it fails.
        var properties = new DeploymentPropertiesInner
        {
            Template = JObject.Load(new JsonTextReader(new StringReader(templateContents))),
            // TODO: should this be complete so that deprecated resources are cleaned up?
            Mode = DeploymentMode.Incremental,
            Parameters = JObject.Load(new JsonTextReader(new StringReader(templateParameters))),
        };

        var validationResults = await resourceManagementClient
            .Deployments
            .ValidateAsync(resourceGroupName, resourceNamePrefix, properties);

        if (validationResults.Error != null)
        {
            var message = DumpError(validationResults.Error);
            throw new Exception(message);
        }

        context.Information("Template validated without error.");

        var deploymentInner = await resourceManagementClient
            .Deployments
            .BeginCreateOrUpdateAsync(resourceGroupName, resourceNamePrefix, properties);
        context.Information("Deployment instigated.");

        while (true)
        {
            var exists = await resourceManagementClient.Deployments.CheckExistenceAsync(resourceGroupName, resourceNamePrefix);

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
                .GetAsync(resourceGroupName, resourceNamePrefix);
            var state = deployment.Properties.ProvisioningState;

            if (state == "Succeeded")
            {
                context.Information("Deployment succeeded.");
                return deployment;
            }
            else if (state == "Failed")
            {
                throw new Exception("Deployment failed.");
            }

            context.Debug($"Deployment is in state '{state}' - waiting.");
            await System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(10));
        }
    }
}

private static string GenerateRandomPassword(int length, int? seed = null)
{
    var builder = new StringBuilder();
    var random = seed == null ? new Random() : new Random(seed.Value);
    char ch;

    for (int i = 0; i < length; i++)
    {
        ch = Convert.ToChar(33 + random.Next(94));
        builder.Append(ch);
    }

    return builder.ToString();
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

RunTarget(Argument("target", "Deploy"));
const { Client } = require("@microsoft/microsoft-graph-client");
const { TokenCredentialAuthenticationProvider } = require("@microsoft/microsoft-graph-client/authProviders/azureTokenCredentials");
const { ClientSecretCredential } = require("@azure/identity");
require('isomorphic-fetch');


const tenantId = process.env.microsoft_tenant_id;
const clientId = process.env.microsoft_client_id;
const clientSecret = process.env.microsoft_client_secret;

const credential = new ClientSecretCredential(tenantId, clientId, clientSecret);
const authProvider = new TokenCredentialAuthenticationProvider(credential, { scopes: ["https://graph.microsoft.com/.default"] })
const client = Client.initWithMiddleware({
	debugLogging: false,
	authProvider,
});

authProvider.getAccessToken().then((t) => {
	console.log(t)
})

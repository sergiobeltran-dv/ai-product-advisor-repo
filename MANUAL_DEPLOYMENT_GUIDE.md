# Manual Deployment Guide - AI Product Advisor Sandbox Environment

**Document Purpose**: Step-by-step instructions for manually deploying Azure infrastructure via Azure Portal

**Target Audience**: Team members without Terraform/Azure CLI access

**Estimated Time**: 2-3 hours for complete deployment

**Prerequisites**:
- Azure Portal access: https://portal.azure.com
- Contributor or Owner role on subscription: `electrorent-ai-poc-sub`
- Subscription ID: `ca9f1f9c-1617-4cfa-8f5a-55346b27c16c`

---

## ⚠️ IMPORTANT NOTES

1. **Quota Requirements**: Before starting, ensure the following quotas are approved:
   - App Service Basic (B1) tier: Minimum 1 instance
   - Azure Functions Consumption tier: Minimum 1 instance
   - Cosmos DB zone redundancy: Either approved OR disabled (see configuration)

2. **Deployment Order**: Follow the sections in order - some resources depend on others

3. **Naming Convention**: Use exact names provided to match Terraform configuration

4. **Region**: All resources deploy to **East US** unless otherwise noted

5. **Tags**: Apply these tags to ALL resources:
   - `environment`: sandbox
   - `project`: ai-product-advisor
   - `managed-by`: manual
   - `cost-center`: IT
   - `client`: electrorent
   - `purpose`: poc-testing

---

## Section 1: Resource Group (5 minutes)

### Step 1.1: Create Resource Group

1. Navigate to Azure Portal: https://portal.azure.com
2. Search for **Resource groups** in the top search bar
3. Click **+ Create**
4. Configure:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Region**: East US
5. Click **Review + create**
6. Click **Create**

✅ **Validation**: Resource group appears in the list

---

## Section 2: Networking (30 minutes)

### Step 2.1: Create Virtual Network

1. Search for **Virtual networks** in the portal
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Region**: East US
4. **IP Addresses** tab:
   - **IPv4 address space**: `10.2.0.0/16`
   - Click **+ Add subnet**:

     **Subnet 1 - App Service**:
     - Name: `sandbox-aiproductadvisor-eastus-snet`
     - Address range: `10.2.1.0/24`
     - **Subnet delegation**: Microsoft.Web/serverFarms
     - **Service endpoints**: Microsoft.Web
     - Click **Add**

     **Subnet 2 - Function App**:
     - Click **+ Add subnet** again
     - Name: `sandbox-aiproductadvisor-eastus-func-snet`
     - Address range: `10.2.2.0/24`
     - **Subnet delegation**: Microsoft.Web/serverFarms
     - **Service endpoints**: Microsoft.Web
     - Click **Add**

     **Subnet 3 - Private Endpoints**:
     - Click **+ Add subnet** again
     - Name: `sandbox-aiproductadvisor-eastus-pe-snet`
     - Address range: `10.2.3.0/24`
     - **No delegation**
     - **No service endpoints**
     - Click **Add**

5. **Security** tab: Leave defaults
6. **Tags** tab: Add standard tags (see Important Notes)
7. Click **Review + create**
8. Click **Create**

⏱️ Wait for deployment to complete (~2 minutes)

### Step 2.2: Create Network Security Groups

Create **3 NSGs** - repeat these steps 3 times with different names:

#### NSG 1: App Service NSG

1. Search for **Network security groups**
2. Click **+ Create**
3. Configure:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-app-nsg`
   - **Region**: East US
4. **Tags** tab: Add standard tags
5. Click **Review + create** → **Create**

#### NSG 2: Function NSG

Repeat above with:
- **Name**: `sandbox-aiproductadvisor-eastus-func-nsg`

#### NSG 3: Private Endpoints NSG

Repeat above with:
- **Name**: `sandbox-aiproductadvisor-eastus-pe-nsg`

### Step 2.3: Associate NSGs with Subnets

1. Go to **Virtual networks** → `sandbox-aiproductadvisor-eastus-vnet`
2. Click **Subnets** in left menu
3. Click on **sandbox-aiproductadvisor-eastus-snet**
4. Under **Network security group**, select `sandbox-aiproductadvisor-eastus-app-nsg`
5. Click **Save**
6. Repeat for:
   - `sandbox-aiproductadvisor-eastus-func-snet` → `sandbox-aiproductadvisor-eastus-func-nsg`
   - `sandbox-aiproductadvisor-eastus-pe-snet` → `sandbox-aiproductadvisor-eastus-pe-nsg`

### Step 2.4: Create Private DNS Zones

Create **7 Private DNS Zones** - repeat these steps 7 times:

1. Search for **Private DNS zones**
2. Click **+ Create**
3. Configure each zone:

| Zone # | Name |
|--------|------|
| 1 | `privatelink.blob.core.windows.net` |
| 2 | `privatelink.dfs.core.windows.net` |
| 3 | `privatelink.openai.azure.com` |
| 4 | `privatelink.search.windows.net` |
| 5 | `privatelink.documents.azure.com` |
| 6 | `privatelink.redis.cache.windows.net` |
| 7 | `privatelink.azurewebsites.net` |

For each zone:
- **Subscription**: `electrorent-ai-poc-sub`
- **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
- **Name**: (from table above)
- **Tags**: Add standard tags
- Click **Review + create** → **Create**

### Step 2.5: Link Private DNS Zones to VNet

For **each of the 7 DNS zones** created above:

1. Open the Private DNS zone
2. Click **Virtual network links** in left menu
3. Click **+ Add**
4. Configure:
   - **Link name**: `sandbox-aiproductadvisor-eastus-vnet-<service>-link`
     - Examples:
       - `sandbox-aiproductadvisor-eastus-vnet-blob-link`
       - `sandbox-aiproductadvisor-eastus-vnet-openai-link`
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Virtual network**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Enable auto registration**: Unchecked
5. Click **OK**

Repeat for all 7 zones.

✅ **Validation**: Each DNS zone should have 1 virtual network link

---

## Section 3: Managed Identities (10 minutes)

Create **2 User-Assigned Managed Identities**:

### Step 3.1: App Service Managed Identity

1. Search for **Managed Identities**
2. Click **+ Create**
3. Configure:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Region**: East US
   - **Name**: `sandbox-aiproductadvisor-eastus-mi`
4. **Tags**: Add standard tags
5. Click **Review + create** → **Create**

### Step 3.2: Function App Managed Identity

Repeat above with:
- **Name**: `sandbox-aiproductadvisor-eastus-func-mi`

✅ **Validation**: 2 managed identities created

---

## Section 4: Monitoring (15 minutes)

### Step 4.1: Create Log Analytics Workspace

1. Search for **Log Analytics workspaces**
2. Click **+ Create**
3. Configure:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-la`
   - **Region**: East US
   - **Pricing tier**: Pay-as-you-go (Per GB 2018)
4. **Tags**: Add standard tags
5. Click **Review + create** → **Create**

⏱️ Wait ~1 minute for deployment

### Step 4.2: Create Application Insights

1. Search for **Application Insights**
2. Click **+ Create**
3. Configure:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-appin`
   - **Region**: East US
   - **Resource Mode**: Workspace-based
   - **Log Analytics Workspace**: Select `sandbox-aiproductadvisor-eastus-la`
4. **Tags**: Add standard tags
5. Click **Review + create** → **Create**

✅ **Validation**: Application Insights shows "Succeeded"

---

## Section 5: Storage Accounts (20 minutes)

### Step 5.1: ADLS Gen2 Storage Account

1. Search for **Storage accounts**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Storage account name**: `sbxaiprdadveusflh`
   - **Region**: East US
   - **Performance**: Standard
   - **Redundancy**: Locally-redundant storage (LRS)

4. **Advanced** tab:
   - **Enable hierarchical namespace**: ✅ **CHECKED** (ADLS Gen2)
   - **Enable blob public access**: Disabled
   - **Minimum TLS version**: Version 1.2
   - **Enable infrastructure encryption**: Unchecked

5. **Networking** tab:
   - **Network access**: Disable public access and use private access
   - **Private endpoint**: We'll add later

6. **Data protection** tab: Leave defaults

7. **Encryption** tab: Leave defaults (Microsoft-managed keys)

8. **Tags**: Add standard tags

9. Click **Review + create** → **Create**

⏱️ Wait ~2 minutes for deployment

#### Step 5.1a: Create Data Lake Filesystem

1. Open the storage account `sbxaiprdadveusflh`
2. In left menu, scroll to **Data Lake Storage** section
3. Click **Containers**
4. Click **+ Container**
5. Configure:
   - **Name**: `productdata`
   - **Public access level**: Private
6. Click **Create**

### Step 5.2: Function App Storage Account

1. Search for **Storage accounts**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Storage account name**: `sbxaiprdadveusfa`
   - **Region**: East US
   - **Performance**: Standard
   - **Redundancy**: Locally-redundant storage (LRS)

4. **Advanced** tab:
   - **Enable hierarchical namespace**: UNCHECKED
   - **Enable blob public access**: Disabled
   - **Minimum TLS version**: Version 1.2

5. **Networking** tab:
   - **Network access**: Enable public access from all networks (for Functions)

6. **Tags**: Add standard tags

7. Click **Review + create** → **Create**

✅ **Validation**: Both storage accounts show "Succeeded"

---

## Section 6: Azure OpenAI Service (20 minutes)

### Step 6.1: Create Azure OpenAI Resource

1. Search for **Azure OpenAI**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Region**: East US
   - **Name**: `sandbox-aiproductadvisor-eastus-aoai`
   - **Pricing tier**: Standard S0

4. **Network** tab:
   - **Type**: All networks, including the internet, can access this resource
   - *(We'll add private endpoint later)*

5. **Tags**: Add standard tags

6. Click **Review + submit** → **Create**

⏱️ Wait ~1 minute for deployment

### Step 6.2: Deploy GPT-3.5 Turbo Model

1. Open the Azure OpenAI resource `sandbox-aiproductadvisor-eastus-aoai`
2. In left menu, click **Model deployments**
3. Click **Create new deployment** or **Manage Deployments** (opens Azure OpenAI Studio)
4. In Azure OpenAI Studio:
   - Click **Deployments** in left menu
   - Click **+ Create new deployment**
   - Configure:
     - **Select a model**: `gpt-35-turbo`
     - **Model version**: `0125` (or latest available)
     - **Deployment name**: `gpt-35-turbo`
     - **Deployment type**: Standard
     - **Tokens per Minute Rate Limit (thousands)**: 10
   - Click **Create**

### Step 6.3: Deploy Text Embedding Model

1. In Azure OpenAI Studio, click **+ Create new deployment** again
2. Configure:
   - **Select a model**: `text-embedding-ada-002`
   - **Model version**: `2` (or latest)
   - **Deployment name**: `text-embedding-ada-002`
   - **Deployment type**: Standard
   - **Tokens per Minute Rate Limit (thousands)**: 10
3. Click **Create**

### Step 6.4: Configure Diagnostic Settings

1. Go back to Azure Portal
2. Open Azure OpenAI resource `sandbox-aiproductadvisor-eastus-aoai`
3. In left menu, click **Diagnostic settings** (under Monitoring)
4. Click **+ Add diagnostic setting**
5. Configure:
   - **Diagnostic setting name**: `sandbox-aiproductadvisor-eastus-aoai-diagnostics`
   - **Logs** - Check these categories:
     - ✅ Audit
     - ✅ RequestResponse
   - **Metrics**:
     - ✅ AllMetrics
   - **Destination details**:
     - ✅ Send to Log Analytics workspace
     - **Subscription**: `electrorent-ai-poc-sub`
     - **Log Analytics workspace**: `sandbox-aiproductadvisor-eastus-la`
6. Click **Save**

✅ **Validation**: Both models show "Succeeded" status in Deployments

---

## Section 7: Azure AI Search (15 minutes)

### Step 7.1: Create Azure AI Search Service

1. Search for **Azure AI Search** (or **Cognitive Search**)
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Service name**: `sandbox-aiproductadvisor-eastus-aais`
   - **Location**: East US
   - **Pricing tier**: Basic

4. **Scale** tab:
   - **Replicas**: 1
   - **Partitions**: 1

5. **Networking** tab:
   - **Endpoint connectivity**: Public

6. **Tags**: Add standard tags

7. Click **Review + create** → **Create**

⏱️ Wait ~3-4 minutes for deployment

### Step 7.2: Configure Diagnostic Settings

1. Open Azure AI Search service `sandbox-aiproductadvisor-eastus-aais`
2. Click **Diagnostic settings** in left menu
3. Click **+ Add diagnostic setting**
4. Configure:
   - **Name**: `sandbox-aiproductadvisor-eastus-aais-diagnostics`
   - **Logs**:
     - ✅ OperationLogs
   - **Metrics**:
     - ✅ AllMetrics
   - **Destination**:
     - ✅ Send to Log Analytics workspace
     - Select `sandbox-aiproductadvisor-eastus-la`
5. Click **Save**

✅ **Validation**: Search service shows "Running" status

---

## Section 8: Azure Cache for Redis (20 minutes)

### Step 8.1: Create Redis Cache

1. Search for **Azure Cache for Redis**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **DNS name**: `sandbox-aiproductadvisor-eastus-acr`
   - **Location**: East US
   - **Cache type**: Basic C0 (250 MB Cache, No SLA)
     - ⚠️ **Note**: For POC only, use Standard or Premium for production

4. **Networking** tab:
   - **Connectivity method**: Public endpoint

5. **Advanced** tab:
   - **Non-TLS port**: Disabled
   - **Redis version**: 6

6. **Tags**: Add standard tags

7. Click **Review + create** → **Create**

⏱️ **IMPORTANT**: This takes 10-15 minutes! Continue with next sections while it deploys.

### Step 8.2: Configure Diagnostic Settings (Do this AFTER Redis completes)

1. Open Redis Cache `sandbox-aiproductadvisor-eastus-acr`
2. Click **Diagnostic settings**
3. Click **+ Add diagnostic setting**
4. Configure:
   - **Name**: `sandbox-aiproductadvisor-eastus-acr-diagnostics`
   - **Logs**:
     - ✅ ConnectedClientList
   - **Metrics**:
     - ✅ AllMetrics
   - **Destination**:
     - ✅ Send to Log Analytics workspace
     - Select `sandbox-aiproductadvisor-eastus-la`
5. Click **Save**

---

## Section 9: Cosmos DB (25 minutes)

⚠️ **IMPORTANT**: Due to capacity issues in East US for zone-redundant Cosmos DB, you have 2 options:

### **Option A: Non-Zone-Redundant (RECOMMENDED for POC)**

### Step 9.1: Create Cosmos DB Account

1. Search for **Azure Cosmos DB**
2. Click **+ Create**
3. Select **Azure Cosmos DB for NoSQL**
4. Click **Create**
5. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Account name**: `sandbox-aiproductadvisor-eastus-codb`
   - **Location**: East US
   - **Capacity mode**: Provisioned throughput
   - **Apply Free Tier Discount**: Apply (if available)
   - **Limit total account throughput**: Unchecked

6. **Global Distribution** tab:
   - **Geo-Redundancy**: Disable
   - **Multi-region Writes**: Disable
   - **Availability Zones**: **DISABLE** ⚠️ (Due to capacity constraints)

7. **Networking** tab:
   - **Connectivity method**: Public endpoint (all networks)

8. **Backup Policy** tab:
   - **Backup policy**: Continuous (7 days)

9. **Encryption** tab:
   - **Data encryption**: Service-managed key

10. **Tags**: Add standard tags

11. Click **Review + create** → **Create**

⏱️ Wait ~5-8 minutes for deployment

### Step 9.2: Create Database and Containers

1. Open Cosmos DB account `sandbox-aiproductadvisor-eastus-codb`
2. In left menu, click **Data Explorer**
3. Click **New Container**
4. Configure **Chat History Database**:
   - **Database id**: `chat-history`
   - **Database throughput**: Manual - 400 RU/s
   - Click **OK**

5. With `chat-history` database selected, click **New Container**
6. Configure **Sessions Container**:
   - **Database id**: Use existing - `chat-history`
   - **Container id**: `sessions`
   - **Partition key**: `/userId`
   - **Container throughput**: Manual - 400 RU/s
7. Click **OK**

✅ **Validation**: Database and container visible in Data Explorer

---

## Section 10: App Service Plan & Web App (15 minutes)

⚠️ **PREREQUISITE**: Ensure App Service quota is approved for Basic (B1) tier

### Step 10.1: Create App Service Plan

1. Search for **App Service plans**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-asp`
   - **Operating System**: Linux
   - **Region**: East US
   - **Pricing tier**: Basic B1

4. **Tags**: Add standard tags

5. Click **Review + create** → **Create**

### Step 10.2: Create App Service (Web App)

1. Search for **App Services**
2. Click **+ Create** → **Web App**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-app`
   - **Publish**: Code
   - **Runtime stack**: Node 18 LTS
   - **Operating System**: Linux
   - **Region**: East US
   - **Linux Plan**: Select `sandbox-aiproductadvisor-eastus-asp`

4. **Deployment** tab: Skip for now

5. **Networking** tab:
   - **Enable public access**: On
   - **Enable network injection**: On
   - **Virtual Network**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Subnet**: `sandbox-aiproductadvisor-eastus-snet`

6. **Monitoring** tab:
   - **Enable Application Insights**: Yes
   - **Application Insights**: Select `sandbox-aiproductadvisor-eastus-appin`

7. **Tags**: Add standard tags

8. Click **Review + create** → **Create**

### Step 10.3: Assign Managed Identity

1. Open App Service `sandbox-aiproductadvisor-eastus-app`
2. In left menu, click **Identity**
3. **User assigned** tab:
   - Click **+ Add**
   - Select `sandbox-aiproductadvisor-eastus-mi`
   - Click **Add**

---

## Section 11: Function App (20 minutes)

⚠️ **PREREQUISITE**: Ensure Function App quota is approved for Consumption tier

### Step 11.1: Create Function App

1. Search for **Function App**
2. Click **+ Create**
3. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Function App name**: `sandbox-aiproductadvisor-eastus-fa`
   - **Publish**: Code
   - **Runtime stack**: Python
   - **Version**: 3.11
   - **Region**: East US
   - **Operating System**: Linux
   - **Plan type**: Consumption (Serverless)

4. **Storage** tab:
   - **Storage account**: Select `sbxaiprdadveusfa`

5. **Networking** tab:
   - **Enable public access**: On
   - **Enable network injection**: On
   - **Virtual Network**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Subnet**: `sandbox-aiproductadvisor-eastus-func-snet`

6. **Monitoring** tab:
   - **Enable Application Insights**: Yes
   - **Application Insights**: Select `sandbox-aiproductadvisor-eastus-appin`

7. **Deployment** tab: Skip for now

8. **Tags**: Add standard tags

9. Click **Review + create** → **Create**

### Step 11.2: Assign Managed Identity

1. Open Function App `sandbox-aiproductadvisor-eastus-fa`
2. In left menu, click **Identity**
3. **User assigned** tab:
   - Click **+ Add**
   - Select `sandbox-aiproductadvisor-eastus-func-mi`
   - Click **Add**

---

## Section 12: Private Endpoints (30 minutes)

Create private endpoints for services to secure access from VNet only.

### Step 12.1: Storage Account (Blob) Private Endpoint

1. Go to Storage Account `sbxaiprdadveusflh`
2. In left menu, click **Networking**
3. Click **Private endpoint connections** tab
4. Click **+ Private endpoint**
5. **Basics** tab:
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Name**: `sandbox-aiproductadvisor-eastus-storage-blob-pe`
   - **Network Interface Name**: Auto-generated
   - **Region**: East US

6. **Resource** tab:
   - **Resource type**: Microsoft.Storage/storageAccounts
   - **Resource**: `sbxaiprdadveusflh`
   - **Target sub-resource**: blob

7. **Virtual Network** tab:
   - **Virtual network**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Subnet**: `sandbox-aiproductadvisor-eastus-pe-snet`
   - **Private IP configuration**: Dynamically allocate IP address

8. **DNS** tab:
   - **Integrate with private DNS zone**: Yes
   - **Subscription**: `electrorent-ai-poc-sub`
   - **Resource group**: `sandbox-aiproductadvisor-eastus-rg`
   - **Private DNS zone**: Select `privatelink.blob.core.windows.net`

9. **Tags**: Add standard tags

10. Click **Review + create** → **Create**

### Step 12.2: Storage Account (DFS/ADLS) Private Endpoint

Repeat Step 12.1 with:
- **Name**: `sandbox-aiproductadvisor-eastus-storage-dfs-pe`
- **Target sub-resource**: dfs
- **Private DNS zone**: `privatelink.dfs.core.windows.net`

### Step 12.3: Azure OpenAI Private Endpoint

1. Go to Azure OpenAI `sandbox-aiproductadvisor-eastus-aoai`
2. In left menu, click **Networking**
3. Click **Private endpoint connections**
4. Click **+ Private endpoint**
5. **Basics** tab:
   - **Name**: `sandbox-aiproductadvisor-eastus-openai-pe`
   - **Region**: East US
6. **Resource** tab:
   - **Resource type**: Microsoft.CognitiveServices/accounts
   - **Resource**: `sandbox-aiproductadvisor-eastus-aoai`
   - **Target sub-resource**: account
7. **Virtual Network** tab:
   - **VNet**: `sandbox-aiproductadvisor-eastus-vnet`
   - **Subnet**: `sandbox-aiproductadvisor-eastus-pe-snet`
8. **DNS** tab:
   - **Integrate**: Yes
   - **Private DNS zone**: Select `privatelink.openai.azure.com`
9. **Tags**: Add standard tags
10. Click **Review + create** → **Create**

### Step 12.4: Azure AI Search Private Endpoint

Repeat with:
- Resource: `sandbox-aiproductadvisor-eastus-aais`
- **Name**: `sandbox-aiproductadvisor-eastus-search-pe`
- **Resource type**: Microsoft.Search/searchServices
- **Target sub-resource**: searchService
- **Private DNS zone**: `privatelink.search.windows.net`

### Step 12.5: Cosmos DB Private Endpoint

Repeat with:
- Resource: `sandbox-aiproductadvisor-eastus-codb`
- **Name**: `sandbox-aiproductadvisor-eastus-cosmos-pe`
- **Resource type**: Microsoft.DocumentDB/databaseAccounts
- **Target sub-resource**: SQL
- **Private DNS zone**: `privatelink.documents.azure.com`

### Step 12.6: Redis Cache Private Endpoint

Repeat with:
- Resource: `sandbox-aiproductadvisor-eastus-acr`
- **Name**: `sandbox-aiproductadvisor-eastus-redis-pe`
- **Resource type**: Microsoft.Cache/Redis
- **Target sub-resource**: redisCache
- **Private DNS zone**: `privatelink.redis.cache.windows.net`

### Step 12.7: App Service Private Endpoint (Optional)

If needed for production:
- Resource: `sandbox-aiproductadvisor-eastus-app`
- **Name**: `sandbox-aiproductadvisor-eastus-app-pe`
- **Resource type**: Microsoft.Web/sites
- **Target sub-resource**: sites
- **Private DNS zone**: `privatelink.azurewebsites.net`

### Step 12.8: Function App Private Endpoint (Optional)

If needed for production:
- Resource: `sandbox-aiproductadvisor-eastus-fa`
- **Name**: `sandbox-aiproductadvisor-eastus-func-pe`
- **Resource type**: Microsoft.Web/sites
- **Target sub-resource**: sites
- **Private DNS zone**: `privatelink.azurewebsites.net`

---

## Section 13: Microsoft Fabric (Manual Setup)

⚠️ **NOTE**: Fabric has limited Azure Portal automation. Use Fabric Portal.

### Step 13.1: Verify Fabric Capacity

1. Navigate to https://app.fabric.microsoft.com
2. Click Settings (gear icon) → **Admin portal**
3. Click **Capacity settings**
4. Verify capacity exists: `sandboxaiproductadvisorfc`
   - If not, create new capacity:
     - Name: `sandboxaiproductadvisorfc`
     - SKU: F2 (minimum for sandbox)
     - Region: East US
     - Administrators: Add your admin account

### Step 13.2: Create Workspace

1. In Fabric Portal, click **Workspaces**
2. Click **+ New workspace**
3. Configure:
   - **Name**: `sandbox-aiproductadvisor-workspace`
   - **Description**: AI Product Advisor POC Workspace
   - **Advanced** → **License mode**: Fabric capacity
   - **Fabric capacity**: Select `sandboxaiproductadvisorfc`
4. Click **Apply**

### Step 13.3: Create Lakehouse

1. In the workspace, click **+ New**
2. Select **Lakehouse**
3. Configure:
   - **Name**: `sandbox-aiproductadvisor-lakehouse`
   - **Description**: Product data lakehouse for AI advisor
4. Click **Create**

✅ **Validation**: Lakehouse appears in workspace

---

## Section 14: Configure Access & Roles (20 minutes)

### Step 14.1: Grant Managed Identity Access to Storage

1. Go to Storage Account `sbxaiprdadveusflh`
2. Click **Access Control (IAM)** in left menu
3. Click **+ Add** → **Add role assignment**
4. **Role** tab:
   - Search and select: **Storage Blob Data Contributor**
   - Click **Next**
5. **Members** tab:
   - **Assign access to**: Managed identity
   - Click **+ Select members**
   - **Managed identity**: User-assigned managed identity
   - Select both:
     - `sandbox-aiproductadvisor-eastus-mi`
     - `sandbox-aiproductadvisor-eastus-func-mi`
   - Click **Select**
6. Click **Review + assign**

### Step 14.2: Grant Managed Identity Access to OpenAI

1. Go to Azure OpenAI `sandbox-aiproductadvisor-eastus-aoai`
2. Click **Access Control (IAM)**
3. Click **+ Add** → **Add role assignment**
4. Select role: **Cognitive Services OpenAI User**
5. Assign to both managed identities:
   - `sandbox-aiproductadvisor-eastus-mi`
   - `sandbox-aiproductadvisor-eastus-func-mi`
6. Click **Review + assign**

### Step 14.3: Grant Managed Identity Access to Cosmos DB

1. Go to Cosmos DB `sandbox-aiproductadvisor-eastus-codb`
2. Click **Access Control (IAM)**
3. Click **+ Add** → **Add role assignment**
4. Select role: **Cosmos DB Built-in Data Contributor**
5. Assign to both managed identities
6. Click **Review + assign**

### Step 14.4: Grant Managed Identity Access to Redis

1. Go to Redis Cache `sandbox-aiproductadvisor-eastus-acr`
2. Click **Access Control (IAM)**
3. Click **+ Add** → **Add role assignment**
4. Select role: **Redis Cache Contributor**
5. Assign to both managed identities
6. Click **Review + assign**

### Step 14.5: Grant Managed Identity Access to AI Search

1. Go to AI Search `sandbox-aiproductadvisor-eastus-aais`
2. Click **Access Control (IAM)**
3. Click **+ Add** → **Add role assignment**
4. Select role: **Search Service Contributor**
5. Assign to both managed identities
6. Click **Review + assign**

---

## Section 15: Validation & Testing (15 minutes)

### Step 15.1: Resource Group Overview

1. Navigate to Resource Group `sandbox-aiproductadvisor-eastus-rg`
2. Verify all resources are present:

| Resource Type | Count | Names |
|---------------|-------|-------|
| Virtual Network | 1 | `sandbox-aiproductadvisor-eastus-vnet` |
| Network Security Group | 3 | app, func, pe NSGs |
| Private DNS Zone | 7 | blob, dfs, openai, search, cosmos, redis, sites |
| Managed Identity | 2 | app, func identities |
| Log Analytics Workspace | 1 | `sandbox-aiproductadvisor-eastus-la` |
| Application Insights | 1 | `sandbox-aiproductadvisor-eastus-appin` |
| Storage Account | 2 | `sbxaiprdadveusflh`, `sbxaiprdadveusfa` |
| Azure OpenAI | 1 | `sandbox-aiproductadvisor-eastus-aoai` |
| Azure AI Search | 1 | `sandbox-aiproductadvisor-eastus-aais` |
| Cosmos DB | 1 | `sandbox-aiproductadvisor-eastus-codb` |
| Redis Cache | 1 | `sandbox-aiproductadvisor-eastus-acr` |
| App Service Plan | 1 | `sandbox-aiproductadvisor-eastus-asp` |
| App Service | 1 | `sandbox-aiproductadvisor-eastus-app` |
| Function App | 1 | `sandbox-aiproductadvisor-eastus-fa` |
| Private Endpoint | 5-7 | Various PE resources |

### Step 15.2: Test OpenAI Access

1. Go to Azure OpenAI Studio: https://oai.azure.com
2. Select workspace: `sandbox-aiproductadvisor-eastus-aoai`
3. Click **Deployments**
4. Verify both models are deployed:
   - `gpt-35-turbo`
   - `text-embedding-ada-002`
5. Click **Chat playground**
6. Send test message: "Hello, test"
7. Verify response received

### Step 15.3: Test Application Insights

1. Go to Application Insights `sandbox-aiproductadvisor-eastus-appin`
2. Click **Live metrics**
3. Verify it shows "Connected" status
4. Open App Service in another tab to generate telemetry

### Step 15.4: Verify Network Connectivity

1. Go to Virtual Network `sandbox-aiproductadvisor-eastus-vnet`
2. Click **Connected devices**
3. Verify private endpoints are connected
4. Click **Subnets**
5. Verify all 3 subnets have IP addresses allocated

---

## Section 16: Capture Configuration Details (10 minutes)

Document these values for application configuration:

### Step 16.1: Azure OpenAI

1. Go to Azure OpenAI resource
2. Click **Keys and Endpoint**
3. Copy and save:
   - **Endpoint**: `https://sandbox-aiproductadvisor-eastus-aoai.openai.azure.com/`
   - **Key 1**: [Copy to secure location]
   - **Region**: eastus

### Step 16.2: Azure AI Search

1. Go to AI Search resource
2. Click **Keys**
3. Copy and save:
   - **URL**: `https://sandbox-aiproductadvisor-eastus-aais.search.windows.net`
   - **Primary admin key**: [Copy to secure location]

### Step 16.3: Cosmos DB

1. Go to Cosmos DB resource
2. Click **Keys**
3. Copy and save:
   - **URI**: `https://sandbox-aiproductadvisor-eastus-codb.documents.azure.com:443/`
   - **PRIMARY KEY**: [Copy to secure location]

### Step 16.4: Redis Cache

1. Go to Redis Cache resource
2. Click **Access keys**
3. Copy and save:
   - **Host name**: `sandbox-aiproductadvisor-eastus-acr.redis.cache.windows.net`
   - **Primary**: [Copy to secure location]
   - **Port**: 6380 (SSL)

### Step 16.5: Storage Account

1. Go to Storage Account `sbxaiprdadveusflh`
2. Click **Access keys**
3. Copy and save:
   - **Storage account name**: `sbxaiprdadveusflh`
   - **Key1**: [Copy to secure location]
   - **Blob endpoint**: `https://sbxaiprdadveusflh.blob.core.windows.net/`
   - **DFS endpoint**: `https://sbxaiprdadveusflh.dfs.core.windows.net/`

### Step 16.6: Application Insights

1. Go to Application Insights resource
2. Click **Overview**
3. Copy:
   - **Instrumentation Key**: [Displayed on overview]
   - **Connection String**: [Copy to secure location]

---

## Post-Deployment Configuration

### Configure App Service Application Settings

1. Go to App Service `sandbox-aiproductadvisor-eastus-app`
2. Click **Configuration** → **Application settings**
3. Click **+ New application setting** for each:

| Name | Value | Type |
|------|-------|------|
| `AZURE_OPENAI_ENDPOINT` | [From Step 16.1] | Setting |
| `AZURE_OPENAI_DEPLOYMENT_GPT` | `gpt-35-turbo` | Setting |
| `AZURE_OPENAI_DEPLOYMENT_EMBEDDING` | `text-embedding-ada-002` | Setting |
| `AZURE_SEARCH_ENDPOINT` | [From Step 16.2] | Setting |
| `COSMOS_DB_ENDPOINT` | [From Step 16.3] | Setting |
| `REDIS_HOST` | [From Step 16.4] | Setting |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | [From Step 16.6] | Setting |

4. Click **Save**

### Configure Function App Application Settings

Repeat the above for Function App `sandbox-aiproductadvisor-eastus-fa`

---

## Troubleshooting Common Issues

### Issue: Quota Errors

**Symptom**: "Operation cannot be completed without additional quota"

**Solution**:
1. Go to Azure Portal → **Subscriptions**
2. Select subscription → **Usage + quotas**
3. Search for the quota type (e.g., "App Service")
4. Click quota → **Request increase**
5. Fill out form with required quota amount
6. Wait for approval (typically 1-3 business days)

### Issue: Cosmos DB Zone Redundancy Error

**Symptom**: "High demand in East US region for zonal redundant accounts"

**Solution**:
- Use **Option A** in Section 9 (disable availability zones)
- OR deploy to different region (East US 2, West US 2)
- OR request capacity: https://aka.ms/cosmosdbquota

### Issue: Private Endpoint Connection Failed

**Symptom**: Private endpoint shows "Failed" status

**Solution**:
1. Delete the failed private endpoint
2. Ensure Private DNS zone exists and is linked to VNet
3. Recreate private endpoint
4. Wait 5-10 minutes for DNS propagation

### Issue: App Service Can't Access Storage

**Symptom**: Storage access denied errors in application logs

**Solution**:
1. Verify managed identity is assigned to App Service (Section 10.3)
2. Verify RBAC role is granted (Section 14.1)
3. Wait 10-15 minutes for RBAC propagation
4. Restart the App Service

### Issue: Redis Cache Takes Too Long

**Symptom**: Redis deployment stuck at "Creating"

**Solution**:
- Redis typically takes 10-15 minutes
- If stuck >30 minutes, delete and recreate
- Ensure region has capacity
- Try Standard tier instead of Basic if issues persist

---

## Cleanup Instructions

To delete all resources when done with POC:

1. Go to Resource Groups
2. Find `sandbox-aiproductadvisor-eastus-rg`
3. Click **Delete resource group**
4. Type the resource group name to confirm
5. Click **Delete**

⏱️ Deletion takes ~5-10 minutes

**Important**: This deletes ALL resources in the group permanently!

---

## Cost Estimation

**Estimated Monthly Costs (Sandbox Configuration)**:

| Resource | SKU | Approx Cost/Month |
|----------|-----|-------------------|
| App Service Plan | Basic B1 | $13 |
| Function App | Consumption | $0-5 (low usage) |
| Azure OpenAI | Standard S0 | Pay-per-token (~$50-100) |
| Azure AI Search | Basic | $75 |
| Cosmos DB | 400 RU/s | $24 |
| Redis Cache | Basic C0 | $17 |
| Storage Accounts | LRS | $5-10 |
| Log Analytics | Pay-as-you-go | $10-20 |
| Networking | VNet, DNS, PE | $5-10 |
| **TOTAL** | | **~$200-280/month** |

**Note**: Actual costs vary based on usage. OpenAI token consumption is the largest variable.

---

## Support & References

### Azure Documentation
- Azure Portal: https://portal.azure.com
- Azure OpenAI: https://learn.microsoft.com/azure/ai-services/openai/
- Private Endpoints: https://learn.microsoft.com/azure/private-link/
- Managed Identities: https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/

### Project Documentation
- Deployment Report: `DEPLOYMENT_REPORT.md`
- Terraform Configuration: `infrastructure/environments/sandbox/`
- Permissions Guide: `PERMISSIONS_CHECK.md`

### Getting Help
- **Azure Support**: Open ticket in Azure Portal → Support
- **Team**: Contact Datavail infrastructure team
- **Microsoft TAM**: If available for ElectroRent

---

## Appendix A: Resource Naming Reference

All resource names follow this pattern:
```
{environment}-{project}-{region}-{resource-abbreviation}
```

Examples:
- `sandbox-aiproductadvisor-eastus-rg` - Resource Group
- `sandbox-aiproductadvisor-eastus-vnet` - Virtual Network
- `sandbox-aiproductadvisor-eastus-aoai` - Azure OpenAI

Storage accounts use abbreviation due to length limits:
- `sbxaiprdadveusflh` - ADLS (sbx + ai + prod + adv + eus + flh)
- `sbxaiprdadveusfa` - Function App storage

---

## Appendix B: Subnet CIDR Quick Reference

| Subnet | CIDR | IPs Available | Purpose |
|--------|------|---------------|---------|
| App Service | 10.2.1.0/24 | 251 | App Service VNet integration |
| Function App | 10.2.2.0/24 | 251 | Function App VNet integration |
| Private Endpoints | 10.2.3.0/24 | 251 | Private endpoint NICs |

---

**Document Version**: 1.0
**Last Updated**: November 7, 2025
**Author**: Infrastructure Team - Datavail
**Reviewed By**: [To be completed]

---

## ✅ Deployment Checklist

Print this checklist and check off each section as you complete it:

- [ ] Section 1: Resource Group
- [ ] Section 2: Networking (VNet, NSGs, DNS)
- [ ] Section 3: Managed Identities
- [ ] Section 4: Monitoring (Log Analytics, App Insights)
- [ ] Section 5: Storage Accounts
- [ ] Section 6: Azure OpenAI + Models
- [ ] Section 7: Azure AI Search
- [ ] Section 8: Redis Cache
- [ ] Section 9: Cosmos DB
- [ ] Section 10: App Service
- [ ] Section 11: Function App
- [ ] Section 12: Private Endpoints
- [ ] Section 13: Microsoft Fabric
- [ ] Section 14: Access & Roles (RBAC)
- [ ] Section 15: Validation & Testing
- [ ] Section 16: Configuration Details Captured
- [ ] Post-Deployment: App Settings Configured

**Completion Time**: __________ hours

**Issues Encountered**: _______________________________________________

**Notes**: __________________________________________________________

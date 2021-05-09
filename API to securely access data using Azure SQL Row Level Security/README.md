---
page_type: sample
languages:
- python
- tsql
- sql
- json
products:
- azure
- vs-code
- azure-sql-database
- azure-app-service
- azure-app-service-web
description: "Creating API to securely access data using Row Level Security"
urlFragment: "azure-sql-db-secure-data-access-api"
---

# Creating API to securely access data using Azure SQL Row Level Security


<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

An API should allow its users to securely access the data in the database used by the API itself. At the same time it also must assure that data is protected and secured from those users who doesn't have enough authorization. This is even more important when creating multi-tenant applications.

Azure SQL offers an amazing feature to secure data at the database level, so that all the burden of taking care of such important and critical effort is done automatically by the database engine, so that the API code can be cleaner and easier to maintain and evolve. Not to mention better performances and improved efficiency as data will not leave the database at all, if the user has not the correct permissions.

This repo guides you to the creation of a API solution, deployable in Azure, that take advantage of Azure SQL Row Level Security to create secure API using Python, Flask and JWT. The same approach could be used with .NET or any other language that allows you to connect to Azure SQL.

A detailed video on how this sample work is available here:

https://youtu.be/Qpv8ke8ZuQ8

The sample simulate an authenticated user by passing in the JWT token (that you'll generate using the `pyjwt` tool) the hashed User Id. From a security point of view you want to make sure that a user can access only to his own data (or to the data s/he has been authorized to). 

## Install Sample Database

In order to run this sample, you need a Azure SQL database to use. If you already have one that can be used as a developer playground you can used that. Make sure create all the needed objects by executing the script:

`./sql/00-SetupRLS.sql`

Otherwise you can restore the `rls_sample` database by using the 

`./sql/rls_sample.bacpac`. If you already know how to restore a database, great!, go on and once restore is done move on to next section. Otherwise, or if you want some scripts to help, use the following link:

[How To Restore Database](https://github.com/yorek/azure-sql-db-samples#restore-wideworldimporters-database)

If you need any help in executing the SQL script, you can find a Quickstart here: [Quickstart: Use Azure Data Studio to connect and query Azure SQL database](https://docs.microsoft.com/en-us/sql/azure-data-studio/quickstart-sql-database)


## Deploy to Azure

Now that your REST API solution is ready, it's time to deploy it on Azure so that anyone can take advantage of it. A detailed article on how you can that that is here:

- [Deploying Python web apps to Azure App Services](https://medium.com/@GeekTrainer/deploying-python-web-apps-to-azure-app-services-413cc16d4d68)
- [Quickstart: Create a Python app in Azure App Service on Linux](https://docs.microsoft.com/en-us/azure/app-service/containers/quickstart-python?tabs=bash)

The only thing you have do in addition to what explained in the above articles is to add the connection string to the Azure Web App configuration. Using AZ CLI, for example:

```bash
appName="azure-sql-db-secure-data-access-api"
resourceGroup="my-resource-group"

az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings RLS=$SQLAZURECONNSTR_RLS \
    --connection-string-type=SQLAzure
```

Just make sure you correctly set `$appName` and `$resourceGroup` to match your environment and also that the variable `$SQLAZURECONNSTR_RLS` as also been set, as mentioned in section "Run sample locally". An example of a full script that deploy the REST API is available here: `azure-deploy.sh`.

Please note that connection string are accessible as environment variables from Python when running on Azure, *but they are prefixed* as documented here:

https://docs.microsoft.com/en-us/azure/app-service/configure-common#connection-strings

That's why the Python code in the sample look for `SQLAZURECONNSTR_RLS` but the Shell script write the `RLS` connection string name.

## Next Steps

To properly secure your API you need some kind of authentication. You can use Azure Active Directory:

[Microsoft Authentication Library (MSAL) for Python](https://github.com/AzureAD/microsoft-authentication-library-for-python)

or some third party service like Auth0:

- [Auth0 Python Web App](https://github.com/auth0-samples/auth0-python-web-app)
- [Auth0 Python API](https://github.com/auth0-samples/auth0-python-api-samples)

## Learn more

Here's some link if you want to learn more, or you are new to Python

[REST API using Python, Flask and Azure SQL](https://github.com/Azure-Samples/azure-sql-db-python-rest-api)

If you want to do the same in .NET, this repo is a good start:

[REST API using .Net, Dapper and Azure SQL](https://github.com/Azure-Samples/azure-sql-db-dotnet-rest-api)


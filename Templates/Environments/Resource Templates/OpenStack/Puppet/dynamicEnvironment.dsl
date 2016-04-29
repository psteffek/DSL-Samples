/*
 * DSL to create a resource template with the given configuration
 */
 
 // ------------------------------------------------------
 // Parameters used by the resource template
 // You should set these parameter values 
 // to create the required resource template.
 // Once the resource template has been created 
 // on the ElectricFlow server, it can be used 
 // to provision dynamic environments for 
 // application deployments.

 // 1. Set the resource template name 
 def resourceTemplateName = 'PROVIDE RESOURCE TEMPLATE NAME'
 
 // 2. Update the project name if the resource template
 // should be created in a project other than 'Default'. 
 // The project will be created if it does not exist.
 def projectName = 'Default'
 
 // 3. Set the cloud provider to use for the resource template
 // Valid values are: Amazon, OpenStack, and Azure
 def cloudProvider = 'Amazon' 
 
 // 4. Whether the referenced plugin configurations 
 // should be created or replaced if they already exists.
 // Set this flag to false if the configurations already 
 // exist and you do not want the script to replace them.
 // This flag applies to both the cloud provider plugin 
 // configuration and the configuration management plugin.
 def createOrReplaceConfiguration = true
 
 def cloudProviderPluginConfiguration = 'cpConfig'
 def configMgmtPluginConfiguration    = 'cmConfig'
 
 // 5.1 (a) Set the following configurations for Amazon EC2 if cloudProvider is 'Amazon'
 def amazonConfigurations = [
    'config': cloudProviderPluginConfiguration,
    //TODO: EC2 CreateConfiguration parameters
  ]

 // 5.1 (b) Set the following provisioning parameters for Amazon EC2 if cloudProvider is 'Amazon'
 def amazonParameters = [
    'config': cloudProviderPluginConfiguration,
    'count': '1',
	'group': 'security goes here',
    'image': 'ami-17b75453',
    'instanceInitiatedShutdownBehavior': '',
    'instanceType': 'm1.small',
    'keyname': 'ECPluginTest',
    'privateIp': '',
    'propResult': '',
    'res_poolName': '',
    'res_port': '',
    'res_workspace': '',
    'resource_zone': 'default',
    'subnet_id': 'subnet-36142770',
    'use_private_ip': '0',
    'userData': '',
    'zone': 'us-west-1b',
  ]
  
  // 5.2 (a) Set the following configurations for Azure if cloudProvider is 'Azure'
  // TODO: Add Azure parameters for CreateConfiguration procedure
  def azureConfigurations = [:]
  
  // 5.2 (b) Set the following provisioning parameters for Azure if cloudProvider is 'Azure'
 def azureParameters = [
    'connection_config': cloudProviderPluginConfiguration,
    'region': 'East US',
    'resource_group_name': 'IIS_production1_servers',
    'vm_admin_password': 'admin',
    'vm_admin_user': 'admin',
    'vm_name': 'Prod_IIS',
  ]

  // 5.3 (a) Set the following configurations for OpenStack if cloudProvider is 'OpenStack'
  // TODO: Add open stack parameters for CreateConfiguration procedure
  
  // 5.3 (b) Set the following provisioning parameters for OpenStack if cloudProvider is 'OpenStack'
  // TODO: Add open stack parameters
  
  
 // 6. Set the configuration management tool to use for the resource template
 // Valid values are: Chef, and Puppet
 def configMgmtProvider = 'Chef' 
 
 // 7.1 (a) Set the following parameters if the selected configuration management tool is 'Chef'
 def chefParameters = [
    additional_arguments : '',
    chef_client_path : '/usr/bin/chef-client',
    config : 'testChef',
    node_name : '',
    run_list : 'tomcat, java',
    use_sudo : '1',
 ]
 
 // 7.2 (b) Set the following parameters if the selected configuration management tool is 'Puppet'
 def puppetParameters = [
      'additional_options': null,
      'certname': null,
      'debug': '0',
      'master_host': '10.168.30.1',
      'masterport': null,
      'puppet_path': 'sudo /usr/bin/puppet',
 ]
	
 // End of resource template parameters -----------------------------
 
 // Cloud provider plugin configuration
 def cloudProviders = [:]
 
 cloudProviders['Amazon'] = [ 
   name : 'EC-EC2',
   procedureName : 'API_RunInstances',
   parameters : amazonParameters
 ]
 
 cloudProviders['Azure'] = [ 
   name : 'EC-Azure',
   procedureName : 'Create VM',
   parameters : azureParameters
 ]
 
 def configMgmtProviders = [:]
 
 configMgmtProviders['Chef'] = [ 
   name : 'EC-Chef',
   procedureName : '_RegisterAndConvergeNode',
   parameters : chefParameters
 ]
 
 configMgmtProviders['Puppet'] = [ 
   name : 'EC-Puppet',
   procedureName : 'Configure Agent',
   parameters : puppetParameters
 ]
 
 if (!cloudProvider || !cloudProviders[cloudProvider]) {
     throw IllegalArgumentException ("Invalid cloud provider: $cloudProvider")
 }
 
 if (!configMgmtProvider || !configMgmtProviders[configMgmtProvider]) {
     throw IllegalArgumentException ("Invalid configuration management provider: $configMgmtProvider")
 }

 // Create the plugin configurations if required
 
 if (createOrReplaceConfiguration) {
 
	// TODO: Handle Cloud provider plugin configuration
	//1. Delete Configuration in case it exists
	//2. Create the configuration
	
	// TODO: Handle Configuration management plugin configuration
	//1. Delete Configuration in case it exists
	//2. Create the configuration
	
 }
 
 // Resource template DSL
def result 

project projectName, { 
  result = resourceTemplate resourceTemplateName, {

    cloudProviderPluginKey = cloudProviders[cloudProvider].name
    cloudProviderProcedure = cloudProviders[cloudProvider].procedureName
    cloudProviderProjectName = null
  
    cloudProviderParameter = cloudProviders[cloudProvider].parameters
  
    cfgMgrPluginKey = configMgmtProviders[configMgmtProvider].name
    cfgMgrProcedure = configMgmtProviders[configMgmtProvider].procedureName
    cfgMgrProjectName = null
  
    cfgMgrParameter = configMgmtProviders[configMgmtProvider].parameters

  }

}
// return the resource template created
result
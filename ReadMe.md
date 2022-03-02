Terraform for Api

1) Configure dev container. 
2) Write dev and inte variables
3) File Alerting. Specify line 2(name), line 10(geo locations), line 20 and 26(name and frequency)
4) File apim_payload_validation.
   Line 48. Add allowed origins to allow CORS for apim. That should be URL`s of localhost frontend Dev and Inte frontend 
   Line 73. Specify correct ApiName
5) File locals.
   Specify saas_digits, location, and other values.
6) File resources
   Specify scm_type.


When working with terraform:
1) Configure dev container.
2) Open VS Code in dev container mode. 
   Press f1 -> select open in devcontainer. Or when opening project folder with VS Code there will be 
   notification to open in dev container.
3) Open new terminal.
4) cd terraform
5) Run init.sh script with command: ./init.sh
6) Run plan.sh script with command: ./plan.sh
7) Run apply.sh script with command: ./apply.sh
Warning! There might appear message that some resources already exist and are under control of another terraform.
	 Most likely you should import those resources. For more details search for import command on terraform official resource.
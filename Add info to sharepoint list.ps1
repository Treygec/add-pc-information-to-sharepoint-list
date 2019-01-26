$UserName = "" #add email address
$SecurePassword = ConvertTo-SecureString "" -AsPlainText -Force #add password when running
$credentials = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $SecurePassword)

Connect-SPOService -Url https://bssconsultingcom-admin.sharepoint.com -Credential $credentials

#gets model of computer
$model = (Get-WmiObject Win32_computersystem).model
#gets OS version
$OSVersion = (Get-ComputerInfo).WindowsProductName 
#gets Install Date
$InstallDate = (Get-computerInfo).WindowsInstallDateFromRegistry
#gets Processor information
$Processor = (Get-WmiObject Win32_processor).Name

#sharepoint list real names. These are found at the end of the url when the list is open. Must add a variable for each column and then update the columns at the bottom. 
$Modelcolumn = "" 
$OS = ""
$ManufactureDate = ""
$Processorcolumn = ""

# Specify tenant admin and site URL
$SiteUrl = ""
$ListName = ""

# Bind to site collection
$ClientContext = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
$ClientContext.Credentials = $credentials
$ClientContext.ExecuteQuery()

# Get List
$List = $ClientContext.Web.Lists.GetByTitle($ListName)
$ClientContext.Load($List)
$ClientContext.ExecuteQuery()

# Create Single List Item. Follow the pattern below for your specific list / column names
$ListItemCreationInformation = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$NewListItem = $List.AddItem($ListItemCreationInformation)
$NewListItem[$Modelcolumn] = $model
$NewListItem[$OS] = $OSVersion
$NewListItem[$Processorcolumn] = $Processor
$NewListItem[$ManufactureDate] = $InstallDate
$NewListItem.Update()
$ClientContext.ExecuteQuery()
# PowerShell Scripts Collection

This repository contains a collection of useful PowerShell scripts for various administrative and utility tasks.

## Files

### 📋 [check_user_licenses_in_microsoft_tenant.ps1](./check_user_licenses_in_microsoft_tenant.ps1)
A comprehensive PowerShell script for managing Microsoft 365 licensing through the Microsoft Graph PowerShell SDK. This script provides:
- Installation and setup instructions for the Microsoft Graph SDK
- Connection establishment with Microsoft Graph (including MFA support)
- Commands to retrieve all available license packages in a tenant
- User license detail queries and reporting
- Complete workflow for checking user licensing status across the organization

### 📖 [m365-licensing-guide.md](./m365-licensing-guide.md)
A detailed markdown guide for Microsoft 365 license management via PowerShell. This documentation includes:
- Prerequisites and setup requirements
- Step-by-step authentication procedures
- Commands for viewing license overviews (especially O365 Business Premium)
- Complete reference for managing Microsoft 365 user licenses
- Best practices for license administration

### 🔄 [rename-files.ps1](./rename-files.ps1)
A utility script for batch renaming files in a directory. Features include:
- Sequential numbering of files (001.jpg, 002.jpg, etc.)
- Automatic digit calculation based on file count
- Customizable file extensions
- Preview functionality to show new filenames before applying changes
- Ideal for organizing image collections or document batches

## Usage

Each script contains detailed comments and instructions. Make sure to:
1. Run PowerShell as Administrator when required
2. Set appropriate execution policies if needed: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Install required modules as specified in each script

## Requirements

- PowerShell 5.1 or later (PowerShell 7 recommended)
- For Microsoft Graph scripts: Microsoft Graph PowerShell SDK
- Appropriate permissions for the target operations

## Contributing

Feel free to submit issues or pull requests to improve these scripts.

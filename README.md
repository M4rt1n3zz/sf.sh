# Subdomain finder

This script is designed to extract subdomains from `cert.sh` sort them and remove the dublicates. It offers options for saving the output to a `txt` file.

## Features

- Fetches information about the provided domain.
- Option to save the output to a specified file in `txt` format.
- Can include and exclude `www` to avoid dublicates.

## Prerequisites

Make sure you have the following installed on your system:

- Bash (version 4.0 or higher recommended)
- jq
## Usage

To run the script, use the following commands:

```
./sf.sh <domain>
```
```bash
./sf.sh <domain> [-o <output_file>] [-a]
```
## Parameters
`<domain>`: The domain name for which you want to fetch information.

`-o` `<output_file>`: Optional. Specify an output file to save the results.\
`-a`: Optional. Include all available information.

```
./sf.sh example.com -o output.txt -a
```
This command retrieves information about `example.com`, saves it to `output.txt`, and includes `www`.
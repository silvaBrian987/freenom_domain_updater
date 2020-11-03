# Freenom Domain Updater
Dockerization of Python's library [freenom](https://pypi.org/project/freenom/)

## Configuration

We can use the following environment variables:

### LOG_LEVEL

Python's log level

### FREENOM_USERNAME

Username of Freenom's account

### FREENOM_PASSWORD

Password of Freenom's account

### FREENOM_DOMAINS

A comma-separated list of Freenom's domains

### SCHEDULED

Boolean value to active the 15min cron schedule

### SCHEDULED_DEBUG

Boolean value to set cron to 1 minute (for debugging)

## Example

docker run -e SCHEDULED=true -e FREENOM_USERNAME=pepe@argento.com -e FREENOM_PASSWORD=PepeArgento -e FREENOM_DOMAINS=pepe.argento freenom-domain-updater

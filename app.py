#!/usr/bin/python3

from typing import List
import logging
from os import environ
import subprocess
import argparse
from freenom import Freenom

_logger: logging.Logger


class FreenomClient:
    __client: Freenom
    __ttl: int
    __use_dig_cmd: bool

    def __init__(
        self, user: str, password: str, ttl: int = 300, use_dig_cmd: bool = False
    ):
        self.__ttl = ttl
        self.__use_dig_cmd = use_dig_cmd

        self.__client = Freenom(user, password)
        _logger.info("Logged in!")

    def get_all_records(self, domain: str):
        data = self.__client._getData()
        if not domain in data:
            _logger.error("No data found for this domain")
            return

        records = self.__client._getRecordList(domain, data.get(domain, ""))

        if not records:
            _logger.error("No records for this domain")

        return records

    def get_current_public_ip(self):
        if not self.__use_dig_cmd:
            return self.__client.getPublicIP()
        else:
            cmd = [
                "dig",
                "@resolver1.opendns.com",
                "ANY",
                "myip.opendns.com",
                "+short",
                "-4",
            ]
            process = subprocess.run(cmd, check=True, stdout=subprocess.PIPE)
            output = process.stdout.decode("UTF-8").strip("\n")
            if "failed" in output:
                raise ConnectionError(output)
            return output

    def update_all_domain_records_to_current_public_ip(self, domain: str):
        pub_ip = self.get_current_public_ip()
        _logger.info(f"Public IP: {pub_ip}")
        records = self.get_all_records(domain)
        _logger.debug(f"Records: {records}")
        for record in records:
            record_name = record[0]
            record_type = record[1]
            record_ttl = record[2]
            # _logger.debug(f"TTL: {self.__ttl}")
            self.__client.setRecord(
                domain, record_name, record_type, pub_ip, ttl=int(record_ttl)
            )
            _logger.info(f"Record {record_name} updated!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        "Freenom Domain Updater", description="CLI for update Freenom domains"
    )

    parser.add_argument("-v", "--log-level", default="INFO", help="log level")
    parser.add_argument(
        "-u", "--username", required=True, help="username of Freenom's account"
    )
    parser.add_argument(
        "-p", "--password", required=True, help="password of Freenom's account"
    )
    parser.add_argument(
        "-d", "--domains", required=True, help="list of domains to update"
    )
    parser.add_argument(
        "--ttl", type=int, default=300, help="TTL value to set the records"
    )
    parser.add_argument(
        "--public-ip-from-dig",
        action="store_true",
        help="Use dig command to get public IP",
    )

    args = parser.parse_args()

    logging.basicConfig(
        level=args.log_level, format="%(asctime)s - [%(levelname)s] - %(message)s",
    )
    _logger = logging.getLogger(__name__)

    client = FreenomClient(
        args.username, args.password, args.ttl, args.public_ip_from_dig
    )
    for domain in args.domains.split(","):
        client.update_all_domain_records_to_current_public_ip(domain)


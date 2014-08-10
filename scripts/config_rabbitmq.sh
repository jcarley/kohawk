#!/usr/bin/env bash

/usr/sbin/rabbitmqctl add_user dev dev
/usr/sbin/rabbitmqctl set_user_tags dev administrator
/usr/sbin/rabbitmqctl add_vhost local
/usr/sbin/rabbitmqctl set_permissions -p local dev '.*' '.*' '.*'
/usr/local/bin/rabbitmqadmin declare exchange --vhost=local --user=dev --password=dev name=kohawk type=topic
/usr/local/bin/rabbitmqadmin declare queue name=test durable=true auto_delete=false -u dev -p dev -V local
/usr/local/bin/rabbitmqadmin declare binding source=kohawk destination_type=queue destination=test routing_key=event.* -u dev -p dev -V local

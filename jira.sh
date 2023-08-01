#!/bin/sh

echo "Publishing comment to Jira issue ${PLUGIN_JIRA_ISSUE}..."

if [ -n "${PLUGIN_MESSAGE_FROM_FILE}" ]; then
	curl \
		-X POST \
		-H 'X-Atlassian-Token: no-check' \
		-u ${PLUGIN_USER}:${PLUGIN_PASSWORD} \
		--form "file=@${PLUGIN_MESSAGE_FROM_FILE}" \
		${PLUGIN_JIRA_HOST}/rest/api/3/issue/${PLUGIN_JIRA_ISSUE}/attachments

	ATTACHEMENT_NAME=$(basename ${PLUGIN_MESSAGE_FROM_FILE})

	curl \
		-X POST \
		-H "Content-Type: application/json" \
		-u ${PLUGIN_USER}:${PLUGIN_PASSWORD} \
		--data "{\"body\": \"Please find attached the logs for this control [^${ATTACHEMENT_NAME}]\" }" \
		${PLUGIN_JIRA_HOST}/rest/api/2/issue/${PLUGIN_JIRA_ISSUE}/comment
		# --data "{\"body\": {\"content\": [{\"content\": [{\"text\": \"Please find attached the logs for this control [^${ATTACHEMENT_NAME}]\", \"type\": \"text\"}], \"type\": \"paragraph\"}], \"type\": \"doc\", \"version\": 1}}" \
fi

if [ -n "${PLUGIN_MESSAGE}" ]; then
	curl \
		-u ${PLUGIN_USER}:${PLUGIN_PASSWORD} \
		-X POST \
		--data "{\"body\": \"${PLUGIN_MESSAGE}\"}"\
		-H "Content-Type: application/json" \
		${PLUGIN_JIRA_HOST}/rest/api/2/issue/${PLUGIN_JIRA_ISSUE}/comment
fi

if [ -n "${PLUGIN_FIELD_NAME}" ]; then
	curl \
		-u ${PLUGIN_USER}:${PLUGIN_PASSWORD} \
		-X PUT \
		--data "{\"fields\": {\"${PLUGIN_FIELD_NAME}\":${PLUGIN_FIELD_VALUE}}}"\
		-H "Content-Type: application/json" \
		${PLUGIN_JIRA_HOST}/rest/api/2/issue/${PLUGIN_JIRA_ISSUE};
fi

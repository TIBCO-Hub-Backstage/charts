{{/*
Return the proper image name
*/}}
{{- define "backstage.image" -}}
{{- $imageValues := dict "tag" (.Values.backstage.image.tag | default (include "tibco-hub.generated.buildNumber" .)) -}}
{{ include "common.images.image" (dict "imageRoot" (merge $imageValues .Values.backstage.image) "global" .Values.global) }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "backstage.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "backstage.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgres Database hostname
*/}}
{{- define "backstage.postgresql.host" -}}
{{- if eq .Values.postgresql.architecture "replication" }}
{{- include "backstage.postgresql.fullname" . -}}-primary
{{- else -}}
{{- include "backstage.postgresql.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgres Database Secret Name
*/}}
{{- define "backstage.postgresql.databaseSecretName" -}}
{{- if .Values.postgresql.auth.existingSecret }}
    {{- tpl .Values.postgresql.auth.existingSecret $ -}}
{{- else -}}
    {{- default (include "backstage.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgres databaseSecret key to retrieve credentials for database
*/}}
{{- define "backstage.postgresql.databaseSecretKey" -}}
{{- if .Values.postgresql.auth.existingSecret -}}
    {{- .Values.postgresql.auth.secretKeys.userPasswordKey  -}}
{{- else -}}
    {{- print "password" -}}
{{- end -}}
{{- end -}}

{{- define "tibcohub.platform.commonLabels" -}}
{{- if ((.Values.global.cp).dataPlaneId) }}platform.tibco.com/dataplane-id: {{ .Values.global.cp.dataplaneId | quote }}{{- end }}
{{- if ((.Values.global.cp).instanceId) }}
platform.tibco.com/capability-instance-id: {{ .Values.global.cp.instanceId | quote }}
{{- end }}
platform.tibco.com/workload-type: capability-service
{{- end -}}

{{/*
Form a URL using Control Plane hostname
*/}}
{{- define "tibcohub.cp.url" -}}
{{- $ctx := .context | default . -}}
{{- $url := $ctx.Values.global.cp.cpHostname | trimSuffix "/" -}}
{{- if not (regexMatch "^http[s]://" $url) -}}
    {{- $url = print "https://" $url -}}
{{- end -}}
{{- if .path -}}
    {{- $url = print $url "/" (.path | trimPrefix "/") -}}
{{- end -}}
{{- print $url -}}
{{- end -}}

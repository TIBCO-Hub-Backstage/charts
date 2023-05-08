{{/* Name of the app secrets */}}
{{- define "backstage.appEnvSecretsName" }}backstage-app-secrets{{ end -}}

{{- define "backstage.tibcoEnvSecretsName" }}{{ include "common.names.fullname" . }}-tibco-env{{ end -}}

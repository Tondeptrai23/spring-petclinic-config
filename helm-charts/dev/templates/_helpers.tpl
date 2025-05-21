{{/*
generate a fullname for the release
*/}}
{{- define "petclinic.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
return the name of the app (release)
*/}}
{{- define "petclinic.name" -}}
{{ .Release.Name }}
{{- end }}
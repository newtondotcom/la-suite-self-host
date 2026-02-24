# mosacloud umbrella helm chart

This chart deploys mosacloud projects that currently provide Helm charts as subcharts.

## Included projects

- `drive` (from `mosacloud/drive/src/helm/drive`)
- `meet` (from `mosacloud/meet/src/helm/meet`)
- `impress` (alias of `docs` chart from `mosacloud/docs/src/helm/impress`)

## Not included yet

The following mosacloud projects do not currently expose Helm charts in this repository and are therefore not dependencies of this umbrella chart:

- `django-lasuite`
- `docspecio`
- `jmap-mcp`
- `messages`
- `whisper-openai-api`

## Usage

From the chart directory:

```bash
helm dependency update .
helm upgrade --install mosacloud . -n mosacloud --create-namespace
```

## Enable/disable projects

In `values.yaml`, each subchart can be toggled:

```yaml
drive:
  enabled: true
meet:
  enabled: true
impress:
  enabled: true
```

You can pass any subchart values under the same keys (`drive`, `meet`, `impress`).

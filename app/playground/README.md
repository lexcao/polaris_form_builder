# Playground

This directory contains the Rails app used for `polaris_form_builder` demos and integration verification.

## Local Development

After installing dependencies from the repository root, you can start the Playground directly:

```bash
cd app/playground
bin/rails server
```

## Deployment

```shell
$ SERVER_IP={} kamal setup
```

## Deployment Layout

The Playground deployment configuration lives under `app/playground`, not at the repository root:

- `app/playground/config/deploy.yml`
- `app/playground/Dockerfile`
- `app/playground/.kamal/`

These files describe how the Playground Rails app is built and deployed. They are not part of the gem release workflow.

## Monorepo Notes

Although the deployment configuration belongs to `app/playground`, the Kamal build context must point at the repository root.

The reason is that the Playground `Gemfile` uses a path gem:

```ruby
gem "polaris_form_builder", path: "../.."
```

If the Docker build context only includes `app/playground`, or if the Dockerfile does not preserve the repository root layout inside the image, `bundle install` will fail when resolving the path gem.

The current deployment constraints are:

- `app/playground/config/deploy.yml` declares the Kamal configuration for the Playground
- `builder.context` points to the repository root
- `builder.dockerfile` points to `app/playground/Dockerfile`
- Dockerfile `COPY` source paths should be written explicitly relative to the repository root
- Dockerfile `WORKDIR` only affects the execution directory inside the container, not how `COPY` source paths are resolved

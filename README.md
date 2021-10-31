# HotCodeReloading

This is a basic Phoenix application to check Hot Code Reloading.

# Run

```
$ docker-compose run --rm --service-ports elixir /bin/bash
elixir@894e2847dd5f:/var/opt/app$ mix deps.get
elixir@894e2847dd5f:/var/opt/app$ mix phx.server
```

# Check updating
## Release 1.0
At first, checkout `release-1.0` branch.

```
$ git checkout -b release-1.0 origin/release-1.0
$ mkdir tmp
```

And generate 1.0 release.

```
elixir@894e2847dd5f:/var/opt/app$ MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix phx.digest && MIX_ENV=prod mix distillery.release --env=prod
elixir@894e2847dd5f:/var/opt/app$ cp _build/prod/rel/hot_code_reloading/releases/1.0.3/hot_code_reloading.tar.gz tmp/hot_code_reloading.tar.gz
elixir@894e2847dd5f:/var/opt/app$ cd tmp
elixir@894e2847dd5f:/var/opt/app/tmp$ tar -xzf hot_code_reloading.tar.gz
elixir@894e2847dd5f:/var/opt/app/tmp$ bin/hot_code_reloading start
```

You can access `http://localhost:4000`.

## Update to 2.0
Checkout `release-2.0` branch.

```
$ git checkout -b release-2.0 origin/release-2.0
```

And generate 2.0 upgrade package.

```
elixir@894e2847dd5f:/var/opt/app$ MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix phx.digest && MIX_ENV=prod mix distillery.release --env=prod --upgrade --upfrom=1.0.3
elixir@894e2847dd5f:/var/opt/app$ cp _build/prod/rel/hot_code_reloading/releases/2.0.1/hot_code_reloading.tar.gz tmp/releases/2.0.1/hot_code_reloading.tar.gz
elixir@894e2847dd5f:/var/opt/app$ tmp/bin/hot_code_reloading upgrade 2.0.1
```

## Update to 2.1
Checkout `release-2.1` branch.

```
$ git checkout -b release-2.1 origin/release-2.1
```

And generate 2.1 upgrade package.

```
elixir@894e2847dd5f:/var/opt/app$ MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix phx.digest && MIX_ENV=prod mix distillery.release --env=prod --upgrade --upfrom=2.0.1
elixir@894e2847dd5f:/var/opt/app$ cp _build/prod/rel/hot_code_reloading/releases/2.1.1/hot_code_reloading.tar.gz tmp/releases/2.1.1/hot_code_reloading.tar.gz
elixir@894e2847dd5f:/var/opt/app$ tmp/bin/hot_code_reloading upgrade 2.1.1
```


## Update to 2.2
Checkout `release-2.2` branch.

```
$ git checkout -b release-2.2 origin/release-2.2
```

And generate 2.2 upgrade package.

```
elixir@894e2847dd5f:/var/opt/app$ MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix phx.digest && MIX_ENV=prod mix distillery.release --env=prod --upgrade --upfrom=2.1.1
elixir@894e2847dd5f:/var/opt/app$ cp _build/prod/rel/hot_code_reloading/releases/2.2.0/hot_code_reloading.tar.gz tmp/releases/2.2.0/hot_code_reloading.tar.gz
elixir@894e2847dd5f:/var/opt/app$ tmp/bin/hot_code_reloading upgrade 2.2.0
```

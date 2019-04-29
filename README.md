hl
=================

## About

This repo contains docker image for building the hl images.

## Setting up

First download the [hl](https://raw.githubusercontent.com/soleen/hl/master/hl) as `~/bin/hl`

```sh
mkdir -p ~/bin
curl https://raw.githubusercontent.com/soleen/hl/master/hl > ~/bin/hl
chmod +x ~/bin/hl
```

Add following line to the `~/.bashrc` file to ensure that the `~/bin` folder is in you PATH variable.

```sh
export PATH=~/bin:$PATH
```

## Basic Usage

First time to use the `hl` command, you need to tell it where is the workdir.

For example:

```sh
hl --workdir /home/soleen/highlands
```

After this command, we'll create a container named `hl`, which is the environment we used to work.

## Spawn a new shell

If you want to spawn a new shell in another terminal, you can use

```sh
hl --shell
```

This will spawn a new shell if you already specify a workdir.

## Remove the container

This script only support *ONLY ONE CONTAINER*, so If you want to change the workdir, you should remove it first, remove a container is easy, just use following command:

```sh
hl --rm
```

Then you can setup a new workdir you want.

## Upgrade script

Upgrade this script is easy, just type

```sh
hl --upgrade
```

## Pull new docker container

To pull new docker image, just type

```sh
hl --pull
```

# fetch-selections

A Utility for multi-stage build on Dockerfile

## Usage

__Dockerfile__

```Dockerfile
COPY ./dub.selections.json /path/to/project/
WORKDIR /path/to/project/
RUN dub run fetch-selections

COPY . /path/to/project/
RUN dub build
```

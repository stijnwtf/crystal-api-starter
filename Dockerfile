# Build a fully static binary on Alpine, then ship it in an empty image.
FROM crystallang/crystal:1.21.1-alpine AS build
WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production
COPY src src
RUN shards build app --release --static --no-debug

FROM scratch
COPY --from=build /app/bin/app /app
ENV PORT=3000
EXPOSE 3000
ENTRYPOINT ["/app"]
